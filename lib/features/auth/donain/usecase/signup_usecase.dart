import 'package:sample/core/usecase/usecase.dart';
import 'package:sample/features/auth/donain/entities/user.dart';
import 'package:sample/features/auth/donain/repository/auth_repository.dart';


import 'signup_params.dart';

class SignupUseCase implements UseCase<UserEntity, SignupParams> {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  @override
  Future<UserEntity> call(SignupParams params) {
    return repository.signUp(
      name: params.name,
      email: params.email,
      password: params.password,
      profileImage: params.profileImage,
    );
  }
}