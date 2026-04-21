import 'package:sample/features/auth/donain/entities/user.dart';

enum SigninStatus { initial, loading, success, failure }

class SigninState {
  final SigninStatus status;
  final String? error;
  final UserEntity? user;

  const SigninState({
    this.status = SigninStatus.initial,
    this.error,
    this.user,
  });

  SigninState copyWith({
    SigninStatus? status,
    String? error,
    UserEntity? user,
  }) {
    return SigninState(
      status: status ?? this.status,
      error: error,
      user: user ?? this.user,
    );
  }
}
