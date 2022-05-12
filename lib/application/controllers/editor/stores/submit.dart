import 'dart:io';

import 'package:album/application/controllers/editor/controller.dart';
import 'package:album/application/controllers/editor/events/date_changed.dart';
import 'package:album/application/controllers/editor/events/description_changed.dart';
import 'package:album/application/controllers/editor/events/pending.dart';
import 'package:album/application/controllers/editor/events/preview_added.dart';
import 'package:album/core/common/state.dart';
import 'package:album/core/store/store.dart';

class FormViewModel {
  final File? image;
  final bool isImagePickerEnabled;
  final DateTime date;
  final bool isDatePickerEnabled;
  final String? description;
  final bool isDescriptionFieldEnabled;
  final ButtonState submitButtonState;

  const FormViewModel({
    required this.image,
    required this.isImagePickerEnabled,
    required this.date,
    required this.isDatePickerEnabled,
    required this.description,
    required this.isDescriptionFieldEnabled,
    required this.submitButtonState,
  });

  FormViewModel copy({
    File? image,
    bool? isImagePickerEnabled,
    DateTime? date,
    bool? isDatePickerEnabled,
    String? description,
    bool? isDescriptionFieldEnabled,
    ButtonState? submitButtonState,
  }) {
    return FormViewModel(
      image: image ?? this.image,
      isImagePickerEnabled: isImagePickerEnabled ?? this.isImagePickerEnabled,
      date: date ?? this.date,
      isDatePickerEnabled: isDatePickerEnabled ?? this.isDatePickerEnabled,
      description: description ?? this.description,
      isDescriptionFieldEnabled:
          isDescriptionFieldEnabled ?? this.isDescriptionFieldEnabled,
      submitButtonState: submitButtonState ?? this.submitButtonState,
    );
  }
}

class FormStore extends Store<FormViewModel> {
  FormStore()
      : super(InitialData(FormViewModel(
          image: null,
          isImagePickerEnabled: true,
          date: DateTime.now(),
          isDatePickerEnabled: true,
          description: null,
          isDescriptionFieldEnabled: true,
          submitButtonState: ButtonState.disabled,
        )));

  @override
  void onListen() {
    of<Editor>()
      ..on<PreviewAdded>(_onPreviewAdded)
      ..on<DateChanged>(_onDateChanged)
      ..on<DescriptionChanged>(_onDescriptionChanged)
      ..on<Pending>(_onPending);
  }

  Future<FormViewModel> _onPending(Pending event) async {
    return value.copy(
      submitButtonState: ButtonState.pending,
      isImagePickerEnabled: false,
      isDatePickerEnabled: false,
      isDescriptionFieldEnabled: false,
    );
  }

  Future<FormViewModel> _onPreviewAdded(PreviewAdded event) async {
    if (value.submitButtonState == ButtonState.pending) {
      return value;
    }

    return value.copy(
        image: event.body, submitButtonState: ButtonState.enabled);
  }

  Future<FormViewModel> _onDateChanged(DateChanged event) async {
    if (value.submitButtonState == ButtonState.pending) {
      return value;
    }

    return value.copy(date: event.value);
  }

  Future<FormViewModel> _onDescriptionChanged(DescriptionChanged event) async {
    if (value.submitButtonState == ButtonState.pending) {
      return value;
    }

    return value.copy(description: event.value);
  }
}
