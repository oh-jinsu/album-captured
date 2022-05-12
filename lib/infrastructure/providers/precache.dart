import 'dart:io';

import 'package:album/core/controller/lifecycle.dart';
import 'package:album/core/locator/service.dart';
import 'package:flutter/material.dart';

class PrecacheProvider implements Service {
  Future<String> fromNetwork(String uri) async {
    await precacheImage(NetworkImage(uri), requireContext());

    return uri;
  }

  Future<File> fromFile(File file) async {
    await precacheImage(FileImage(file), requireContext());

    return file;
  }

  @override
  Future<void> initialize() async {}
}
