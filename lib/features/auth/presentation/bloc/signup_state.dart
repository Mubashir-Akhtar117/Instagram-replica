import 'dart:io';
import 'package:equatable/equatable.dart';

enum SignupStatus { initial, loading, success, failure }

class SignupState extends Equatable {
  final SignupStatus status;
  final File? profileImage;
  final String? error;

  const SignupState({
    this.status = SignupStatus.initial,
    this.profileImage,
    this.error,
  });

  SignupState copyWith({
    SignupStatus? status,
    File? profileImage,
    String? error,
  }) {
    return SignupState(
      status: status ?? this.status,
      profileImage: profileImage ?? this.profileImage,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, profileImage, error];
}