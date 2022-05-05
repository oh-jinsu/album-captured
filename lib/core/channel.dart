import 'dart:async';

import 'package:album/core/event.dart';
import 'package:album/core/debug.dart';
import 'package:rxdart/subjects.dart';

abstract class InputPort {
  void dispatch<T extends Event>(T action);
}

abstract class OutputPort {
  StreamSubscription on<T extends Event>(void Function(T action) function);
}

class Channel implements InputPort, OutputPort {
  final _subject = PublishSubject<Event>();

  @override
  StreamSubscription on<T extends Event>(void Function(T action) function) {
    Debug.log("${T}Action is subscribed");

    final subscription = _subject.listen((value) {
      if (value is! T) {
        return;
      }

      Debug.log("${T}Action is invoked");

      function(value);
    });

    return subscription;
  }

  @override
  void dispatch<T extends Event>(T action) {
    _subject.add(action);
  }

  void close() {
    Debug.log("$runtimeType is closed");

    _subject.close();
  }
}
