import 'dart:convert';

import 'package:album/application/controller.dart';
import 'package:album/application/controllers/splash/controller.dart';
import 'package:album/application/events/albums_found.dart';
import 'package:album/application/events/user_found.dart';
import 'package:album/application/models/album.dart';
import 'package:album/application/models/list_of_albums.dart';
import 'package:album/application/models/user.dart';
import 'package:album/core/event/event.dart';
import 'package:album/core/usecase/usecase.dart';
import 'package:album/firebase_options.dart';
import 'package:album/infrastructure/client/client.dart';
import 'package:album/infrastructure/client/response.dart';
import 'package:album/infrastructure/providers/precache.dart';
import 'package:album/infrastructure/repositories/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BootstrapUseCase extends UseCase {
  @override
  void onAwaken() {
    of<App>().on<Created>((event) async {
      await dotenv.load();

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      await _autoSignIn();

      await _fetchAlbums();

      of<Splash>().dispatch(const Pushed("/home"));
    });
  }

  Future<void> _autoSignIn() async {
    final refreshToken = await use<AuthRepository>().findRefreshToken();

    if (refreshToken == null) {
      await _signUpWithGuest();
    } else {
      final response = await use<Client>().post(
        "auth/refresh",
        body: {
          "refresh_token": refreshToken,
        },
      );

      if (response is FailureResponse) {
        await _signUpWithGuest();
      }

      if (response is! SuccessResponse) {
        return;
      }

      final accessToken = response.body["access_token"];

      await use<AuthRepository>().saveAccessToken(accessToken);

      final normal = base64Url.normalize(accessToken.split(".")[1]);

      final payload = jsonDecode(utf8.decode(base64Url.decode(normal)));

      if (payload["grd"] == "member") {
        final userResponse = await use<Client>().get("user/me", headers: {
          "Authorization": "Bearer $accessToken",
        });

        if (userResponse is! SuccessResponse) {
          return;
        }

        await use<PrecacheProvider>()
            .fromNetwork(userResponse.body["avatar_image_uri"]);

        final user = UserModel.fromJson(userResponse.body);

        of<App>().dispatch(UserFound(body: user));
      }
    }
  }

  Future<void> _fetchAlbums() async {
    final accessToken = await use<AuthRepository>().findAccessToken();

    final response = await use<Client>().get("album", headers: {
      "Authorization": "Bearer $accessToken",
    });

    if (response is! SuccessResponse) {
      return;
    }

    final next = response.body["next"];

    final items =
        await Future.wait((response.body["items"] as List).map((item) async {
      final coverImageUri = item["cover_image_uri"] as String?;

      if (coverImageUri != null) {
        await use<PrecacheProvider>().fromNetwork(coverImageUri);
      }

      await Future.wait((item["users"] as List).map((user) async {
        final avatarImageUri = user["avatar_image_uri"];

        if (avatarImageUri != null) {
          await use<PrecacheProvider>().fromNetwork(avatarImageUri);
        }
      }));

      return AlbumModel.fromJson(item);
    }).toList());

    final body = ListOfAlbumsModel(next: next, items: items);

    of<App>().dispatch(AlbumsFound(body: body));
  }

  Future<void> _signUpWithGuest() async {
    final response = await use<Client>().get("auth/guest");

    if (response is! SuccessResponse) {
      return;
    }

    final accessToken = response.body["access_token"];

    final refreshToken = response.body["refresh_token"];

    await use<AuthRepository>().saveAccessToken(accessToken);

    await use<AuthRepository>().saveRefreshToken(refreshToken);

    await use<Client>().post(
      "user/guest",
      headers: {
        "Authorization": "Bearer $accessToken",
      },
    );
  }
}
