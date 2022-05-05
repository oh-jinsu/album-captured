import 'dart:async';

import 'package:album/core/channel/channel.dart';
import 'package:album/core/event/event.dart';
import 'package:album/core/controller/lifecycle.dart';
import 'package:album/core/locator/locator.dart';
import 'package:album/core/locator/service.dart';
import 'package:album/core/locator/singleton.dart';
import 'package:album/core/usecase/usecase.dart';
import 'package:flutter/widgets.dart';

abstract class Controller extends Lifecycle {
  final _channel = Channel();

  final List<StreamSubscription> _subscriptions = [];

  final List<Service> services;

  final List<UseCase> usecases;

  Controller({
    Key? key,
    this.services = const [],
    this.usecases = const [],
  }) : super(key: key);

  InputPort of<T>() {
    final scope = T.toString();

    return Locator.of<Channel>(scope);
  }

  @override
  void onCreated(BuildContext context) {
    final subscription = _channel.on<Navigated>((event) {
      if (event is Pushed) {
        Navigator.of(context).pushNamed(event.name);
      }

      if (event is Replaced) {
        Navigator.of(context).pushReplacementNamed(event.name);
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
  void onStarted(BuildContext context) {
    _channel.dispatch(const Started());

    super.onStarted(context);
  }

  @override
  void onDestroyed(BuildContext context) {
    for (final element in usecases) {
      element.dispose();
    }

    for (final subscription in _subscriptions) {
      subscription.cancel();
    }

    _channel.dispatch(const Destoryed());

    _channel.close();

    locatorManifest.remove(toString());

    super.onDestroyed(context);
  }
}
