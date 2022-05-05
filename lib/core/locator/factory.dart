import 'package:album/core/locator/service.dart';

class Factory<T> extends Service<T> {
  final T Function() constructor;

  Factory(this.constructor);

  @override
  T require() => constructor();
}
