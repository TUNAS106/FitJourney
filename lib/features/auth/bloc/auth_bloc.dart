import 'package:bloc/bloc.dart';
import '../../../services/firebase_services.dart';
import '../data/models/User.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;

  AuthBloc() : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
    on<RegisterRequested>(_onRegisterRequested);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser != null) {
      final firestoreUser = await fetchUserFromFirestore(firebaseUser.uid);
      if (firestoreUser != null) {
        emit(Authenticated(firestoreUser));
      } else {
        final fallbackUser = User(
          id: firebaseUser.uid,
          name: firebaseUser.displayName ?? '',
          email: firebaseUser.email ?? '',
          gender: '',
          age: 0,
          avatarUrl: firebaseUser.photoURL ?? '',
          isVip: false,
          vipExpiry: null,
          activePlans: [],

          isPT: false,
          challenge: 1,
          phoneNumber: null,
          bio: null,
          location: null,
        );
        emit(Authenticated(fallbackUser));
      }
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onLoggedIn(LoggedIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: event.email, password: event.password);
      final firebaseUser = credential.user;

      final firestoreUser = await fetchUserFromFirestore(firebaseUser!.uid);
      if (firestoreUser != null) {
        emit(Authenticated(firestoreUser));
      } else {
        final fallbackUser = User(
          id: firebaseUser.uid,
          name: firebaseUser.displayName ?? '',
          email: firebaseUser.email ?? '',
          gender: '',
          age: 0,
          avatarUrl: firebaseUser.photoURL ?? '',
          isVip: false,
          vipExpiry: null,
          activePlans: [],
          isPT: false, // Default value for isPT
          challenge: 1,
          phoneNumber: null,
          bio: null,
          location: null,
        );
        emit(Authenticated(fallbackUser));
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? "Login failed"));
      emit(Unauthenticated());
    }
  }

  Future<void> _onLoggedOut(LoggedOut event, Emitter<AuthState> emit) async {
    await _firebaseAuth.signOut();
    emit(Unauthenticated());
  }

  Future<void> _onRegisterRequested(
      RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      final firebaseUser = credential.user;

      final user = User(
        id: firebaseUser!.uid,
        name: event.name,
        email: event.email,
        gender: event.gender,
        age: event.age,
        avatarUrl: firebaseUser.photoURL ?? '',
        isVip: false,
        vipExpiry: null,
        activePlans: [],
        isPT: false, // Default value for isPT
        challenge: 1,
        phoneNumber: null,
        bio: null,
        location: null,
      );

      await db.collection('users').doc(firebaseUser.uid).set({
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'gender': user.gender,
        'age': user.age,
        'avatarUrl': user.avatarUrl,
        'isVip': user.isVip,
        'vipExpiry': user.vipExpiry?.toIso8601String(),
        'isPT': user.isPT,
        'phoneNumber': null,
        'bio': null,
        'location': null,
      });

      final firestoreUser = await fetchUserFromFirestore(firebaseUser.uid);
      if (firestoreUser != null) {
        emit(Authenticated(firestoreUser));
      } else {
        emit(AuthError("Failed to fetch user after registration"));
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? "Registration failed"));
      emit(Unauthenticated());
    }
  }

  Future<User?> fetchUserFromFirestore(String uid) async {
    try {
      final doc = await db.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        return User(
          id: uid,
          name: data['name'] ?? '',
          email: data['email'] ?? '',
          gender: data['gender'] ?? '',
          age: data['age'] ?? 0,
          avatarUrl: data['avatarUrl'] ?? '',
          isVip: data['isVip'] ?? false,
          vipExpiry: data['vipExpiry'] != null ? DateTime.parse(data['vipExpiry']) : null,
          isPT: data['isPT'] ?? false,
          phoneNumber: data['phoneNumber'],
          bio: data['bio'],
          location: data['location'],
          activePlans: [],
          challenge: data['challenge'],
        );
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching user from Firestore: $e');
      return null;
    }
  }

  Future<void> updateUserInfoDirect({
    required String name,
    required String email,
    required String gender,
    required int age,
    String? phoneNumber,
    String? bio,
    String? location,
  }) async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid != null) {
      try {
        final updateData = {
          'name': name,
          // 'email': email,  // không cập nhật email
          'gender': gender,
          'age': age,
        };

        if (phoneNumber != null && phoneNumber.isNotEmpty) {
          final phoneRegex = RegExp(r'^0\d{9}$');
          if (phoneRegex.hasMatch(phoneNumber)) {
            updateData['phoneNumber'] = phoneNumber;
          } else {

          }
        }
        if (bio != null) updateData['bio'] = bio;
        if (location != null) updateData['location'] = location;

        await db.collection('users').doc(uid).update(updateData);

        // Reload user info và emit state mới
        await reloadCurrentUser();
      } catch (e) {
        print('Error updating user info: $e');
        // Có thể emit một state lỗi nếu muốn thông báo UI
        // emit(AuthError('Failed to update user info'));
      }
    } else {
      print('No user UID found');
    }
  }


  Future<void> reloadCurrentUser() async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid != null) {
      final updatedUser = await fetchUserFromFirestore(uid);
      if (updatedUser != null) {
        emit(Authenticated(updatedUser));
      }
    }
  }

  Future<void> upgradeToVip({required int days}) async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid != null) {
      final expiry = DateTime.now().add(Duration(days: days));
      await db.collection('users').doc(uid).update({
        'isVip': true,
        'vipExpiry': expiry.toIso8601String(),
      });
    }
  }

  Future<void> upgradeToPT() async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid != null) {
      await db.collection('users').doc(uid).update({
        'isPT': true,
      });
    }
  }
}
