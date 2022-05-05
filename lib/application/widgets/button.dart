import 'package:flutter/cupertino.dart';

class AppButton extends StatelessWidget {
  final void Function() onPressed;
  final Widget child;

  const AppButton({
    Key? key,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      child: child,
      onPressed: onPressed,
      minSize: 0.0,
      padding: const EdgeInsets.all(0.0),
    );
  }
}
