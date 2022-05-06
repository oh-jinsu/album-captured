import 'package:album/application/widgets/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhotoEditorDatePicker extends StatelessWidget {
  const PhotoEditorDatePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Material(
          color: Colors.transparent,
          child: Text("2021.04.18"),
        ),
        const SizedBox(width: 6.0),
        AppButton(
          child: const Icon(CupertinoIcons.calendar),
          onPressed: () {
            showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate:
                  DateTime.now().subtract(const Duration(days: 365 * 30)),
              lastDate: DateTime.now(),
            );
          },
        ),
      ],
    );
  }
}
