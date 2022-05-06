class PhotoModel {
  final String id;
  final String publicImageUri;
  final String description;
  final DateTime updatedAt;
  final DateTime createdAt;

  const PhotoModel({
    required this.id,
    required this.publicImageUri,
    required this.description,
    required this.updatedAt,
    required this.createdAt,
  });

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      id: json["id"],
      publicImageUri: json["public_image_uri"],
      description: json["description"],
      updatedAt: json["updated_at"],
      createdAt: json["created_at"],
    );
  }
}
