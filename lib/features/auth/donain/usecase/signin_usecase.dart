import 'package:dartz/dartz.dart';
import 'package:sample/core/error/failure.dart';
import 'package:sample/features/auth/donain/entities/user.dart';
import 'package:sample/features/auth/donain/repository/auth_repository.dart';

class SigninParams {
  final String email;
  final String password;

  SigninParams({required this.email, required this.password});
}

class SigninUseCase {
  final AuthRepository repository;

  SigninUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(SigninParams params) {
    return repository.signIn(email: params.email, password: params.password);
  }
}
