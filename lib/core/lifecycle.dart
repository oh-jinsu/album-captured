import 'package:album/core/context.dart';
import 'package:album/core/debug.dart';
import 'package:flutter/widgets.dart';

class _Lifecycle extends StatefulWidget {
  final BuildContext inheritedContext;
  final String label;
  final Widget Function(BuildContext) renderer;
  final void Function(BuildContext) onCreate;
  final void Function(BuildContext) onStart;
  final void Function(BuildContext) onDestroy;

  const _Lifecycle({
    Key? key,
    required this.inheritedContext,
    required this.label,
    required this.renderer,
    required this.onCreate,
    required this.onStart,
    required this.onDestroy,
  }) : super(key: key);

  @override
  State<_Lifecycle> createState() => _ControllerState();
}

class _ControllerState extends State<_Lifecycle> {
  @override
  void initState() {
    contextQueue.add(context);

    widget.onCreate(context);

    super.initState();
  }

  @override
  void dispose() {
    widget.onDestroy(context);

    contextQueue.remove(context);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      widget.onStart(context);
    });

    return widget.renderer(context);
  }
}

abstract class Lifecycle extends StatelessWidget {
  const Lifecycle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _Lifecycle(
      inheritedContext: context,
      label: toString(),
      renderer: render,
      onCreate: onCreated,
      onStart: onStarted,
      onDestroy: onDestroyed,
    );
  }

  @protected
  void onCreated(BuildContext context) {
    Debug.log("$this is created");
  }

  @protected
  void onStarted(BuildContext context) {
    Debug.log("$this is started");
  }

  @protected
  void onDestroyed(BuildContext context) {
    Debug.log("$this is destroyed");
  }

  @protected
  Widget render(BuildContext context);
}
