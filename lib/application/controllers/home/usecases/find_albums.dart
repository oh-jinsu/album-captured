import 'package:album/application/controllers/home/controller.dart';
import 'package:album/application/controllers/home/events/albums_found.dart';
import 'package:album/application/controllers/home/models/album.dart';
import 'package:album/application/controllers/home/models/album_user.dart';
import 'package:album/application/controllers/home/models/list_of_albums.dart';
import 'package:album/core/event/event.dart';
import 'package:album/core/usecase/usecase.dart';
import 'package:album/repositories/auth.dart';
import 'package:album/utils/fetch.dart';

class FindAlbumsUseCase extends UseCase {
  @override
  onAwaken() {
    of<Home>().on<Created>((event) async {
      final uri = Uri.parse("http://localhost:3000/v1/album");

      final accessToken = await authRepository.findAccessToken();

      final response = await get(uri, headers: {
        "Authorization": "Bearer $accessToken",
      });

      if (response is! SuccessResponse) {
        return;
      }

      final next = response.body["next"];

      final items = (response.body["items"] as List)
          .map(
            (e) => AlbumModel(
              id: e["id"],
              title: e["title"],
              users: (e["users"] as List)
                  .map(
                    (u) => AlbumUserModel(
                      id: u["id"],
                      avatarImageUri: u["avatar_image_uri"],
                      name: u["name"],
                      joinedAt: DateTime.parse(u["joined_at"]),
                    ),
                  )
                  .toList(),
              coverImageUri: e["cover_image_uri"],
              photoCount: e["photo_count"],
            ),
          )
          .toList();

      final body = ListOfAlbumsModel(next: next, items: items);

      of<Home>().dispatch(AlbumsFound(body: body));
    });
  }
}
