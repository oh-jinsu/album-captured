import 'package:album/application/controller.dart';
import 'package:album/core/locator.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(Provider(controller: const App()));
}
