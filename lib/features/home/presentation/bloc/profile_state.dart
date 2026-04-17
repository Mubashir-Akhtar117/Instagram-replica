import 'package:equatable/equatable.dart';
import 'package:sample/features/auth/donain/entities/user.dart';

enum ProfileStatus { initial, loading, loaded, error }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final UserEntity? user;
  final String? error;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.user,
    this.error,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    UserEntity? user,
    String? error,
  }) {
    return ProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, user, error];
}