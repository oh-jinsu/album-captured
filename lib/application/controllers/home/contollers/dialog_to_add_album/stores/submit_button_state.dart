import 'package:album/application/controllers/home/contollers/dialog_to_add_album/controller.dart';
import 'package:album/application/controllers/home/contollers/dialog_to_add_album/events/pending.dart';
import 'package:album/application/controllers/home/contollers/dialog_to_add_album/events/title_changed.dart';
import 'package:album/core/common/state.dart';
import 'package:album/core/store/store.dart';

class SubmitButtonStateStore extends Store<ButtonState> {
  SubmitButtonStateStore() : super(InitialData(ButtonState.disabled));

  @override
  void onListen() => of<DialogToAddAlbum>()
    ..on<TitleChanged>(_onTitleChanged)
    ..on<Pending>(_onAlbumPending);

  Future<ButtonState> _onTitleChanged(TitleChanged event) async {
    if (value == ButtonState.pending) {
      return value;
    }

    final title = event.value;

    if (title.isEmpty || title.length > 24) {
      return ButtonState.disabled;
    }

    return ButtonState.enabled;
  }

  Future<ButtonState> _onAlbumPending(Pending event) async {
    return ButtonState.pending;
  }
}
