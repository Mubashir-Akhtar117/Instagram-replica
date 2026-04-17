import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StoryRemoteDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> createStory(File file) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final compressed = await FlutterImageCompress.compressAndGetFile(
      file.path,
      "${file.path}_c.jpg",
      quality: 60,
    );

    final finalFile = File(compressed?.path ?? file.path);

    final path = 'stories/${DateTime.now().millisecondsSinceEpoch}';

    await supabase.storage.from('avatar').upload(path, finalFile);

    final url = supabase.storage.from('avatar').getPublicUrl(path);

    await firestore.collection('stories').add({
      'userId': user.uid,
      'mediaUrl': url,
      'time': DateTime.now().toIso8601String(),
      'viewedBy': [],
      'type': file.path.toLowerCase().contains('.mp4') ? 'video' : 'image',
    });
  }

  Future<List<Map<String, dynamic>>> getStories() async {
    final snap = await firestore
        .collection('stories')
        .orderBy('time', descending: true)
        .get();

    return snap.docs.map((e) => {'id': e.id, ...e.data()}).toList();
  }
}
