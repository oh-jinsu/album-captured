import 'package:album/application/controller.dart';
import 'package:album/application/controllers/album/controller.dart';
import 'package:album/application/controllers/album/models/photo.dart';
import 'package:album/application/controllers/editor/controller.dart';
import 'package:album/application/controllers/editor/events/pending.dart';
import 'package:album/application/controllers/editor/events/submitted.dart';
import 'package:album/application/events/photo_added.dart';
import 'package:album/core/usecase/usecase.dart';
import 'package:album/infrastructure/client/client.dart';
import 'package:album/infrastructure/client/response.dart';
import 'package:album/infrastructure/providers/navigation.dart';
import 'package:album/infrastructure/providers/precache.dart';
import 'package:album/infrastructure/repositories/auth.dart';

class SubmitUseCase extends UseCase {
  @override
  void onAwaken() {
    of<Editor>().on<Submitted>((event) async {
      of<Editor>().dispatch(const Pending());

      final accessToken = await use<AuthRepository>().findAccessToken();

      final imageResponse = await use<Client>()
          .postMultipart("util/image", event.image, headers: {
        "Authorization": "Bearer $accessToken",
      });

      if (imageResponse is! SuccessResponse) {
        return;
      }

      final imageId = imageResponse.body["id"];

      final response = await use<Client>().post("photo", headers: {
        "Authorization": "Bearer $accessToken",
      }, body: {
        "album_id": event.albumId,
        "image": imageId,
        "date": event.date.toIso8601String(),
        "description": event.description,
      });

      if (response is! SuccessResponse) {
        return;
      }

      await use<PrecacheProvider>().fromNetwork(
        response.body["public_image_uri"],
      );

      final result = PhotoAdded(body: PhotoModel.fromJson(response.body));

      of<Album>().dispatch(result);

      of<App>().dispatch(result);

      use<Coordinator>().pop();
    });
  }
}
