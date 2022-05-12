import 'package:album/core/locator/creational.dart';
import 'package:album/core/locator/service.dart';

class Factory<T extends Service> extends Creational<T> {
  final T Function() constructor;

  Factory(this.constructor) : super(T.toString());

  Factory.runtime(this.constructor) : super(constructor.hashCode.toString());

  Factory.named(String name, this.constructor) : super(name);

  @override
  T require() => constructor();
}
