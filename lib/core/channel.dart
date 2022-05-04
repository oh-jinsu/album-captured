import 'dart:async';

import 'package:album/core/action.dart';
import 'package:album/core/debug.dart';
import 'package:rxdart/subjects.dart';

abstract class InputPort {
  void dispatch<T extends Action>(T action);
}

abstract class OutputPort {
  StreamSubscription on<T extends Action>(void Function(T action) function);
}

class Channel implements InputPort, OutputPort {
  final _subject = PublishSubject<Action>();

  @override
  StreamSubscription on<T extends Action>(void Function(T action) function) {
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
  void dispatch<T extends Action>(T action) {
    _subject.add(action);
  }

  void close() {
    Debug.log("$runtimeType is closed");

    _subject.close();
  }
}
