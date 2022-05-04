import 'package:album/application/screens/home/actions/find_albums.dart';
import 'package:album/application/screens/home/controller.dart';
import 'package:album/application/screens/home/viewmodels/album.dart';
import 'package:album/core/store.dart';

class HomeAlbumsStore extends Store<List<AlbumViewModel>> {
  @override
  onListen() => of<Home>().on<FindAlbums>(_onFindAlbums);

  List<AlbumViewModel> _onFindAlbums(FindAlbums action) {
    return action.body.items.map(AlbumViewModel.fromModel).toList();
  }
}
