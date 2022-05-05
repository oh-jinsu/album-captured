import 'package:album/application/controllers/home/models/album_user.dart';

class AlbumModel {
  final String id;
  final String? coverImageUri;
  final String title;
  final List<AlbumUserModel> users;
  final int photoCount;

  AlbumModel({
    required this.id,
    required this.coverImageUri,
    required this.title,
    required this.users,
    required this.photoCount,
  });

  factory AlbumModel.fromJson(Map json) {
    return AlbumModel(
      id: json["id"],
      coverImageUri: json["cover_image_uri"],
      title: json["title"],
      photoCount: json["photo_count"],
      users: (json["users"] as List)
          .map(
            (e) => AlbumUserModel(
              id: e["id"],
              avatarImageUri: e["avatar_image_uri"],
              name: e["name"],
              joinedAt: DateTime.parse(e["joined_at"]),
            ),
          )
          .toList(),
    );
  }
}
