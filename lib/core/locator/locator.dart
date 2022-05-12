import 'package:album/core/locator/creational.dart';
import 'package:album/core/locator/service.dart';

final Map<String, Locator> locatorManifest = {};

class Locator {
  final Map<String, Creational> _manifest = {};

  Locator(List<Creational> services) {
    for (final service in services) {
      _manifest[service.key] = service;
    }
  }

  T require<T extends Service>() {
    final key = T.toString();

    final service = _manifest[key];

    if (service == null) {
      throw Exception("$T not found");
    }

    return service.require() as T;
  }

  static T of<T extends Service>([String context = "App"]) {
    final locator = locatorManifest[context];

    if (locator == null) {
      throw Exception("Locator $context not found");
    }

    final key = T.toString();

    final service = locator._manifest[key];

    if (service == null) {
      throw Exception("$T not found");
    }

    return service.require() as T;
  }
}
