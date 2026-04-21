import 'package:dartz/dartz.dart';
import 'package:sample/core/error/failure.dart';
import 'package:sample/features/auth/donain/entities/user.dart';
import 'package:sample/features/auth/donain/repository/auth_repository.dart';


import 'signup_params.dart';

class SignupUseCase {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(SignupParams params) {
    return repository.signUp(
      name: params.name,
      email: params.email,
      password: params.password,
      profileImage: params.profileImage,
    );
  }
}