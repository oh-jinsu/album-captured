import 'package:album/core/common/state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhotoEditorSubmitButton extends StatelessWidget {
  final void Function() onPressed;
  final ButtonState state;

  const PhotoEditorSubmitButton({
    Key? key,
    required this.onPressed,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backgroundColor = state == ButtonState.enabled
        ? CupertinoTheme.of(context).primaryColor
        : CupertinoColors.inactiveGray;

    return GestureDetector(
      onTap: () {
        if (state == ButtonState.enabled) {
          onPressed.call();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        width: double.infinity,
        height: 48.0,
        child: Stack(
          children: [
            Positioned(
              top: 0.0,
              bottom: 0.0,
              left: 16.0,
              child: Center(
                child: Container(
                  width: 17.0,
                  height: 18.0,
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 4.0),
                  child: Container(
                    color: backgroundColor,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Center(
                child: state == ButtonState.pending
                    ? const CupertinoActivityIndicator(
                        color: CupertinoColors.white,
                      )
                    : const Text(
                        "추가하기",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          height: 1.3,
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
