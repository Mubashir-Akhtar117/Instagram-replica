import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sample/features/auth/donain/entities/user.dart';
import 'user_remote_datasource.dart';

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  @override
  Future<UserEntity> getUserProfile(String uid) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    return UserEntity.fromMap(doc.data()!, uid);
  }
}