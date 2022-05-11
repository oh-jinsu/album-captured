import 'package:album/application/models/album.dart';

class ListOfAlbumsModel {
  final String? next;
  final List<AlbumModel> items;

  const ListOfAlbumsModel({
    required this.next,
    required this.items,
  });

  factory ListOfAlbumsModel.fromJson(Map<String, dynamic> json) {
    return ListOfAlbumsModel(
      next: json["next"],
      items:
          (json["items"] as List).map((e) => AlbumModel.fromJson(e)).toList(),
    );
  }
}
