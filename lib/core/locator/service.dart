abstract class Service<T> {
  final String key;

  const Service(this.key);

  T require();
}
