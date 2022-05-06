import 'package:album/application/controllers/album/controller.dart';
import 'package:album/application/controllers/album/events/photo_list_found.dart';
import 'package:album/application/controllers/album/models/list_of_photo.dart';
import 'package:album/core/event/event.dart';
import 'package:album/core/usecase/usecase.dart';
import 'package:album/infrastructure/client/client.dart';
import 'package:album/infrastructure/client/response.dart';
import 'package:album/infrastructure/repositories/auth.dart';

class FindPhotoListUseCase extends UseCase {
  @override
  void onAwaken() {
    of<Album>().on<Created<AlbumArguments>>((event) async {
      final accessToken = await use<AuthRepository>().findAccessToken();

      final response = await use<Client>().get(
        Uri.parse(
            "http://localhost:3000/v1/photo?album_id=${event.arguments.id}"),
        headers: {
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response is! SuccessResponse) {
        return;
      }

      final body = ListOfPhotoModel.fromJson(response.body);

      final value = PhotoListFound(body: body);

      of<Album>().dispatch(value);
    });
  }
}
