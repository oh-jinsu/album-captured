import 'package:album/core/event/event.dart';

class LatestPhotoAdded extends Event {
  final String albumId;
  final String coverImageUri;

  const LatestPhotoAdded({
    required this.albumId,
    required this.coverImageUri,
  });
}
