import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample/features/auth/donain/usecase/signup_params.dart';
import 'package:sample/features/auth/donain/usecase/signup_usecase.dart';
import 'signup_state.dart';
import 'signup_event.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final SignupUseCase signupUseCase;

  SignupBloc(this.signupUseCase) : super(const SignupState()) {
    on<ProfileImageChanged>((event, emit) {
      emit(state.copyWith(profileImage: event.profileImage));
    });

    on<SignupRequested>((event, emit) async {
      emit(state.copyWith(status: SignupStatus.loading));

      try {
        await signupUseCase.call(
          SignupParams(
            name: event.name,
            email: event.email,
            password: event.password,
            profileImage: event.profileImage,
          ),
        );

        emit(state.copyWith(status: SignupStatus.success));
      } catch (e) {
        emit(state.copyWith(status: SignupStatus.failure, error: e.toString()));
      }
    });
  }
}
