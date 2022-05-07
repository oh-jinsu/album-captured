import 'package:album/application/controllers/home/controller.dart';
import 'package:album/application/controllers/home/events/albums_found.dart';
import 'package:album/application/controllers/home/models/album.dart';
import 'package:album/application/controllers/home/models/list_of_albums.dart';
import 'package:album/core/event/event.dart';
import 'package:album/core/usecase/usecase.dart';
import 'package:album/infrastructure/client/client.dart';
import 'package:album/infrastructure/client/response.dart';
import 'package:album/infrastructure/repositories/auth.dart';

class FindAlbumsUseCase extends UseCase {
  @override
  onAwaken() {
    of<Home>().on<Created>((event) async {
      final accessToken = await use<AuthRepository>().findAccessToken();

      final response = await use<Client>().get("album", headers: {
        "Authorization": "Bearer $accessToken",
      });

      if (response is! SuccessResponse) {
        return;
      }

      final next = response.body["next"];

      final items = (response.body["items"] as List)
          .map((e) => AlbumModel.fromJson(e))
          .toList();

      final body = ListOfAlbumsModel(next: next, items: items);

      of<Home>().dispatch(AlbumsFound(body: body));
    });
  }
}
