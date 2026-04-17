import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object?> get props => [];
}

class ProfileImageChanged extends SignupEvent {
  final File profileImage;
  const ProfileImageChanged(this.profileImage);

  @override
  List<Object?> get props => [profileImage];
}

class SignupRequested extends SignupEvent {
  final String name;
  final String email;
  final String password;
  final File profileImage;

  const SignupRequested({
    required this.name,
    required this.email,
    required this.password,
    required this.profileImage,
  });

  @override
  List<Object?> get props => [name, email, password, profileImage];
}
