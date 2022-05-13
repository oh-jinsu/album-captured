import 'dart:io';

import 'package:album/application/controller.dart';
import 'package:album/application/controllers/signup/controller.dart';
import 'package:album/application/controllers/signup/events/pending.dart';
import 'package:album/application/controllers/signup/events/submitted.dart';
import 'package:album/application/events/user_found.dart';
import 'package:album/application/models/user.dart';
import 'package:album/core/event/event.dart';
import 'package:album/core/usecase/usecase.dart';
import 'package:album/infrastructure/client/client.dart';
import 'package:album/infrastructure/client/response.dart';
import 'package:album/infrastructure/providers/navigation.dart';
import 'package:album/infrastructure/repositories/auth.dart';

class SubmitUseCase extends UseCase {
  @override
  void onAwaken() {
    of<SignUp>().on<Submitted>((event) async {
      of<SignUp>().dispatch(const Pending());

      final guestAccessToken = await use<AuthRepository>().findAccessToken();

      if (guestAccessToken == null) {
        return;
      }

      final authorization = await use<Client>().post(
        "auth/signup?provider=${event.provider}",
        headers: {
          "Authorization": "Bearer $guestAccessToken",
        },
        body: {
          "id_token": event.idToken,
        },
      );

      if (authorization is! SuccessResponse) {
        return;
      }

      final accessToken = authorization.body["access_token"];

      final refreshToken = authorization.body["refresh_token"];

      await use<AuthRepository>().saveAccessToken(accessToken);

      await use<AuthRepository>().saveRefreshToken(refreshToken);

      final user = await use<Client>().post(
        "user/me",
        headers: {
          "Authorization": "Bearer $accessToken",
        },
        body: {
          "avatar": await _getAvatarIdIfExists(guestAccessToken, event.avatar),
          "name": event.name,
          "email": event.email,
        },
      );

      if (user is! SuccessResponse) {
        return;
      }

      of<App>().dispatch(UserFound(body: UserModel.fromJson(user.body)));

      use<Coordinator>().pop();
    });
  }

  Future<String?> _getAvatarIdIfExists(String accessToken, File? avatar) async {
    if (avatar == null) {
      return null;
    }

    final response =
        await use<Client>().postMultipart("util/image", avatar, headers: {
      "Authorization": "Bearer $accessToken",
    });

    if (response is! SuccessResponse) {
      return null;
    }

    return response.body["id"];
  }
}
