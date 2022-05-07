import 'dart:io';

import 'package:album/application/widgets/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhotoEditorDatePicker extends StatelessWidget {
  const PhotoEditorDatePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (Platform.isIOS) {
          showModalBottomSheet(
            context: context,
            builder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoNavigationBar(
                  automaticallyImplyLeading: false,
                  trailing: AppButton(onPressed: () {}, child: Text("선택")),
                ),
                SizedBox(
                  height: 200.0,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (date) {},
                  ),
                ),
                const SizedBox(height: 8.0),
              ],
            ),
          );
        } else {
          showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now().subtract(const Duration(days: 365 * 30)),
            lastDate: DateTime.now(),
          );
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text("2021.04.18"),
          const SizedBox(width: 6.0),
          const Icon(CupertinoIcons.calendar),
        ],
      ),
    );
  }
}
