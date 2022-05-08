import 'dart:io';

import 'package:album/core/event/event.dart';

class Submitted extends Event {
  final String albumId;
  final File image;
  final DateTime date;
  final String? description;

  const Submitted({
    required this.albumId,
    required this.image,
    required this.date,
    required this.description,
  });
}
