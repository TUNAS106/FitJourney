// import '../../domain/entities/user_entity.dart';
// import '../../domain/repositories/auth_repository.dart';
// import '../datasources/auth_remote_datasource.dart';
//
// class AuthRepositoryImpl implements AuthRepository {
//   final AuthRemoteDatasource remoteDatasource;
//
//   AuthRepositoryImpl(this.remoteDatasource);
//
//   @override
//   Future<UserEntity> login(String email, String password) async {
//     final user = await remoteDatasource.login(email, password);
//     return UserEntity(
//       uid: user.uid,
//       email: user.email ?? '',
//       displayName: user.displayName,
//     );
//   }
//
//   @override
//   Future<UserEntity> register(String email, String password) async {
//     final user = await remoteDatasource.register(email, password);
//     return UserEntity(
//       uid: user.uid,
//       email: user.email ?? '',
//       displayName: user.displayName,
//     );
//   }
//
//   @override
//   Future<void> logout() async {
//     await remoteDatasource.logout();
//   }
// }