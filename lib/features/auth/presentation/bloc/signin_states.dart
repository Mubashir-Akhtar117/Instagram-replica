enum SigninStatus { initial, loading, success, failure }

class SigninState {
  final SigninStatus status;
  final String? error;

  const SigninState({
    this.status = SigninStatus.initial,
    this.error,
  });

  SigninState copyWith({
    SigninStatus? status,
    String? error,
  }) {
    return SigninState(
      status: status ?? this.status,
      error: error,
    );
  }
}