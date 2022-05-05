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

  const Pushed(this.name);
}

class Replaced extends Navigated {
  final String name;

  const Replaced(this.name);
}

class Popped extends Navigated {
  const Popped();
}

class Created extends Event {
  const Created();
}

class Started extends Event {
  const Started();
}

class Destoryed extends Event {
  const Destoryed();
}
