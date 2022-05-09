import 'dart:io';

import 'package:album/application/controllers/editor/controller.dart';
import 'package:album/application/controllers/editor/controllers/date_picker/widgets/picker_for_ios.dart';
import 'package:album/application/controllers/editor/events/date_changed.dart';
import 'package:album/core/controller/arguments.dart';
import 'package:album/core/controller/controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhotoEditorDatePicker extends Controller {
  final bool enabled;
  final DateTime date;

  PhotoEditorDatePicker({
    Key? key,
    this.enabled = true,
    required this.date,
  }) : super(const Arguments(), key: key);

  @override
  Widget render(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (!enabled) {
          return;
        }

        if (Platform.isIOS) {
          final date = await showModalBottomSheet<DateTime>(
            context: context,
            builder: (context) => const PickerForIos(),
          );

          if (date == null) {
            return;
          }

          of<Editor>().dispatch(DateChanged(value: date));
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
          Text("${date.year}.${date.month}.${date.day}"),
          const SizedBox(width: 6.0),
          Icon(
            CupertinoIcons.calendar,
            color: enabled ? null : CupertinoColors.inactiveGray,
          ),
        ],
      ),
    );
  }
}
