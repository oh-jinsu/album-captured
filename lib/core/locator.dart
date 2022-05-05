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

final Map<String, Locator> locatorManifest = {};

class Locator {
  final Map<String, Service> _manifest = {};

  Locator(List<Service> services) {
    for (final service in services) {
      _manifest[service._key] = service;
    }
  }

  static T of<T>([String context = "global"]) {
    final locator = locatorManifest[context];

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
