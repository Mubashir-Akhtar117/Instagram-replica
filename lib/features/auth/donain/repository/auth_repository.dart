import 'dart:io';

import 'package:sample/features/auth/donain/entities/user.dart';

abstract class AuthRepository {
  Future<UserEntity> signUp({
    required String name,
    required String email,
    required String password,
    required File profileImage,
  });

  Future<UserEntity> signIn({required String email, required String password});
}
