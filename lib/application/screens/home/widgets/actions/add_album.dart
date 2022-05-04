import 'dart:async';

import 'package:album/application/screens/home/models/album.dart';
import 'package:album/application/screens/home/models/album_user.dart';
import 'package:album/application/screens/home/widgets/add_album_dialog/event/add_album.dart';
import 'package:album/application/screens/home/widgets/add_album_dialog/event/album_added.dart';
import 'package:album/repositories/auth.dart';
import 'package:album/utils/fetch.dart';
import 'package:rxdart/subjects.dart';

final addAlbumActionController = PublishSubject();

late StreamSubscription _subscription;

observeAddAlbum() {
  _subscription = addAlbumEvent.stream.listen((event) async {
    final accessToken = await authRepository.findAccessToken();

    final uri = Uri.parse("http://localhost:3000/v1/album");

    final response = await post(uri, headers: {
      "Authorization": "Bearer $accessToken",
    }, body: {
      "title": event.title,
    });

    if (response is! SuccessResponse) {
      return;
    }

    final body = response.body;

    final model = AlbumModel(
      id: body["id"],
      coverImageUri: body["cover_image_uri"],
      title: body["title"],
      users: (body["users"] as List)
          .map(
            (e) => AlbumUserModel(
              id: e["id"],
              avatarImageUri: e["avatar_image_uri"],
              name: e["name"],
              joinedAt: DateTime.parse(
                e["joined_at"],
              ),
            ),
          )
          .toList(),
      photoCount: body["photo_count"],
    );

    albumAddedEvent.add(model);
  }, onDone: () {
    addAlbumActionController.close();
  }, onError: (e) {
    addAlbumActionController.close();
  });
}

detachAddAlbum() {
  _subscription.cancel();
}
