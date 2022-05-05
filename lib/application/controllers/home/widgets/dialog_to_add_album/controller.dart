import 'package:album/core/controller.dart';
import 'package:album/core/navigator.dart';
import 'package:flutter/cupertino.dart';

class DialogToAddAlbum extends Controller {
  final textEditingController = TextEditingController();

  DialogToAddAlbum({Key? key}) : super(key: key);

  @override
  Widget render(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text("새로운 앨범 추가"),
      content: Padding(
        padding: const EdgeInsets.only(top: 18.0, bottom: 6.0),
        child: CupertinoTextField(
          controller: textEditingController,
          placeholder: "제목을 입력해 주세요.",
        ),
      ),
      actions: [
        CupertinoButton(
          onPressed: () {
            requireNavigator().pop();
          },
          child: const Text(
            "취소",
            style: TextStyle(
              color: CupertinoColors.systemGrey,
            ),
          ),
        ),
        CupertinoButton(
          onPressed: () {
            final title = textEditingController.text;

            requireNavigator().pop();
          },
          child: const Text("추가"),
        ),
      ],
    );
  }
}
