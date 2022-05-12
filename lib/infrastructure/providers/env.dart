import 'package:album/core/locator/service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvProvider implements Service {
  @override
  Future<void> initialize() async {
    await dotenv.load();
  }
}
