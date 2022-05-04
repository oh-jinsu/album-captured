import 'package:album/core/channel.dart';
import 'package:album/core/controller.dart';
import 'package:album/core/debug.dart';
import 'package:album/core/lifecycle.dart';
import 'package:album/core/usecase.dart';
import 'package:flutter/material.dart';

abstract class Service<T> {
  String get _key => T.toString();

  T _require();
}

class Singleton<T> extends Service<T> {
  final T instance;

  Singleton(
    this.instance,
  );

  @override
  T _require() => instance;
}

class Factory<T> extends Service<T> {
  final T Function() constructor;

  Factory(this.constructor);

  @override
  T _require() => constructor();
}

final Map<String, Locator> _locatorManifest = {};

class Locator {
  final Map<String, Service> _manifest = {};

  Locator(List<Service> services) {
    for (final service in services) {
      _manifest[service._key] = service;
    }
  }

  static T of<T>([String context = "global"]) {
    final locator = _locatorManifest[context];

    if (locator == null) {
      throw Exception("Locator $context not found");
    }

    final key = T.toString();

    final service = locator._manifest[key];

    if (service == null) {
      throw Exception("$T not found");
    }

    return service._require();
  }
}

class Provider extends Lifecycle {
  final Service _channelService = Singleton<Channel>(Channel());

  final List<Service> services;

  final List<UseCase> usecases;

  final Controller controller;

  Provider({
    Key? key,
    this.services = const [],
    this.usecases = const [],
    required this.controller,
  }) : super(key: key);

  @override
  void onCreated(BuildContext context) {
    _addLocator();

    _awakeUsecases();

    super.onCreated(context);
  }

  void _addLocator() {
    final key = controller.runtimeType.toString();

    _locatorManifest[key] = Locator([_channelService, ...services]);

    Debug.log("${controller.runtimeType}Locator is assigned");
  }

  void _awakeUsecases() {
    for (final element in usecases) {
      element.awake();
    }
  }

  @override
  void onDestroyed(BuildContext context) {
    _disposeUseCases();

    _closeChannel();

    _removeLocator();

    super.onDestroyed(context);
  }

  void _disposeUseCases() {
    for (final element in usecases) {
      element.dispose();
    }
  }

  void _closeChannel() {
    (_channelService._require() as Channel).close();
  }

  void _removeLocator() {
    _locatorManifest.remove(controller.runtimeType.toString());
  }

  @override
  Widget render(BuildContext context) {
    return controller;
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return "${controller.runtimeType}Provider";
  }
}
