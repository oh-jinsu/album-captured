import 'package:album/core/action.dart';
import 'package:album/core/channel.dart';
import 'package:album/core/lifecycle.dart';
import 'package:album/core/locator.dart';
import 'package:flutter/widgets.dart';

abstract class Controller extends Lifecycle {
  const Controller({
    Key? key,
  }) : super(key: key);

  Channel of(String scope) {
    return Locator.of(scope);
  }

  @override
  @mustCallSuper
  void onCreated(BuildContext context) {
    of(toString()).dispatch(Created());

    super.onCreated(context);
  }

  @override
  @mustCallSuper
  void onStarted(BuildContext context) {
    of(toString()).dispatch(Started());

    super.onStarted(context);
  }

  @override
  @mustCallSuper
  void onDestroyed(BuildContext context) {
    of(toString()).dispatch(Destoryed());

    super.onDestroyed(context);
  }
}
