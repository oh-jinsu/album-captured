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
  late final authRepository = use<AuthRepository>();
  @override
  void onAwaken() {
    of<App>().on<Created>((event) async {
      await DotEnv().load();

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      final accessToken = await use<AuthRepository>().findAccessToken();

      if (accessToken == null) {
        final response = await use<Client>()
            .get(Uri.parse("http://localhost:3000/v1/auth/guest"));

        if (response is! SuccessResponse) {
          return;
        }

        final accessToken = response.body["access_token"];

        use<AuthRepository>().saveAccessToken(accessToken);

        await use<Client>().post(
          Uri.parse("http://localhost:3000/v1/user/guest"),
          headers: {
            "Authorization": "Bearer $accessToken",
          },
        );
      }

      of<Splash>().dispatch(const Pushed("/home"));
    });
  }
}
