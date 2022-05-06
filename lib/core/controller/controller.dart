import 'dart:async';

import 'package:album/core/channel/channel.dart';
import 'package:album/core/controller/arguments.dart';
import 'package:album/core/event/event.dart';
import 'package:album/core/controller/lifecycle.dart';
import 'package:album/core/locator/locator.dart';
import 'package:album/core/locator/service.dart';
import 'package:album/core/locator/singleton.dart';
import 'package:album/core/usecase/usecase.dart';
import 'package:flutter/widgets.dart';

abstract class Controller<T extends Arguments> extends Lifecycle {
  final Arguments _arguments;

  T get arguments => _arguments as T;

  final _channel = Channel();

  final List<StreamSubscription> _subscriptions = [];

  final List<Service> services;

  final List<UseCase> usecases;

  Controller({
    Key? key,
    Arguments arguments = const Arguments(),
    this.services = const [],
    this.usecases = const [],
  })  : _arguments = arguments,
        super(key: key);

  InputPort of<K>() {
    final scope = K.toString();

    return Locator.of<Channel>(scope);
  }

  @override
  @mustCallSuper
  void onCreated(BuildContext context) {
    final subscription = _channel.on<Navigated>((event) {
      if (event is Pushed) {
        Navigator.of(context).pushNamed(event.name, arguments: event.arguments);
      }

      if (event is Replaced) {
        Navigator.of(context)
            .pushReplacementNamed(event.name, arguments: event.arguments);
      }

      if (event is Popped) {
        Navigator.of(context).pop();
      }
    });

    _subscriptions.add(subscription);

    locatorManifest[toString()] = Locator(
      [Singleton<Channel>(_channel), ...services],
    );

    for (final element in usecases) {
      element.awake();
    }

    _channel.dispatch(const Created());

    super.onCreated(context);
  }

  @override
  @mustCallSuper
  void onStarted(BuildContext context) {
    _channel.dispatch(const Started());

    super.onStarted(context);
  }

  @override
  @mustCallSuper
  void onDestroyed(BuildContext context) {
    for (final element in usecases) {
      element.dispose();
    }

    for (final subscription in _subscriptions) {
      subscription.cancel();
    }

    _channel.dispatch(const Destoryed());

    _channel.dispose();

    locatorManifest.remove(toString());

    super.onDestroyed(context);
  }
}
