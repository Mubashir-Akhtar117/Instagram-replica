import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sample/features/auth/presentation/bloc/signin_states.dart';
import 'signin_event.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  SigninBloc() : super(const SigninState()) {
    on<SigninRequested>(_onSignin);
  }

  Future<void> _onSignin(
    SigninRequested event,
    Emitter<SigninState> emit,
  ) async {
    emit(state.copyWith(status: SigninStatus.loading));

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      emit(state.copyWith(status: SigninStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: SigninStatus.failure,
        error: e.toString(),
      ));
    }
  }
}