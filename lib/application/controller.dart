import 'package:album/application/controllers/home/controller.dart';
import 'package:album/application/controllers/splash/controller.dart';
import 'package:album/application/usecases/bootstrap.dart';
import 'package:album/core/controller/controller.dart';
import 'package:flutter/cupertino.dart';

class App extends Controller {
  App({Key? key})
      : super(
          key: key,
          usecases: [
            BootstrapUseCase(),
          ],
        );

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
          return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => Splash(),
          );
        }

        if (name == "/home") {
          return PageRouteBuilder(
            transitionDuration: Duration.zero,
            pageBuilder: (context, animation, secondaryAnimation) => Home(),
          );
        }

        return null;
      },
      initialRoute: "/splash",
    );
  }
}
