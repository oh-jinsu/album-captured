import 'package:album/application/screens/home/controller.dart';
import 'package:album/application/screens/home/usecases/find_albums.dart';
import 'package:album/application/screens/splash/controller.dart';
import 'package:album/core/controller.dart';
import 'package:album/core/locator.dart';
import 'package:album/core/navigator.dart';
import 'package:album/firebase_options.dart';
import 'package:album/repositories/auth.dart';
import 'package:album/utils/fetch.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class App extends Controller {
  const App({Key? key}) : super(key: key);

  @override
  void onStarted(BuildContext context) {
    super.onStarted(context);

    bootstrap(context);
  }

  void bootstrap(BuildContext context) async {
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

    requireNavigator().pushNamed("/home");
  }

  @override
  Widget render(BuildContext context) {
    bootstrap(context);

    return CupertinoApp(
      builder: (context, child) {
        return MediaQuery(
          child: child!,
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        );
      },
      onGenerateRoute: (settings) {
        final name = settings.name;

        if (name == "/splash") {
          return MaterialPageRoute(
            builder: (context) => Provider(
              controller: const Splash(),
            ),
          );
        }

        if (name == "/home") {
          return PageRouteBuilder(
            transitionDuration: Duration.zero,
            pageBuilder: (context, animation, secondaryAnimation) => Provider(
              usecases: [
                FindAlbumsUseCase(),
              ],
              controller: const Home(),
            ),
          );
        }

        return null;
      },
      initialRoute: "/splash",
    );
  }
}
