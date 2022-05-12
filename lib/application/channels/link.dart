import 'dart:async';

import 'package:album/application/events/linked.dart';
import 'package:album/core/channel/channel.dart';
import 'package:album/core/channel/custom.dart';
import 'package:album/core/locator/locator.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinkChannel implements CustomChannel {
  final List<StreamSubscription> _subscriptions = [];

  @override
  Future<void> initialize() async {
    final subscription = FirebaseDynamicLinks.instance.onLink.listen((event) {
      if (event.link.path == "/invitation") {
        final token = event.link.queryParameters["token"];

        if (token == null) {
          return;
        }

        final result = InvitationAccepted(token: token);

        Locator.of<Channel>().dispatch(result);
      }
    });

    _subscriptions.add(subscription);
  }

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
  }
}
