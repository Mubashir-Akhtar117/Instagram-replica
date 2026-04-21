import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample/features/auth/donain/usecase/signup_params.dart';
import 'package:sample/features/auth/donain/usecase/signup_usecase.dart';
import 'signup_state.dart';
import 'signup_event.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final SignupUseCase signupUseCase;

  SignupBloc(this.signupUseCase) : super(const SignupState()) {
    on<ProfileImageChanged>(_onProfileImageChanged);
    on<SignupRequested>(_onSignupRequested);
  }

  void _onProfileImageChanged(
    ProfileImageChanged event,
    Emitter<SignupState> emit,
  ) {
    emit(state.copyWith(profileImage: event.profileImage));
  }

  Future<void> _onSignupRequested(
    SignupRequested event,
    Emitter<SignupState> emit,
  ) async {
    emit(state.copyWith(status: SignupStatus.loading));

    await signupUseCase.call(
      SignupParams(
        name: event.name,
        email: event.email,
        password: event.password,
        profileImage: event.profileImage,
      ),
    );

    emit(state.copyWith(status: SignupStatus.success));
  }
}
