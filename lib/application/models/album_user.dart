import 'package:album/application/controllers/signup/models/form.dart';

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

  factory AlbumUserModel.fromJson(Map<String, dynamic> json) {
    return AlbumUserModel(
      id: json["id"],
      avatarImageUri: json["avatar_image_uri"],
      name: json["name"],
      joinedAt: json["joined_at"],
    );
  }

  AlbumUserModel copy({
    Arg<String>? id,
    Arg<String?>? avatarImageUri,
    Arg<String>? name,
    Arg<DateTime>? joinedAt,
  }) {
    return AlbumUserModel(
      id: id != null ? id.value : this.id,
      avatarImageUri:
          avatarImageUri != null ? avatarImageUri.value : this.avatarImageUri,
      name: name != null ? name.value : this.name,
      joinedAt: joinedAt != null ? joinedAt.value : this.joinedAt,
    );
  }
}
