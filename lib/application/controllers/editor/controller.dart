import 'package:album/application/controllers/editor/controllers/date_picker/date_picker.dart';
import 'package:album/application/controllers/editor/events/description_changed.dart';
import 'package:album/application/controllers/editor/events/picker_tapped.dart';
import 'package:album/application/controllers/editor/events/submitted.dart';
import 'package:album/application/controllers/editor/stores/submit.dart';
import 'package:album/application/controllers/editor/usecases/pick_photo.dart';
import 'package:album/application/controllers/editor/usecases/submit.dart';
import 'package:album/application/controllers/editor/widgets/container.dart';
import 'package:album/application/controllers/editor/widgets/submit_button.dart';
import 'package:album/core/controller/arguments.dart';
import 'package:album/core/controller/controller.dart';
import 'package:album/core/event/event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditorArguments implements Arguments {
  final String albumId;

  const EditorArguments({
    required this.albumId,
  });
}

class Editor extends Controller<EditorArguments> {
  Editor(
    EditorArguments arguments, {
    Key? key,
  }) : super(
          arguments,
          key: key,
          stores: [
            FormStore(),
          ],
          usecases: [
            PickPhotoUseCase(),
            SubmitUseCase(),
          ],
        );

  @override
  Widget render(BuildContext context) {
    return get<FormStore>().subscribe(
      onNext: (data) => PhotoEditorContainer(
        onCanceled: () => to<Editor>().dispatch(const Popped()),
        children: [
          GestureDetector(
            onTap: () {
              if (!data.isImagePickerEnabled) {
                return;
              }

              to<Editor>().dispatch(const PickerTapped());
            },
            child: Container(
              color: Colors.grey[100],
              width: double.infinity,
              child: AspectRatio(
                aspectRatio: 1.0,
                child: data.image != null
                    ? Image(
                        fit: BoxFit.cover,
                        image: FileImage(data.image!),
                      )
                    : Center(
                        child: Icon(
                          Icons.add_photo_alternate,
                          color: CupertinoTheme.of(context).primaryColor,
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 12.0),
          PhotoEditorDatePicker(
            enabled: data.isDatePickerEnabled,
            date: data.date,
          ),
          const SizedBox(height: 12.0),
          CupertinoTextField(
            clearButtonMode: OverlayVisibilityMode.editing,
            placeholder: "기억에 남는 일이 있다면 짧은 감상을 남겨 보세요.",
            keyboardType: TextInputType.text,
            minLines: 3,
            maxLines: 3,
            enabled: data.isDescriptionFieldEnabled,
            onChanged: (text) =>
                to<Editor>().dispatch(DescriptionChanged(value: text)),
          ),
          const SizedBox(height: 16.0),
          PhotoEditorSubmitButton(
            onPressed: () {
              final image = data.image;

              if (image == null) {
                return;
              }

              final date = data.date;

              final description = data.description;

              to<Editor>().dispatch(
                Submitted(
                  albumId: arguments.albumId,
                  image: image,
                  date: date,
                  description: description,
                ),
              );
            },
            state: data.submitButtonState,
          ),
        ],
      ),
    );
  }
}
