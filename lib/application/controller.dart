import 'package:album/application/controllers/home/controller.dart';
import 'package:album/application/controllers/home/usecases/find_albums.dart';
import 'package:album/application/controllers/splash/controller.dart';
import 'package:album/core/controller.dart';
import 'package:album/core/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class App extends Controller {
  const App({Key? key}) : super(key: key);

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
