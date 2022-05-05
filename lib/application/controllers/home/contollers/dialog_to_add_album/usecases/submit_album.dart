import 'package:album/application/controllers/home/contollers/dialog_to_add_album/controller.dart';
import 'package:album/application/controllers/home/contollers/dialog_to_add_album/events/pending.dart';
import 'package:album/application/controllers/home/contollers/dialog_to_add_album/events/submitted.dart';
import 'package:album/application/controllers/home/contollers/dialog_to_add_album/events/sumbit_failed.dart';
import 'package:album/application/controllers/home/controller.dart';
import 'package:album/application/controllers/home/events/album_added.dart';
import 'package:album/application/controllers/home/models/album.dart';
import 'package:album/core/event.dart';
import 'package:album/core/usecase.dart';
import 'package:album/repositories/auth.dart';
import 'package:album/utils/fetch.dart';

class SubmitAlbumUseCase extends UseCase {
  @override
  void onAwake() {
    of<DialogToAddAlbum>().on<Submitted>(
      (event) async {
        of<DialogToAddAlbum>().dispatch(const Pending());

        final accessToken = await authRepository.findAccessToken();

        final response = await post(
          Uri.parse("http://localhost:3000/v1/album"),
          headers: {
            "Authorization": "Bearer $accessToken",
          },
          body: {
            "title": event.title,
          },
        );

        if (response is FailureResponse) {
          final event = SumbmitFailed(body: response.message);

          of<DialogToAddAlbum>().dispatch(event);
        }

        if (response is SuccessResponse) {
          final body = response.body;

          final event = AlbumAdded(body: AlbumModel.fromJson(body));

          of<Home>().dispatch(event);

          of<DialogToAddAlbum>().dispatch(const Popped());
        }
      },
    );
  }
}
