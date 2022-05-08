import 'package:album/application/widgets/button.dart';
import 'package:flutter/cupertino.dart';

class PickerForIos extends StatefulWidget {
  const PickerForIos({Key? key}) : super(key: key);

  @override
  State<PickerForIos> createState() => _PickerForIosState();
}

class _PickerForIosState extends State<PickerForIos> {
  DateTime? temporary;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CupertinoNavigationBar(
          automaticallyImplyLeading: false,
          trailing: AppButton(
            onPressed: () => Navigator.of(context).pop(temporary),
            child: const Text("선택"),
          ),
        ),
        SizedBox(
          height: 200.0,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: (date) {
              temporary = date;
            },
          ),
        ),
        const SizedBox(height: 8.0),
      ],
    );
  }
}
