import 'package:album/application/controller.dart';
import 'package:album/application/controllers/profile/controller.dart';
import 'package:album/application/controllers/profile/events/sign_out_button_tapped.dart';
import 'package:album/application/events/signed_out.dart';
import 'package:album/core/usecase/usecase.dart';
import 'package:album/infrastructure/client/client.dart';
import 'package:album/infrastructure/client/response.dart';
import 'package:album/infrastructure/repositories/auth.dart';

class SignOutUsecase extends UseCase {
  @override
  void onAwaken() {
    of<Profile>().on<SignOutButtonTapped>((event) async {
      final accessToken = await use<AuthRepository>().findAccessToken();

      final response = await use<Client>().post("auth/signout", headers: {
        "Authorization": "Bearer $accessToken",
      });

      if (response is! SuccessResponse) {
        return;
      }

      await use<AuthRepository>().deleteAccessToken();

      await use<AuthRepository>().deleteRefreshToken();

      final authorization = await use<Client>().get("auth/guest");

      if (authorization is! SuccessResponse) {
        return;
      }

      final newAccessToken = authorization.body["access_token"];

      final refreshToken = authorization.body["refresh_token"];

      await use<AuthRepository>().saveAccessToken(newAccessToken);

      await use<AuthRepository>().saveRefreshToken(refreshToken);

      await use<Client>().post(
        "user/guest",
        headers: {
          "Authorization": "Bearer $newAccessToken",
        },
      );

      of<App>().dispatch(const SignedOut());
    });
  }
}
