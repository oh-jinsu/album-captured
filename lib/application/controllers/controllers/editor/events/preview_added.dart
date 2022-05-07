import 'dart:io';

import 'package:album/core/event/event.dart';

class PreviewAdded extends OutputEvent<File> {
  const PreviewAdded({required File body}) : super(body: body);
}
