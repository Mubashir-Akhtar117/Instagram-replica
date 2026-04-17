import 'package:sample/features/auth/donain/entities/user.dart';
import 'package:sample/features/auth/donain/repository/auth_repository.dart';

class SigninUseCase {
  final AuthRepository repository;

  SigninUseCase(this.repository);

  Future<UserEntity> call({
    required String email,
    required String password,
  }) {
    return repository.signIn(
      email: email,
      password: password,
    );
  }
}