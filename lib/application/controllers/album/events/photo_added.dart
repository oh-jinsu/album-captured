import 'package:album/application/controllers/album/models/photo.dart';
import 'package:album/core/event/event.dart';

class PhotoAdded extends OutputEvent<PhotoModel> {
  PhotoAdded({required PhotoModel body}) : super(body: body);
}
