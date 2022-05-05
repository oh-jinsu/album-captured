import 'package:album/application/controllers/home/models/list_of_albums.dart';
import 'package:album/core/event.dart';

class AlbumsFound extends OutputEvent<ListOfAlbumsModel> {
  AlbumsFound({required ListOfAlbumsModel body}) : super(body: body);
}
