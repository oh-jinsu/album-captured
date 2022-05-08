class PhotoModel {
  final String id;
  final String publicImageUri;
  final String? description;
  final DateTime date;
  final DateTime updatedAt;
  final DateTime createdAt;

  const PhotoModel({
    required this.id,
    required this.publicImageUri,
    required this.description,
    required this.date,
    required this.updatedAt,
    required this.createdAt,
  });

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      id: json["id"],
      publicImageUri: json["public_image_uri"],
      description: json["description"],
      date: DateTime.parse(json["date"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      createdAt: DateTime.parse(json["created_at"]),
    );
  }
}
