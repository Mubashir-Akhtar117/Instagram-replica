import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:sample/features/home/model/comment_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/post_entity.dart';

class PostRemoteDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final SupabaseClient supabase = Supabase.instance.client;

  final _postBox = Hive.box('postBox');
  static const String _cacheKey = 'cached_posts';

  bool _isRefreshing = false;

  List<PostEntity> _parseCached(dynamic cachedData) {
    if (cachedData == null) return [];

    try {
      dynamic decoded;

      if (cachedData is String) {
        decoded = jsonDecode(cachedData);
      } else if (cachedData is List) {
        decoded = cachedData;
      } else {
        return [];
      }

      return List.from(decoded).map((e) {
        final map = Map<String, dynamic>.from(e);

        return PostEntity(
          id: map['id'] ?? '',
          username: map['username'] ?? '',
          caption: map['caption'] ?? '',
          mediaUrl: map['mediaUrl'] ?? '',
          mediaType: (map['mediaType'] ?? 'image') == 'video'
              ? MediaType.video
              : MediaType.image,
          likes: map['likes'] ?? 0,
          time: map['time'] ?? '',

          likedBy: _safeStringList(map['likedBy']),
          comments: _safeComments(map['comments']),
        );
      }).toList();
    } catch (e) {
      print("cache parse error: $e");
      return [];
    }
  }

  List<String> _safeStringList(dynamic value) {
    if (value == null) return [];

    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }

    if (value is String) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is List) {
          return decoded.map((e) => e.toString()).toList();
        }
      } catch (_) {}
    }

    return [];
  }

  List<CommentModel> _safeComments(dynamic value) {
    if (value == null) return [];

    if (value is List) {
      return value.map((e) {
        final map = Map<String, dynamic>.from(e);
        return CommentModel.fromMap(map);
      }).toList();
    }

    if (value is String) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is List) {
          return decoded.map((e) {
            return CommentModel.fromMap(Map<String, dynamic>.from(e));
          }).toList();
        }
      } catch (_) {}
    }

    return [];
  }

  Future<List<PostEntity>> getPosts() async {
    try {
      final cachedData = _postBox.get(_cacheKey);

      if (cachedData != null) {
        final cachedPosts = _parseCached(cachedData);

        Future.microtask(() => _refreshInBackground());

        return cachedPosts;
      }

      final snapshot = await firestore
          .collection('posts')
          .orderBy('time', descending: true)
          .get();

      final posts = await Future.wait(
        snapshot.docs.map((doc) async {
          final data = doc.data();

          final commentSnap = await firestore
              .collection('posts')
              .doc(doc.id)
              .collection('comments')
              .orderBy('time', descending: true)
              .get();

          final comments = commentSnap.docs
              .map((c) => CommentModel.fromMap(c.data()))
              .toList();

          return PostEntity(
            id: doc.id,
            username: data['username'] ?? '',
            caption: data['caption'] ?? '',
            mediaUrl: data['mediaUrl'] ?? '',
            mediaType: (data['mediaType'] ?? 'image') == 'video'
                ? MediaType.video
                : MediaType.image,
            likes: data['likes'] ?? 0,
            time: data['time'] ?? '',
            likedBy: List<String>.from(data['likedBy'] ?? []),
            comments: comments,
          );
        }),
      );

      final safeCache = posts.map((e) => e.toMap()).toList();

      await _postBox.put(_cacheKey, jsonEncode(safeCache));

      return posts;
    } catch (e) {
      print("getPosts error: $e");

      final cachedData = _postBox.get(_cacheKey);

      if (cachedData != null) {
        return _parseCached(cachedData);
      }

      return [];
    }
  }

  Future<void> _refreshInBackground() async {
    if (_isRefreshing) return;

    _isRefreshing = true;

    try {
      final snapshot = await firestore
          .collection('posts')
          .orderBy('time', descending: true)
          .get();

      final posts = await Future.wait(
        snapshot.docs.map((doc) async {
          final data = doc.data();

          final commentSnap = await firestore
              .collection('posts')
              .doc(doc.id)
              .collection('comments')
              .orderBy('time', descending: true)
              .get();

          final comments = commentSnap.docs
              .map((c) => CommentModel.fromMap(c.data()))
              .toList();

          return PostEntity(
            id: doc.id,
            username: data['username'] ?? '',
            caption: data['caption'] ?? '',
            mediaUrl: data['mediaUrl'] ?? '',
            mediaType: (data['mediaType'] ?? 'image') == 'video'
                ? MediaType.video
                : MediaType.image,
            likes: data['likes'] ?? 0,
            time: data['time'] ?? '',
            likedBy: List<String>.from(data['likedBy'] ?? []),
            comments: comments,
          );
        }),
      );

      final safeCache = posts.map((e) => e.toMap()).toList();

      await _postBox.put(_cacheKey, jsonEncode(safeCache));
    } catch (e) {
      print("silent refresh error: $e");
    } finally {
      _isRefreshing = false;
    }
  }

  Future<List<CommentModel>> getComments(String postId) async {
    final snapshot = await firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('time', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => CommentModel.fromMap(doc.data()))
        .toList();
  }

  Stream<List<CommentModel>> getCommentsStream(String postId) {
    return firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('time', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => CommentModel.fromMap(doc.data()))
              .toList(),
        );
  }

  Future<String> uploadMedia(File file, String type) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final path = 'posts/$fileName';

    await supabase.storage.from('avatar').upload(path, file);

    return supabase.storage.from('avatar').getPublicUrl(path);
  }

  Future<void> createPost({
    required File file,
    required String caption,
    required MediaType mediaType,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final profileSnap = await firestore.collection('users').doc(user.uid).get();

    final username = profileSnap.data()?['name'] ?? 'Unknown';

    final mediaUrl = await uploadMedia(
      file,
      mediaType == MediaType.video ? 'video' : 'image',
    );

    await firestore.collection('posts').add({
      'username': username,
      'userId': user.uid,
      'caption': caption,
      'mediaUrl': mediaUrl,
      'mediaType': mediaType == MediaType.video ? 'video' : 'image',
      'likes': 0,
      'likedBy': [],
      'time': DateTime.now().toIso8601String(),
    });
  }

  Stream<List<PostEntity>> getPostsStream() {
    return firestore
        .collection('posts')
        .orderBy('time', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          return Future.wait(
            snapshot.docs.map((doc) async {
              final data = doc.data();

              final commentSnap = await firestore
                  .collection('posts')
                  .doc(doc.id)
                  .collection('comments')
                  .orderBy('time', descending: true)
                  .get();

              final comments = commentSnap.docs
                  .map((c) => CommentModel.fromMap(c.data()))
                  .toList();

              return PostEntity(
                id: doc.id,
                username: data['username'] ?? '',
                caption: data['caption'] ?? '',
                mediaUrl: data['mediaUrl'] ?? '',
                mediaType: (data['mediaType'] ?? 'image') == 'video'
                    ? MediaType.video
                    : MediaType.image,
                likes: data['likes'] ?? 0,
                time: data['time'] ?? '',
                likedBy: List<String>.from(data['likedBy'] ?? []),
                comments: comments,
              );
            }),
          );
        });
  }

  Future<void> addComment({
    required String postId,
    required String comment,
    required String userId,
  }) async {
    final userDoc = await firestore.collection('users').doc(userId).get();

    final user = userDoc.data();

    await firestore.collection('posts').doc(postId).collection('comments').add({
      'userId': userId,
      'userName': user?['name'] ?? 'Unknown',
      'userImage': user?['profile_url'] ?? '',
      'comment': comment,
      'time': DateTime.now().toIso8601String(),
    });
  }

  Future<void> toggleLike(String postId, String userId) async {
    final ref = firestore.collection('posts').doc(postId);

    await firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(ref);
      final data = snapshot.data() as Map<String, dynamic>;

      final List likedBy = List.from(data['likedBy'] ?? []);

      if (likedBy.contains(userId)) {
        likedBy.remove(userId);
      } else {
        likedBy.add(userId);
      }

      transaction.update(ref, {'likedBy': likedBy, 'likes': likedBy.length});
    });
  }
}
