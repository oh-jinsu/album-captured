import 'package:flutter/foundation.dart';

class Debug {
  static void log(Object object) {
    if (kDebugMode) {
      print(object);
    }
  }
}
