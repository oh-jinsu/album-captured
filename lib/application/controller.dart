import 'package:album/application/controllers/album/controller.dart';
import 'package:album/application/controllers/home/controller.dart';
import 'package:album/application/controllers/splash/controller.dart';
import 'package:album/application/usecases/bootstrap.dart';
import 'package:album/core/controller/controller.dart';
import 'package:album/core/locator/singleton.dart';
import 'package:album/infrastructure/client/client.dart';
import 'package:album/infrastructure/repositories/auth.dart';
import 'package:album/infrastructure/repositories/image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class App extends Controller {
  App({Key? key})
      : super(
          key: key,
          services: [
            Singleton<Client>(Client()),
            Singleton<AuthRepository>(AuthRepository()),
            Singleton<ImageRepository>(ImageRepository()),
          ],
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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko'),
        Locale('en'),
      ],
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

        if (name == "/album") {
          final arguments = settings.arguments as AlbumArguments;

          return MaterialPageRoute(
            builder: (context) => CupertinoScaffold(body: Album(arguments)),
          );
        }

        return null;
      },
      initialRoute: "/splash",
    );
  }
}
