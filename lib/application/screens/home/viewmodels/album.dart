import 'package:album/application/screens/home/models/album.dart';
import 'package:album/application/screens/home/viewmodels/album_user.dart';

class AlbumViewModel {
  final String id;
  final String? coverImageUri;
  final String title;
  final List<AlbumUserViewModel> users;
  final int photoCount;

  AlbumViewModel({
    required this.id,
    required this.coverImageUri,
    required this.title,
    required this.users,
    required this.photoCount,
  });

  factory AlbumViewModel.fromModel(AlbumModel model) {
    return AlbumViewModel(
      id: model.id,
      coverImageUri: model.coverImageUri,
      title: model.title,
      users: model.users.map(AlbumUserViewModel.fromModel).toList(),
      photoCount: model.photoCount,
    );
  }
}
