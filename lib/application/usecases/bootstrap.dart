import 'package:album/application/controller.dart';
import 'package:album/application/controllers/splash/controller.dart';
import 'package:album/core/event/event.dart';
import 'package:album/core/usecase/usecase.dart';
import 'package:album/firebase_options.dart';
import 'package:album/repositories/auth.dart';
import 'package:album/utils/fetch.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BootstrapUseCase extends UseCase {
  @override
  void onAwaken() {
    of<App>().on<Created>((event) async {
      await DotEnv().load();

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      final accessToken = await authRepository.findAccessToken();

      if (accessToken == null) {
        final response =
            await get(Uri.parse("http://localhost:3000/v1/auth/guest"));

        if (response is! SuccessResponse) {
          return;
        }

        final accessToken = response.body["access_token"];

        authRepository.saveAccessToken(accessToken);

        await post(Uri.parse("http://localhost:3000/v1/user/guest"), headers: {
          "Authorization": "Bearer $accessToken",
        });
      }

      of<Splash>().dispatch(const Pushed("/home"));
    });
  }
}
