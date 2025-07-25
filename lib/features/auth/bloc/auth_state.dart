import 'package:equatable/equatable.dart';

import '../data/models/User.dart';




abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

//trạng thái ban đầu khi Bloc vừa khởi tạo.
class AuthInitial extends AuthState {}
//trạng thái khi đang tải dữ liệu, ví dụ như khi đăng nhập hoặc đăng ký
class AuthLoading extends AuthState {}
//trạng thái khi người dùng đã đăng nhập thành công
class Authenticated extends AuthState {
  final User user;
  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}
//trạng thái khi người dùng chưa đăng nhập
class Unauthenticated extends AuthState {}
// trạng thái khi có lỗi xảy ra trong quá trình xác thực, ví dụ như đăng nhập thất bại
class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);

  @override
  List<Object?> get props => [message];// so sánh thông điệp lỗi
}
