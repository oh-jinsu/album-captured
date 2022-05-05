import 'package:album/application/controllers/home/models/album.dart';
import 'package:album/core/event.dart';

class FindAlbumEvent implements Event {
  final AlbumModel body;

  const FindAlbumEvent({
    required this.body,
  });
}
