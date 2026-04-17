import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sample/features/home/domain/usecase/get_user_profile_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfileUseCase useCase;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ProfileBloc(this.useCase) : super(const ProfileState()) {

    on<LoadProfileEvent>((event, emit) async {
      emit(state.copyWith(status: ProfileStatus.loading));

      try {
        final user = await useCase(event.uid);

        emit(state.copyWith(
          status: ProfileStatus.loaded,
          user: user,
        ));
      } catch (e) {
        emit(state.copyWith(
          status: ProfileStatus.error,
          error: e.toString(),
        ));
      }
    });

    on<LoadMyProfileEvent>((event, emit) async {
      emit(state.copyWith(status: ProfileStatus.loading));

      try {
        final uid = _auth.currentUser?.uid;

        if (uid == null) {
          emit(state.copyWith(
            status: ProfileStatus.error,
            error: "User not logged in",
          ));
          return;
        }

        final user = await useCase(uid);

        emit(state.copyWith(
          status: ProfileStatus.loaded,
          user: user,
        ));
      } catch (e) {
        emit(state.copyWith(
          status: ProfileStatus.error,
          error: e.toString(),
        ));
      }
    });

    on<RefreshProfileEvent>((event, emit) async {
      try {
        final uid = state.user?.uid ?? _auth.currentUser?.uid;

        if (uid == null) return;

        final user = await useCase(uid);

        emit(state.copyWith(
          status: ProfileStatus.loaded,
          user: user,
        ));
      } catch (e) {
        emit(state.copyWith(
          status: ProfileStatus.error,
          error: e.toString(),
        ));
      }
    });
  }
}