import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:sample/core/error/failure.dart';
import 'package:sample/features/auth/data/dataSource/auth_remote_datasource.dart';
import 'package:sample/features/auth/donain/entities/user.dart';
import 'package:sample/features/auth/donain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, UserEntity>> signUp({
    required String name,
    required String email,
    required String password,
    required File profileImage,
  }) async {
    try {
      final user = await remote.signUp(
        name: name,
        email: email,
        password: password,
        profileImage: profileImage,
      );

      return Right(user);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remote.signIn(
        email: email,
        password: password,
      );

      return Right(user);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}