import 'package:album/application/screens/home/stores/albums.dart';
import 'package:album/application/screens/home/viewmodels/album.dart';
import 'package:album/application/screens/home/widgets/add_album_dialog/controller.dart';
import 'package:album/application/screens/home/widgets/grid_tile/grid_tile.dart';
import 'package:album/application/screens/home/widgets/grid_tile_avatar.dart';
import 'package:album/application/screens/home/widgets/grid_view.dart';
import 'package:album/core/controller.dart';
import 'package:flutter/cupertino.dart';

class Home extends Controller {
  const Home({Key? key}) : super(key: key);

  @override
  Widget render(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: CupertinoPageScaffold(
        child: StreamBuilder(
          stream: HomeAlbumsStore().stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data as List<AlbumViewModel>;

              return CustomScrollView(
                slivers: [
                  CupertinoSliverNavigationBar(
                    largeTitle: const Text("앨범"),
                    leading: CupertinoButton(
                      child: const Icon(CupertinoIcons.add),
                      onPressed: () {
                        showCupertinoDialog(
                            context: context,
                            builder: (context) => HomeAddAlbumDialog());
                      },
                      minSize: 0.0,
                      padding: const EdgeInsets.all(0.0),
                    ),
                  ),
                  HomeGridView(
                    children: [
                      for (int i = 0; i < data.length; i++)
                        HomeGridTile(
                          onTap: () {
                            Navigator.of(context).pushNamed("/album");
                          },
                          title: data[i].title,
                          count: data[i].photoCount,
                          image: data[i].coverImageUri != null
                              ? Image(
                                  image: NetworkImage(
                                    data[i].coverImageUri!,
                                  ),
                                )
                              : null,
                          people: Row(
                            children: [
                              for (int j = 0;
                                  j < data[i].users.length * 2 - 1;
                                  j++)
                                if (j % 2 == 0)
                                  HomeGridTileAvatar(
                                    networkImageUri:
                                        data[i].users[j ~/ 2].avatarImageUri,
                                  )
                                else
                                  const SizedBox(width: 4.0)
                            ],
                          ),
                        ),
                    ],
                  )
                ],
              );
            }

            return const Center(
              child: CupertinoActivityIndicator(),
            );
          },
        ),
      ),
    );
  }
}
