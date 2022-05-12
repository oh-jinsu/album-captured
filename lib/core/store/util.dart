import 'dart:io';

import 'package:album/core/controller/lifecycle.dart';
import 'package:flutter/cupertino.dart';

enum StoreCacheRes {
  mdpi,
  xhdpi,
  xxhdpi,
  origin,
}

class StoreCacheUtil {
  static Future<String> network(String uri,
      {StoreCacheRes resolution = StoreCacheRes.xxhdpi}) async {
    final resizedUri = () {
      switch (resolution) {
        case StoreCacheRes.mdpi:
          return "$uri/mdpi";
        case StoreCacheRes.xhdpi:
          return "$uri/xhdpi";
        case StoreCacheRes.xxhdpi:
          return "$uri/xxhdpi";
        case StoreCacheRes.origin:
          return uri;
      }
    }();

    await precacheImage(NetworkImage(resizedUri), requireContext());

    return resizedUri;
  }

  static Future<File> file(File file,
      {StoreCacheRes resolution = StoreCacheRes.xxhdpi}) async {
    await precacheImage(FileImage(file), requireContext());

    return file;
  }
}
