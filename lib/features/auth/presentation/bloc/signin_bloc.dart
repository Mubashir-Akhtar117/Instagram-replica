import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample/features/auth/donain/usecase/signin_usecase.dart';
import 'signin_event.dart';
import 'signin_states.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  final SigninUseCase signinUseCase;

  SigninBloc(this.signinUseCase) : super(const SigninState()) {
    on<SigninRequested>(_onSignin);
  }

  Future<void> _onSignin(
    SigninRequested event,
    Emitter<SigninState> emit,
  ) async {
    emit(state.copyWith(status: SigninStatus.loading, error: null));

    final result = await signinUseCase.call(
      SigninParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(status: SigninStatus.failure, error: failure.message),
        );
      },
      (user) {
        emit(state.copyWith(status: SigninStatus.success, user: user));
      },
    );
  }
}
