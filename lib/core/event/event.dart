import 'package:album/core/controller/arguments.dart';

abstract class Event {
  const Event();
}

abstract class OutputEvent<T> extends Event {
  final T body;

  const OutputEvent({required this.body});
}

class Created<T extends Arguments> extends Event {
  final T arguments;

  const Created(this.arguments);
}

class Started extends Event {
  const Started();
}

class Destoryed extends Event {
  const Destoryed();
}
