import 'package:album/application/controllers/home/models/album.dart';

class ListOfAlbumsModel {
  final String? next;
  final List<AlbumModel> items;

  const ListOfAlbumsModel({
    required this.next,
    required this.items,
  });
}
