import 'package:album/application/controllers/home/actions/find_albums.dart';
import 'package:album/application/controllers/home/controller.dart';
import 'package:album/application/controllers/home/viewmodels/album.dart';
import 'package:album/core/store.dart';

class HomeAlbumsStore extends Store<List<AlbumViewModel>> {
  @override
  onListen() => of<Home>().on<FindAlbums>(_onFindAlbums);

  List<AlbumViewModel> _onFindAlbums(FindAlbums action) {
    return action.body.items.map(AlbumViewModel.fromModel).toList();
  }
}
