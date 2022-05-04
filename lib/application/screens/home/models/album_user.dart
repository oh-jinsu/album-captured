class AlbumUserModel {
  final String id;
  final String? avatarImageUri;
  final String name;
  final DateTime joinedAt;

  AlbumUserModel({
    required this.id,
    required this.avatarImageUri,
    required this.name,
    required this.joinedAt,
  });
}
