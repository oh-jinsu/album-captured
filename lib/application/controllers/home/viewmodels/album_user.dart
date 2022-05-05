import 'package:album/application/controllers/home/models/album_user.dart';

class AlbumUserViewModel {
  final String id;
  final String? avatarImageUri;

  AlbumUserViewModel({
    required this.id,
    required this.avatarImageUri,
  });

  factory AlbumUserViewModel.fromModel(AlbumUserModel model) {
    return AlbumUserViewModel(
      id: model.id,
      avatarImageUri: model.avatarImageUri,
    );
  }
}
