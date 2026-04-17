import 'package:sample/features/home/domain/entities/post_entity.dart';


class PostCache {
  List<PostEntity>? posts;
  DateTime? lastFetched;

  bool get hasData => posts != null && posts!.isNotEmpty;
}