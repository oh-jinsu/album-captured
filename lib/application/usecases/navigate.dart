import 'package:album/application/controller.dart';
import 'package:album/core/context.dart';
import 'package:album/core/event.dart';
import 'package:album/core/usecase.dart';
import 'package:flutter/material.dart';

class NavigateUseCase extends UseCase {
  @override
  void onAwake() {
    of<App>().on<Navigated>(
      (event) {
        if (event is Pushed) {
          Navigator.of(requireContext()).pushNamed(event.name);
        }

        if (event is Replaced) {
          Navigator.of(requireContext()).pushReplacementNamed(event.name);
        }

        if (event is Popped) {
          Navigator.of(requireContext()).pop();
        }
      },
    );
  }
}
