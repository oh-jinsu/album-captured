import 'package:album/core/context.dart';
import 'package:album/core/debug.dart';
import 'package:flutter/widgets.dart';

class _AppController extends StatefulWidget {
  final BuildContext inheritedContext;
  final String label;
  final Widget Function(BuildContext) renderer;
  final void Function(BuildContext) onCreate;
  final void Function(BuildContext) onStart;
  final void Function(BuildContext) onDestroy;

  const _AppController({
    Key? key,
    required this.inheritedContext,
    required this.label,
    required this.renderer,
    required this.onCreate,
    required this.onStart,
    required this.onDestroy,
  }) : super(key: key);

  @override
  State<_AppController> createState() => _ControllerState();
}

class _ControllerState extends State<_AppController> {
  @override
  void initState() {
    widget.onCreate(widget.inheritedContext);

    super.initState();
  }

  @override
  void dispose() {
    widget.onDestroy(context);

    contextQueue.remove(context);

    Debug.log(
      "${widget.label} is being destroyed",
    );

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!contextQueue.contains(context)) {
      contextQueue.add(context);

      Debug.log(
        "${widget.label} is being mounted",
      );

      Future.delayed(Duration.zero, () {
        widget.onStart(context);
      });
    }

    return widget.renderer(context);
  }
}

abstract class Controller<T> extends StatelessWidget {
  const Controller({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _AppController(
      inheritedContext: context,
      label: toString(),
      renderer: render,
      onCreate: onCreate,
      onStart: onStart,
      onDestroy: onDestroy,
    );
  }

  @protected
  void onCreate(BuildContext context) {}

  @protected
  void onStart(BuildContext context) {}

  @protected
  void onDestroy(BuildContext context) {}

  @protected
  Widget render(BuildContext context);
}
