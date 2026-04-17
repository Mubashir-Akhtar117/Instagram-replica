import 'package:sample/features/auth/donain/entities/user.dart';


abstract class UserRemoteDataSource {
  Future<UserEntity> getUserProfile(String uid);
}