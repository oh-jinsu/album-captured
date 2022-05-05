import 'package:album/core/locator/service.dart';

class Singleton<T> extends Service<T> {
  final T instance;

  Singleton(
    this.instance,
  );

  @override
  T require() => instance;
}
