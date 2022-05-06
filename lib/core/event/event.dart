import 'package:album/core/controller/arguments.dart';

abstract class Event {
  const Event();
}

abstract class OutputEvent<T> extends Event {
  final T body;

  const OutputEvent({required this.body});
}

abstract class Navigated extends Event {
  const Navigated();
}

class Pushed extends Navigated {
  final String name;

  final Arguments arguments;

  const Pushed(
    this.name, {
    this.arguments = const Arguments(),
  });
}

class Replaced extends Navigated {
  final String name;

  final Arguments arguments;

  const Replaced(
    this.name, {
    this.arguments = const Arguments(),
  });
}

class Popped extends Navigated {
  const Popped();
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
