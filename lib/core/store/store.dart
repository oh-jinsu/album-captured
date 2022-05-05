import 'dart:async';

import 'package:album/core/event.dart';
import 'package:album/core/channel.dart';
import 'package:album/core/controller.dart';
import 'package:album/core/debug.dart';
import 'package:album/core/locator.dart';
import 'package:album/core/store/builder.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

class _Channel<T> {
  final Channel _channel;

  final Sink<T> _sink;

  _Channel(String scope, Sink<T> sink)
      : _sink = sink,
        _channel = Locator.of<Channel>(scope);

  final List<StreamSubscription> _subscriptions = [];

  void on<K extends Event>(T Function(K action) function) {
    final subscription = _channel.on<K>((data) {
      final result = function(data);

      _sink.add(result);
    });

    _subscriptions.add(subscription);
  }

  void _dispose() {
    for (final element in _subscriptions) {
      element.cancel();
    }
  }
}

abstract class Store<T> {
  Stream<T> get stream => _subject;

  final List<_Channel> _channels = [];

  late final _subject = PublishSubject<T>(
    onListen: _onListen,
    onCancel: _onCancel,
  );

  _Channel of<K extends Controller>() {
    final listener = _Channel(K.toString(), _subject);

    _channels.add(listener);

    return listener;
  }

  void _onListen() {
    onListen();

    Debug.log("$runtimeType is listened");
  }

  void onListen();

  void _onCancel() {
    _dispose();
  }

  void _dispose() {
    onDispose();

    for (final element in _channels) {
      element._dispose();
    }

    _subject.close();

    Debug.log("$runtimeType is disposed");
  }

  void onDispose() {}

  StoreBuilder subscribe({
    Key? key,
    required Widget Function(T) onNext,
    Widget Function()? onLoad,
    Widget Function()? onError,
  }) {
    return StoreBuilder<T>(
      this,
      onNext: onNext,
      onLoad: onLoad,
      onError: onError,
    );
  }
}
