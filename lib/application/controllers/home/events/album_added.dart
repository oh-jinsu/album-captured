import 'package:album/application/controllers/home/models/album.dart';
import 'package:album/core/event/event.dart';

class AlbumAdded extends OutputEvent<AlbumModel> {
  const AlbumAdded({required AlbumModel body}) : super(body: body);
}
