import 'package:album/application/screens/home/controller.dart';
import 'package:album/application/screens/splash/controller.dart';
import 'package:album/core/controller.dart';
import 'package:album/core/navigator.dart';
import 'package:album/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Application extends Controller {
  const Application({Key? key}) : super(key: key);

  void bootstrap(BuildContext context) async {
    await DotEnv().load();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    requireNavigator().pushReplacementNamed("/home");
  }

  @override
  void onStart(BuildContext context) {
    bootstrap(context);

    super.onStart(context);
  }

  @override
  Widget render(BuildContext context) {
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
              builder: (context) => const SplashController());
        }

        if (name == "/home") {
          return MaterialPageRoute(
              builder: (context) => const HomeController());
        }

        return null;
      },
      initialRoute: "/splash",
    );
  }
}
