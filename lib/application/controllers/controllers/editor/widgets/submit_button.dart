import 'package:flutter/material.dart';

class PhotoEditorSubmitButton extends StatelessWidget {
  const PhotoEditorSubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8.0),
      ),
      width: double.infinity,
      height: 52.0,
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
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          const Positioned.fill(
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: Text(
                  "추가하기",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    height: 1.3,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
