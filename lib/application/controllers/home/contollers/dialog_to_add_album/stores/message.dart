import 'package:album/application/controllers/home/contollers/dialog_to_add_album/controller.dart';
import 'package:album/application/controllers/home/contollers/dialog_to_add_album/events/sumbit_failed.dart';
import 'package:album/application/controllers/home/contollers/dialog_to_add_album/events/title_changed.dart';
import 'package:album/core/store/store.dart';

class MessageStore extends Store<String?> {
  MessageStore() : super(InitialData(null));

  @override
  void onListen() {
    of<DialogToAddAlbum>()
      ..on<TitleChanged>(_onTitleChanged)
      ..on<SumbmitFailed>(_onSubmitFailed);
  }

  String? _onTitleChanged(TitleChanged event) {
    if (event.value.isEmpty) {
      return "제목은 1글자 이상이어야 합니다.";
    }

    if (event.value.length > 24) {
      return "제목은 24글자 이하여야 합니다.";
    }

    return null;
  }

  String? _onSubmitFailed(SumbmitFailed event) {
    return event.body;
  }
}
