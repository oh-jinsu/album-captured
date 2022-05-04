import 'package:album/application/screens/home/models/album_user.dart';

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
}
