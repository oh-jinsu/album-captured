import 'package:album/application/controller.dart';
import 'package:album/application/events/album_added.dart';
import 'package:album/application/events/album_updated.dart';
import 'package:album/application/events/albums_found.dart';
import 'package:album/application/models/album.dart';
import 'package:album/application/models/album_user.dart';
import 'package:album/core/store/store.dart';

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

class AlbumListStore extends Store<List<AlbumViewModel>> {
  @override
  onListen() => of<App>()
    ..on<AlbumsFound>(_onAlbumsFound)
    ..on<AlbumAdded>(_onAlbumAdded)
    ..on<LatestPhotoAdded>(_onAlbumUpdated);

  List<AlbumViewModel> _onAlbumsFound(AlbumsFound event) {
    return event.body.items.map(AlbumViewModel.fromModel).toList();
  }

  List<AlbumViewModel> _onAlbumAdded(AlbumAdded event) {
    final newone = AlbumViewModel.fromModel(event.body);

    if (hasValue) {
      return [newone, ...value];
    }

    return [newone];
  }

  List<AlbumViewModel> _onAlbumUpdated(LatestPhotoAdded event) {
    return value.map((e) {
      if (e.id != event.albumId) {
        return e;
      }

      return AlbumViewModel(
        id: e.id,
        coverImageUri: event.coverImageUri,
        title: e.title,
        users: e.users,
        photoCount: e.photoCount + 1,
      );
    }).toList();
  }
}
