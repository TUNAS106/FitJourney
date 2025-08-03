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

  // Hàm này sẽ được gọi khi ứng dụng bắt đầu, kiểm tra trạng thái đăng nhập
  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser != null) {
      final firestoreUser = await fetchUserFromFirestore(firebaseUser.uid);
      if (firestoreUser != null) {
        emit(Authenticated(firestoreUser));
      } else { // Nếu không tìm thấy người dùng trong Firestore, tạo một người dùng mặc định
        final fallbackUser = User(
          id: firebaseUser.uid,
          name: firebaseUser.displayName ?? '',
          email: firebaseUser.email ?? '',
          gender: '',
          age: 0,
          avatarUrl: firebaseUser.photoURL ?? '',
        );
        emit(Authenticated(fallbackUser));
      }
    } else {
      emit(Unauthenticated());
    }
  }
  // Hàm này sẽ được gọi khi người dùng đăng nhập thành công, nó sẽ lấy thông tin người dùng từ Firestore
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

  // Hàm này sẽ được gọi khi người dùng yêu cầu đăng ký, nó sẽ tạo một người dùng mới trong Firebase Auth và Firestore
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
      );

      // 🔹 Save user to Firestore
      await db.collection('users').doc(firebaseUser.uid).set({
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'gender': user.gender,
        'age': user.age,
        'avatarUrl': user.avatarUrl,
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
  // Hàm này sẽ lấy thông tin người dùng từ Firestore dựa trên uid
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
  }) async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid != null) {
      try {
        await db.collection('users').doc(uid).update({
          'name': name,
          'email': email,
          'gender': gender,
          'age': age,
        });
      } catch (e) {
        print('Error updating user info: $e');
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
}