abstract class SigninEvent {}

class SigninRequested extends SigninEvent {
  final String email;
  final String password;

  SigninRequested({
    required this.email,
    required this.password,
  });
}