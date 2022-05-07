import 'package:album/application/controllers/controllers/editor/controller.dart';
import 'package:album/application/controllers/controllers/editor/events/picker_tapped.dart';
import 'package:album/application/controllers/controllers/editor/events/preview_added.dart';
import 'package:album/core/usecase/usecase.dart';
import 'package:album/infrastructure/repositories/image.dart';

class PickPhotoUseCase extends UseCase {
  @override
  void onAwaken() {
    of<Editor>().on<PickerTapped>((event) async {
      final file = await use<ImageRepository>().pickFromGallery();

      if (file == null) {
        return;
      }

      final value = PreviewAdded(body: file);

      of<Editor>().dispatch(value);
    });
  }
}
