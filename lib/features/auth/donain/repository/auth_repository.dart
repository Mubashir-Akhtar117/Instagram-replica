import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:sample/core/error/failure.dart';
import 'package:sample/features/auth/donain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signUp({
    required String name,
    required String email,
    required String password,
    required File profileImage,
  });

  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  });
}