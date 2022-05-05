abstract class Service<T> {
  String get key => T.toString();

  T require();
}
