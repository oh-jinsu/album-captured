import 'dart:async';

import 'package:album/core/common/disposable.dart';
import 'package:album/core/event/event.dart';
import 'package:album/core/channel/channel.dart';
import 'package:album/core/controller/controller.dart';
import 'package:album/core/locator/locator.dart';
import 'package:album/core/store/builder.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

class _Channel<T> implements Disposable {
  final Channel _channel;

  final Sink<StoreData<T>> _sink;

  _Channel(String scope, Sink<StoreData<T>> sink)
      : _sink = sink,
        _channel = Locator.of<Channel>(scope);

  final List<StreamSubscription> _subscriptions = [];

  void on<K extends Event>(Future<T> Function(K event) function) {
    final subscription = _channel.on<K>((data) async {
      final result = await function(data);

      _sink.add(StoreData(result));
    });

    _subscriptions.add(subscription);
  }

  @override
  void dispose() {
    for (final element in _subscriptions) {
      element.cancel();
    }
  }
}

class StoreData<T> {
  final T x;

  const StoreData(this.x);
}

class InitialData<T> extends StoreData<T> {
  InitialData(value) : super(value);
}

abstract class Store<T> implements Disposable {
  Stream<StoreData<T>> get stream => _subject;

  bool get hasValue => _subject.hasValue;

  T get value => _subject.value.x;

  final StoreData<T>? _initial;

  final List<_Channel> _channels = [];

  late final _subject = _initial == null
      ? BehaviorSubject<StoreData<T>>()
      : BehaviorSubject<StoreData<T>>.seeded(_initial!);

  Store([InitialData<T>? initial]) : _initial = initial;

  _Channel of<K extends Controller>() {
    final listener = _Channel(K.toString(), _subject);

    _channels.add(listener);

    return listener;
  }

  void awake() {
    onListen();
  }

  void onListen();

  @override
  void dispose() {
    onDispose();

    for (final element in _channels) {
      element.dispose();
    }

    _subject.close();
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
