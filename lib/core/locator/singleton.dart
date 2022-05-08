import 'package:album/core/locator/service.dart';

class Singleton<T> extends Service<T> {
  final T instance;

  Singleton(
    this.instance,
  ) : super(T.toString());

  Singleton.runtime(this.instance) : super(instance.runtimeType.toString());

  Singleton.named(String name, this.instance) : super(name);

  @override
  T require() => instance;
}
