import 'dart:io';
import 'package:equatable/equatable.dart';

class SignupParams extends Equatable {
  final String name;
  final String email;
  final String password;
  final File profileImage;

  const SignupParams({
    required this.name,
    required this.email,
    required this.password,
    required this.profileImage,
  });

  @override
  List<Object?> get props => [name, email, password, profileImage];
}