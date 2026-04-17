import 'package:sample/features/auth/donain/entities/user.dart';

import '../repository/user_repository.dart';

class GetUserProfileUseCase {
  final UserRepository repository;

  GetUserProfileUseCase(this.repository);

  Future<UserEntity> call(String uid) {
    return repository.getUserProfile(uid);
  }
}