import 'package:album/application/screens/home/widgets/actions/add_album.dart';
import 'package:album/application/screens/home/widgets/add_album_dialog/event/add_album.dart';
import 'package:album/core/controller.dart';
import 'package:album/core/navigator.dart';
import 'package:flutter/cupertino.dart';

class HomeAddAlbumDialog extends Controller {
  final textEditingController = TextEditingController();

  HomeAddAlbumDialog({Key? key}) : super(key: key);

  @override
  void onCreated(BuildContext context) {
    super.onCreated(context);

    observeAddAlbum();
  }

  @override
  void onDestroyed(BuildContext context) {
    super.onDestroyed(context);

    textEditingController.dispose();

    detachAddAlbum();
  }

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

            addAlbumEvent.add(AddAlbumEventModel(title: title));

            requireNavigator().pop();
          },
          child: const Text("추가"),
        ),
      ],
    );
  }
}
