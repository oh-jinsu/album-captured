import 'package:album/application/controller.dart';
import 'package:album/application/controllers/album/controller.dart';
import 'package:album/application/controllers/album/events/photo_list_found.dart';
import 'package:album/application/controllers/album/models/list_of_photo.dart';
import 'package:album/application/controllers/signup/models/form.dart';
import 'package:album/application/events/photo_added.dart';
import 'package:album/core/store/store.dart';
import 'package:album/core/store/util.dart';

class PhotoListStore extends Store<ListOfPhotoModel> {
  @override
  void onListen() {
    of<Album>().on<PhotoListFound>(_onPhotoListFound);
    of<App>().on<PhotoAdded>(_onPhotoAdded);
  }

  Future<ListOfPhotoModel> _onPhotoListFound(PhotoListFound event) async {
    if (hasValue) {
      return event.body.copy(
        items: Arg(
          [
            ...value.items,
            ...await Future.wait(
              event.body.items.map(
                (e) async => e.copy(
                  publicImageUri: Arg(
                    await StoreCacheUtil.network(e.publicImageUri),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }

    return event.body.copy(
      items: Arg(
        await Future.wait(
          event.body.items.map(
            (e) async => e.copy(
              publicImageUri: Arg(
                await StoreCacheUtil.network(e.publicImageUri),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<ListOfPhotoModel> _onPhotoAdded(PhotoAdded event) async {
    if (hasValue) {
      return value.copy(
        items: Arg(
          [
            ...value.items,
            event.body.copy(
              publicImageUri: Arg(
                await StoreCacheUtil.network(
                  event.body.publicImageUri,
                ),
              ),
            )
          ],
        ),
      );
    }

    return ListOfPhotoModel(next: null, items: [
      event.body.copy(
        publicImageUri: Arg(
          await StoreCacheUtil.network(
            event.body.publicImageUri,
          ),
        ),
      )
    ]);
  }
}
