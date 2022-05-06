import 'package:album/application/controllers/album/models/list_of_photo.dart';
import 'package:album/core/event/event.dart';

class PhotoListFound extends OutputEvent<ListOfPhotoModel> {
  const PhotoListFound({required ListOfPhotoModel body}) : super(body: body);
}
