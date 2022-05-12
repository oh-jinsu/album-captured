import 'dart:io';

import 'package:album/core/locator/service.dart';
import 'package:image_picker/image_picker.dart';

class ImageRepository implements Service {
  final _picker = ImagePicker();

  Future<File?> pickFromGallery() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      return null;
    }

    return File(image.path);
  }

  Future<File?> pickFromCamera() async {
    final image = await _picker.pickImage(source: ImageSource.camera);

    if (image == null) {
      return null;
    }

    return File(image.path);
  }

  @override
  Future<void> initialize() async {}
}
