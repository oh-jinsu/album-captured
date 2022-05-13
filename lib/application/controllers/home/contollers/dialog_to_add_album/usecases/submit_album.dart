import 'package:album/application/controller.dart';
import 'package:album/application/controllers/home/contollers/dialog_to_add_album/controller.dart';
import 'package:album/application/controllers/home/contollers/dialog_to_add_album/events/pending.dart';
import 'package:album/application/controllers/home/contollers/dialog_to_add_album/events/submitted.dart';
import 'package:album/application/controllers/home/contollers/dialog_to_add_album/events/sumbit_failed.dart';
import 'package:album/application/events/album_added.dart';
import 'package:album/application/models/album.dart';
import 'package:album/core/event/event.dart';
import 'package:album/core/usecase/usecase.dart';
import 'package:album/infrastructure/client/client.dart';
import 'package:album/infrastructure/client/response.dart';
import 'package:album/infrastructure/providers/navigation.dart';
import 'package:album/infrastructure/repositories/auth.dart';

class SubmitAlbumUseCase extends UseCase {
  @override
  void onAwaken() {
    of<DialogToAddAlbum>().on<Submitted>(
      (event) async {
        of<DialogToAddAlbum>().dispatch(const Pending());

        final accessToken = await use<AuthRepository>().findAccessToken();

        final response = await use<Client>().post(
          "album",
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

          of<App>().dispatch(AlbumAdded(body: AlbumModel.fromJson(body)));

          use<Coordinator>().pop();
        }
      },
    );
  }
}
