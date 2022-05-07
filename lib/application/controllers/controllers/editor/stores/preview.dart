import 'package:album/application/controllers/controllers/editor/controller.dart';
import 'package:album/application/controllers/controllers/editor/events/preview_added.dart';
import 'package:album/core/store/store.dart';

class PreviewViewModel {
  final String path;

  const PreviewViewModel({
    required this.path,
  });
}

class PreviewStore extends Store<PreviewViewModel> {
  @override
  void onListen() {
    of<Editor>().on<PreviewAdded>(_onPreviewAdded);
  }

  PreviewViewModel _onPreviewAdded(PreviewAdded event) {
    return PreviewViewModel(path: event.body.path);
  }
}
