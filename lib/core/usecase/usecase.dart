import 'dart:async';

import 'package:album/core/event/event.dart';
import 'package:album/core/channel/channel.dart';
import 'package:album/core/controller/controller.dart';
import 'package:album/core/locator/locator.dart';

class _Channel {
  final Channel _channel;

  _Channel(String scope) : _channel = Locator.of<Channel>(scope);

  final List<StreamSubscription> _subscriptions = [];

  void on<T extends Event>(void Function(T event) function) {
    final subscription = _channel.on<T>(function);

    _subscriptions.add(subscription);
  }

  void dispatch<T extends Event>(T event) {
    _channel.dispatch<T>(event);
  }

  void _dispose() {
    for (final element in _subscriptions) {
      element.cancel();
    }
  }
}

abstract class UseCase {
  final List<_Channel> _channels = [];

  _Channel of<T extends Controller>() {
    final channel = _Channel(T.toString());

    _channels.add(channel);

    return channel;
  }

  void awake() {
    onAwake();
  }

  void onAwake();

  void dispose() {
    for (final element in _channels) {
      element._dispose();
    }

    onDispose();
  }

  void onDispose() {}
}
