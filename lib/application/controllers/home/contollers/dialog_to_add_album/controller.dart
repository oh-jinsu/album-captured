import 'package:album/application/controllers/home/contollers/dialog_to_add_album/events/submitted.dart';
import 'package:album/application/controllers/home/contollers/dialog_to_add_album/events/title_changed.dart';
import 'package:album/application/controllers/home/contollers/dialog_to_add_album/stores/message.dart';
import 'package:album/application/controllers/home/contollers/dialog_to_add_album/stores/submit_button_state.dart';
import 'package:album/application/controllers/home/contollers/dialog_to_add_album/stores/text_field_state.dart';
import 'package:album/application/controllers/home/contollers/dialog_to_add_album/usecases/submit_album.dart';
import 'package:album/core/common/state.dart';
import 'package:album/core/controller/arguments.dart';
import 'package:album/core/controller/controller.dart';
import 'package:album/infrastructure/providers/navigation.dart';
import 'package:flutter/cupertino.dart';

class DialogToAddAlbum extends Controller {
  final textEditingController = TextEditingController();

  DialogToAddAlbum({Key? key})
      : super(
          const Arguments(),
          key: key,
          stores: [
            MessageStore(),
            SubmitButtonStateStore(),
            TextFieldStateStore(),
          ],
          usecases: [
            SubmitAlbumUseCase(),
          ],
        );

  @override
  void onCreated(BuildContext context) {
    textEditingController.addListener(() => to<DialogToAddAlbum>()
        .dispatch(TitleChanged(value: textEditingController.text)));

    super.onCreated(context);
  }

  @override
  void onDestroyed(BuildContext context) {
    textEditingController.dispose();

    super.onDestroyed(context);
  }

  @override
  Widget render(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text("새로운 앨범 추가하기"),
      content: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            get<TextFieldStateStore>().subscribe(
              onNext: (data) => CupertinoTextField(
                autofocus: true,
                enabled: data == TextFieldState.enabled,
                controller: textEditingController,
                placeholder: "앨범의 제목을 입력해 주세요.",
                clearButtonMode: OverlayVisibilityMode.editing,
                placeholderStyle: const TextStyle(
                  color: CupertinoColors.systemGrey4,
                  height: 1.1,
                ),
              ),
            ),
            get<MessageStore>().subscribe(
              onNext: (data) {
                if (data == null) {
                  return const SizedBox(height: 4.0);
                }

                return Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    data,
                    style: const TextStyle(
                      color: CupertinoColors.systemRed,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      actions: [
        CupertinoButton(
          onPressed: () => use<Coordinator>().pop(),
          child: const Text(
            "취소",
            style: TextStyle(
              color: CupertinoColors.systemGrey,
            ),
          ),
        ),
        get<SubmitButtonStateStore>().subscribe(
          onNext: (data) {
            switch (data) {
              case ButtonState.enabled:
                return CupertinoButton(
                  onPressed: () => to<DialogToAddAlbum>().dispatch(
                    Submitted(title: textEditingController.text),
                  ),
                  child: const Text(
                    "추가",
                  ),
                );
              case ButtonState.disabled:
                return CupertinoButton(
                  onPressed: () {},
                  child: const Text(
                    "추가",
                    style: TextStyle(
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                );
              case ButtonState.pending:
                return CupertinoButton(
                  onPressed: () {},
                  child: const CupertinoActivityIndicator(),
                );
            }
          },
        ),
      ],
    );
  }
}
