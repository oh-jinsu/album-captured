import 'dart:async';

import 'package:album/application/controllers/invitation/controller.dart';
import 'package:album/application/events/linked.dart';
import 'package:album/core/channel/channel.dart';
import 'package:album/core/channel/custom.dart';
import 'package:album/core/controller/arguments.dart';
import 'package:album/core/event/event.dart';
import 'package:album/core/controller/lifecycle.dart';
import 'package:album/core/locator/locator.dart';
import 'package:album/core/locator/creational.dart';
import 'package:album/core/locator/singleton.dart';
import 'package:album/core/store/store.dart';
import 'package:album/core/usecase/usecase.dart';
import 'package:flutter/widgets.dart';

abstract class Controller<T extends Arguments> extends Lifecycle {
  final T arguments;

  final _channel = Channel();

  final List<StreamSubscription> _subscriptions = [];

  final List<Creational> services;

  final List<UseCase> usecases;

  final List<Store> stores;

  final List<CustomChannel> channels;

  Controller(
    this.arguments, {
    Key? key,
    this.services = const [],
    this.usecases = const [],
    this.stores = const [],
    this.channels = const [],
  }) : super(key: key);

  Locator of<K>() {
    final locator = locatorManifest[K.toString()];

    if (locator == null) {
      throw Exception("${K.toString()} not found");
    }

    return locator;
  }

  InputPort to<K>() {
    final scope = K.toString();

    return Locator.of<Channel>(scope);
  }

  K get<K extends Store>() {
    final scope = toString();

    return Locator.of<K>(scope);
  }

  @override
  @mustCallSuper
  void onCreated(BuildContext context) async {
    final navigationSub = _channel.on<Navigated>((event) {
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

    final dynamicLinkSub = _channel.on<InvitationAccepted>((event) {
      final token = event.token;

      Navigator.of(requireContext()).pushNamed("/invitation",
          arguments: InvitationArguments(token: token));
    });

    _subscriptions.addAll([navigationSub, dynamicLinkSub]);

    final storeServices = stores.map((e) => Singleton.runtime(e));

    for (final element in services) {
      await element.require().initialize();
    }

    locatorManifest[toString()] = Locator(
      [Singleton<Channel>(_channel), ...storeServices, ...services],
    );

    for (final element in stores) {
      await element.initialize();
    }

    for (final element in usecases) {
      await element.initialize();
    }

    for (final element in channels) {
      await element.initialize();
    }

    _channel.dispatch(Created(arguments));

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
    for (final element in channels) {
      element.dispose();
    }

    for (final element in usecases) {
      element.dispose();
    }

    for (final element in stores) {
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
