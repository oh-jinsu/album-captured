import 'dart:io';

import 'package:album/core/event/event.dart';

class AvatarPicked extends Event {
  final File file;

  const AvatarPicked({
    required this.file,
  });
}
