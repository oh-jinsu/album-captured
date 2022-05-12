import 'package:album/core/locator/service.dart';
import 'package:album/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseProvider implements Service {
  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
