import 'package:sample/features/auth/donain/entities/user.dart';


abstract class UserRepository {
  Future<UserEntity> getUserProfile(String uid);
}