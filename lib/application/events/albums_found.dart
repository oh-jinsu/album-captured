import 'package:album/application/models/list_of_albums.dart';
import 'package:album/core/event/event.dart';

class AlbumsFound extends OutputEvent<ListOfAlbumsModel> {
  AlbumsFound({required ListOfAlbumsModel body}) : super(body: body);
}
