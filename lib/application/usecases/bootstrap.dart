import 'package:album/application/controller.dart';
import 'package:album/application/controllers/splash/controller.dart';
import 'package:album/core/event/event.dart';
import 'package:album/core/usecase/usecase.dart';
import 'package:album/firebase_options.dart';
import 'package:album/infrastructure/client/client.dart';
import 'package:album/infrastructure/client/response.dart';
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

        if (response is SuccessResponse) {
          final accessToken = response.body["access_token"];

          await use<AuthRepository>().saveAccessToken(accessToken);
        }
      }

      of<Splash>().dispatch(const Pushed("/home"));
    });
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
