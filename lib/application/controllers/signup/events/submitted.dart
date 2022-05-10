import 'dart:io';

import 'package:album/core/event/event.dart';

class Submitted extends Event {
  final String provider;
  final String idToken;
  final File? avatar;
  final String name;
  final String? email;

  const Submitted({
    required this.provider,
    required this.idToken,
    required this.avatar,
    required this.name,
    required this.email,
  });
}
