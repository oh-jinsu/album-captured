import 'package:rxdart/subjects.dart';

final addAlbumEvent = PublishSubject<AddAlbumEventModel>();

class AddAlbumEventModel {
  final String title;

  const AddAlbumEventModel({
    required this.title,
  });
}
