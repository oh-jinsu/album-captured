import 'dart:async';

import 'package:album/core/common/disposable.dart';
import 'package:album/core/event/event.dart';
import 'package:rxdart/subjects.dart';

abstract class InputPort {
  void dispatch<T extends Event>(T event);
}

abstract class OutputPort {
  StreamSubscription on<T extends Event>(void Function(T event) function);
}

class Channel implements InputPort, OutputPort, Disposable {
  final _subject = PublishSubject<Event>();

  @override
  StreamSubscription on<T extends Event>(void Function(T event) function) {
    final subscription = _subject.listen((value) {
      if (value is! T) {
        return;
      }

      function(value);
    });

    return subscription;
  }

  @override
  void dispatch<T extends Event>(T event) {
    _subject.add(event);
  }

  @override
  void dispose() {
    _subject.close();
  }
}
