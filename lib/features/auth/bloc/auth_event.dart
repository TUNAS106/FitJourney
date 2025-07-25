import 'package:equatable/equatable.dart';

//class cha trừu tượng cho các sự kiện, kế thừa từ Equatable để so sánh giá trị
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

//sự kiện khi app khởi động, dùng để kiểm tra trạng thái đăng nhập
class AppStarted extends AuthEvent {}

//sự kiện khi người dùng đăng nhập, chứa email và mật khẩu
class LoggedIn extends AuthEvent {
  final String email;
  final String password;

  const LoggedIn(this.email, this.password);

  @override
  List<Object?> get props => [email, password];// so sánh email và mật khẩu
}

//sự kiện khi người dùng đăng xuất
class LoggedOut extends AuthEvent {}

//sự kiện khi người dùng yêu cầu đăng ký, chứa email và mật khẩu
class RegisterRequested extends AuthEvent {
  final String name;
  final String gender;
  final int age;
  final String email;
  final String password;

  const RegisterRequested({
    required this.name,
    required this.gender,
    required this.age,
    required this.email,
    required this.password,
  });

}


