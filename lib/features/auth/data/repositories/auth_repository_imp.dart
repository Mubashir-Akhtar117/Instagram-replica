import 'dart:io';

import 'package:sample/features/auth/data/dataSource/auth_remote_datasource.dart';
import 'package:sample/features/auth/donain/entities/user.dart';
import 'package:sample/features/auth/donain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<UserEntity> signUp({
    required String name,
    required String email,
    required String password,
    required File profileImage,
  }) {
    return remote.signUp(
      name: name,
      email: email,
      password: password,
      profileImage: profileImage,
    );
  }

  @override
  Future<UserEntity> signIn({
    required String email,
    required String password,
  }) {
    return remote.signIn(
      email: email,
      password: password,
    );
  }
}