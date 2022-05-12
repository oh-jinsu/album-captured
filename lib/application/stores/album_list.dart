import 'package:album/application/controller.dart';
import 'package:album/application/controllers/signup/models/form.dart';
import 'package:album/application/events/album_added.dart';
import 'package:album/application/events/photo_added.dart';
import 'package:album/application/events/albums_found.dart';
import 'package:album/application/models/album.dart';
import 'package:album/core/store/store.dart';
import 'package:album/core/store/util.dart';

class AlbumListStore extends Store<List<AlbumModel>> {
  @override
  onListen() => of<App>()
    ..on<AlbumsFound>(_onAlbumsFound)
    ..on<AlbumAdded>(_onAlbumAdded)
    ..on<PhotoAdded>(_onPhotoAdded);

  Future<List<AlbumModel>> _onAlbumsFound(AlbumsFound event) async {
    return await Future.wait(event.body.items
        .map(
          (e) async => e.copy(
            coverImageUri: e.coverImageUri != null
                ? Arg(await StoreCacheUtil.network(
                    e.coverImageUri!,
                    resolution: StoreCacheRes.xhdpi,
                  ))
                : null,
            users: Arg(
              await Future.wait(
                e.users
                    .map(
                      (e) async => e.copy(
                        avatarImageUri: e.avatarImageUri != null
                            ? Arg(
                                await StoreCacheUtil.network(
                                  e.avatarImageUri!,
                                  resolution: StoreCacheRes.mdpi,
                                ),
                              )
                            : null,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        )
        .toList());
  }

  Future<List<AlbumModel>> _onAlbumAdded(AlbumAdded event) async {
    final newone = event.body.copy(
      coverImageUri: event.body.coverImageUri != null
          ? Arg(
              await StoreCacheUtil.network(
                event.body.coverImageUri!,
                resolution: StoreCacheRes.xhdpi,
              ),
            )
          : null,
      users: Arg(
        await Future.wait(
          event.body.users
              .map(
                (e) async => e.copy(
                  avatarImageUri: e.avatarImageUri != null
                      ? Arg(
                          await StoreCacheUtil.network(
                            e.avatarImageUri!,
                            resolution: StoreCacheRes.mdpi,
                          ),
                        )
                      : null,
                ),
              )
              .toList(),
        ),
      ),
    );

    if (hasValue) {
      return [newone, ...value];
    }

    return [newone];
  }

  Future<List<AlbumModel>> _onPhotoAdded(PhotoAdded event) async {
    return Future.wait(value.map((e) async {
      if (e.id != event.body.albumId) {
        return e;
      }

      return e.copy(
        coverImageUri: Arg(
          await StoreCacheUtil.network(
            event.body.publicImageUri,
            resolution: StoreCacheRes.xhdpi,
          ),
        ),
        photoCount: Arg(e.photoCount + 1),
      );
    }).toList());
  }
}
