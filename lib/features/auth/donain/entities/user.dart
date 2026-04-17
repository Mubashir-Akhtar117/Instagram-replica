class UserEntity {
  final String uid;
  final String name;
  final String email;
  final String profileUrl;
  final int posts;
  final int followers;
  final int following;

  UserEntity({
    required this.uid,
    required this.name,
    required this.email,
    required this.profileUrl,
    required this.posts,
    required this.followers,
    required this.following,
  });

  factory UserEntity.fromMap(Map<String, dynamic> map, String uid) {
    return UserEntity(
      uid: uid,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      profileUrl: map['profile_url'] ?? '',
      posts: map['posts'] ?? 0,
      followers: map['followers'] ?? 0,
      following: map['following'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'profile_url': profileUrl,
      'posts': posts,
      'followers': followers,
      'following': following,
    };
  }
}