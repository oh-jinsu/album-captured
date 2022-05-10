import 'package:album/application/controllers/signup/controller.dart';
import 'package:album/application/controllers/signup/events/avatar_edit_tapped.dart';
import 'package:album/application/controllers/signup/events/avatar_picked.dart';
import 'package:album/core/usecase/usecase.dart';
import 'package:album/infrastructure/repositories/image.dart';

class PickAvatarUseCase extends UseCase {
  @override
  void onAwaken() {
    of<SignUp>().on<AvatarEditTapped>((event) async {
      final image = await use<ImageRepository>().pickFromGallery();

      if (image == null) {
        return;
      }

      of<SignUp>().dispatch(AvatarPicked(file: image));
    });
  }
}
