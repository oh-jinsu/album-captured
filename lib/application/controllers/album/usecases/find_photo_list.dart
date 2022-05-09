import 'package:album/application/controllers/album/controller.dart';
import 'package:album/application/controllers/album/events/photo_list_found.dart';
import 'package:album/application/controllers/album/models/list_of_photo.dart';
import 'package:album/application/controllers/album/models/photo.dart';
import 'package:album/core/event/event.dart';
import 'package:album/core/usecase/usecase.dart';
import 'package:album/infrastructure/client/client.dart';
import 'package:album/infrastructure/client/response.dart';
import 'package:album/infrastructure/providers/precache.dart';
import 'package:album/infrastructure/repositories/auth.dart';

class FindPhotoListUseCase extends UseCase {
  @override
  void onAwaken() {
    of<Album>().on<Created<AlbumArguments>>((event) async {
      final accessToken = await use<AuthRepository>().findAccessToken();

      final response = await use<Client>().get(
        "photo?album_id=${event.arguments.id}",
        headers: {
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response is! SuccessResponse) {
        return;
      }

      final next = response.body["next"];

      final items = await Future.wait((response.body["items"] as List).map(
        (item) async {
          final imageUri = item["public_image_uri"];

          await use<PrecacheProvider>().fromNetwork(imageUri);

          return PhotoModel.fromJson(item);
        },
      ).toList());

      final body = ListOfPhotoModel(next: next, items: items);

      final value = PhotoListFound(body: body);

      of<Album>().dispatch(value);
    });
  }
}
