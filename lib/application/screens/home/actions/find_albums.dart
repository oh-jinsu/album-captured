import 'package:album/application/screens/home/models/list_of_albums.dart';
import 'package:album/core/action.dart';

class FindAlbums implements Action {
  final ListOfAlbumsModel body;

  FindAlbums(
    this.body,
  );
}
