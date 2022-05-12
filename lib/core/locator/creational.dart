import 'package:album/core/locator/service.dart';

abstract class Creational<T extends Service> {
  final String key;

  const Creational(this.key);

  T require();
}
