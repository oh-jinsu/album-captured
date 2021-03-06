import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

class Debug {
  static void log(Object object) {
    if (kDebugMode) {
      final now = DateTime.now();

      final hour = now.hour.toString().padLeft(2, "0");

      final minute = now.minute.toString().padLeft(2, "0");

      final second = now.second.toString().padLeft(2, "0");

      final millisecond = now.millisecond.toString().padLeft(3, "0");

      developer.log("[$hour:$minute:$second:$millisecond] $object");
    }
  }
}
