import 'package:album/application/controllers/album/controller.dart';
import 'package:album/application/controllers/album/events/photo_list_found.dart';
import 'package:album/application/controllers/album/models/photo.dart';
import 'package:album/core/store/store.dart';

class PhotoViewModel {
  final String id;
  final String publicImageUri;
  final DateTime date;
  final String? description;

  const PhotoViewModel({
    required this.id,
    required this.publicImageUri,
    required this.date,
    required this.description,
  });

  factory PhotoViewModel.fromModel(PhotoModel model) {
    return PhotoViewModel(
      id: model.id,
      publicImageUri: model.publicImageUri,
      date: model.date,
      description: model.description,
    );
  }
}

class ListOfPhotoViewmodel {
  final String? next;

  final List<PhotoViewModel> items;

  const ListOfPhotoViewmodel({
    required this.next,
    required this.items,
  });
}

class PhotoListStore extends Store<ListOfPhotoViewmodel> {
  @override
  void onListen() {
    of<Album>().on<PhotoListFound>(_onPhotoListFound);
  }

  ListOfPhotoViewmodel _onPhotoListFound(PhotoListFound event) {
    if (hasValue) {
      return ListOfPhotoViewmodel(next: event.body.next, items: [
        ...value.items,
        ...event.body.items.map(PhotoViewModel.fromModel)
      ]);
    }

    return ListOfPhotoViewmodel(
      next: event.body.next,
      items: event.body.items.map(PhotoViewModel.fromModel).toList(),
    );
  }
}
