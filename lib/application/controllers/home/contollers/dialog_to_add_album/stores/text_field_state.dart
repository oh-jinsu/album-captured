import 'package:album/application/controllers/home/contollers/dialog_to_add_album/controller.dart';
import 'package:album/application/controllers/home/contollers/dialog_to_add_album/events/pending.dart';
import 'package:album/core/common/state.dart';
import 'package:album/core/store/store.dart';

class TextFieldStateStore extends Store<TextFieldState> {
  TextFieldStateStore() : super(InitialData(TextFieldState.enabled));

  @override
  void onListen() {
    of<DialogToAddAlbum>().on<Pending>(_onPending);
  }

  TextFieldState _onPending(Pending event) {
    return TextFieldState.disabled;
  }
}
