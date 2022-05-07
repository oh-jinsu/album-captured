import 'dart:io';

import 'package:album/application/controllers/controllers/editor/events/picker_tapped.dart';
import 'package:album/application/controllers/controllers/editor/stores/preview.dart';
import 'package:album/application/controllers/controllers/editor/usecases/pick_photo.dart';
import 'package:album/application/controllers/controllers/editor/widgets/container.dart';
import 'package:album/application/controllers/controllers/editor/widgets/date_picker.dart';
import 'package:album/application/controllers/controllers/editor/widgets/drawer.dart';
import 'package:album/application/controllers/controllers/editor/widgets/label.dart';
import 'package:album/application/controllers/controllers/editor/widgets/submit_button.dart';
import 'package:album/application/widgets/button.dart';
import 'package:album/core/controller/controller.dart';
import 'package:album/core/event/event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Editor extends Controller {
  Editor({Key? key})
      : super(
          key: key,
          usecases: [
            PickPhotoUseCase(),
          ],
        );

  @override
  Widget render(BuildContext context) {
    return PhotoEditorContainer(
      onCanceled: () => of<Editor>().dispatch(const Popped()),
      children: [
        GestureDetector(
          onTap: () => of<Editor>().dispatch(const PickerTapped()),
          child: Container(
            color: Colors.grey[100],
            width: double.infinity,
            child: AspectRatio(
              aspectRatio: 1.0,
              child: PreviewStore().subscribe(
                onNext: (data) => Image(
                  fit: BoxFit.cover,
                  image: FileImage(File(data.path)),
                ),
                onLoad: () => const Center(
                  child: Icon(
                    Icons.add_a_photo,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12.0),
        const PhotoEditorDatePicker(),
        const SizedBox(height: 12.0),
        const CupertinoTextField(
          clearButtonMode: OverlayVisibilityMode.editing,
          placeholder: "기억에 남는 일이 있다면 짧은 감상을 남겨 보세요.",
          keyboardType: TextInputType.text,
          minLines: 3,
          maxLines: 3,
        ),
        const SizedBox(height: 16.0),
        const PhotoEditorSubmitButton(),
      ],
    );
  }
}
