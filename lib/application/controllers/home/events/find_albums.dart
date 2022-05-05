import 'package:album/application/controllers/home/models/list_of_albums.dart';
import 'package:album/core/event.dart';

class FindAlbumsEvent implements Event {
  final ListOfAlbumsModel body;

  FindAlbumsEvent(
    this.body,
  );
}
