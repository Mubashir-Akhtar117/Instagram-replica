import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sample/features/auth/donain/entities/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sample/features/auth/data/dataSource/auth_remote_datasource.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserEntity> signUp({
    required String name,
    required String email,
    required String password,
    required File profileImage,
  }) async {
    final credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    final uid = credential.user!.uid;

    final fileExt = profileImage.path.split('.').last;
    final fileName = '$uid.$fileExt';
    final path = 'profile_images/$fileName';

    String imageUrl = '';

    try {
      final bytes = await profileImage.readAsBytes();

      await Supabase.instance.client.storage
          .from('avatar')
          .uploadBinary(path, bytes);

      final url = Supabase.instance.client.storage
          .from('avatar')
          .getPublicUrl(path);

      imageUrl = url;
    } catch (e) {
      rethrow;
    }

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'profile_url': imageUrl,
      'posts': 0,
      'followers': 0,
      'following': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return UserEntity(
      uid: uid,
      name: name,
      email: email,
      profileUrl: imageUrl,
      posts: 0,
      followers: 0,
      following: 0,
    );
  }

  @override
  Future<UserEntity> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    final data = doc.data() ?? {};

    return UserEntity.fromMap(data, uid);
  }
}
