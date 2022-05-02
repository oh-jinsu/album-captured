import 'package:album/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

class Application extends StatelessWidget {
  const Application({Key? key}) : super(key: key);

  void bootstrap() async {
    await DotEnv().load();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Widget build(BuildContext context) {
    bootstrap();
    return GetMaterialApp(
      builder: (context, child) {
        return MediaQuery(
          child: child!,
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        );
      },
      home: const Scaffold(
        body: Center(),
      ),
    );
  }
}
