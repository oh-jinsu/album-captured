import 'package:album/application/controllers/album/models/photo.dart';

class ListOfPhotoModel {
  final String? next;

  final List<PhotoModel> items;

  const ListOfPhotoModel({
    required this.next,
    required this.items,
  });

  factory ListOfPhotoModel.fromJson(Map<String, dynamic> json) {
    return ListOfPhotoModel(
      next: json["next"],
      items:
          (json["items"] as List).map((e) => PhotoModel.fromJson(e)).toList(),
    );
  }
}
