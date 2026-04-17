import 'package:sample/features/auth/donain/entities/user.dart';

import '../../domain/repository/user_repository.dart';
import '../datasource/user_remote_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity> getUserProfile(String uid) {
    return remoteDataSource.getUserProfile(uid);
  }
}
