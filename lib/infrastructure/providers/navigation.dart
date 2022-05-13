import 'package:album/core/controller/arguments.dart';
import 'package:album/core/controller/lifecycle.dart';
import 'package:album/core/locator/service.dart';
import 'package:flutter/material.dart';

class Coordinator implements Service {
  Future<T?> push<T extends Object?>(String name, {Arguments? arguments}) {
    return Navigator.of(requireContext()).pushNamed(
      name,
      arguments: arguments,
    );
  }

  Future<T?> replace<T extends Object?>(String name, {Arguments? arguments}) {
    return Navigator.of(requireContext()).pushReplacementNamed(
      name,
      arguments: arguments,
    );
  }

  void pop<T extends Object?>([T? result]) {
    return Navigator.of(requireContext()).pop<T>(
      result,
    );
  }

  @override
  Future<void> initialize() async {}
}
