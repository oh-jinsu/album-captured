import 'package:album/application/controllers/album/controller.dart';
import 'package:album/application/controllers/home/contollers/dialog_to_add_album/controller.dart';
import 'package:album/application/controllers/home/stores/albums.dart';
import 'package:album/application/controllers/home/usecases/find_albums.dart';
import 'package:album/application/controllers/home/widgets/grid_tile/grid_tile.dart';
import 'package:album/application/controllers/home/widgets/grid_view.dart';
import 'package:album/application/widgets/button.dart';
import 'package:album/core/controller/controller.dart';
import 'package:album/core/event/event.dart';
import 'package:flutter/cupertino.dart';

class Home extends Controller {
  Home({Key? key})
      : super(
          key: key,
          usecases: [
            FindAlbumsUseCase(),
          ],
        );

  @override
  Widget render(BuildContext context) {
    return CupertinoPageScaffold(
      child: AlbumListStore().subscribe(
        onNext: (data) => CustomScrollView(
          slivers: [
            CupertinoSliverNavigationBar(
              largeTitle: const Text("앨범"),
              leading: AppButton(
                onPressed: () => showCupertinoDialog(
                  context: context,
                  builder: (context) => DialogToAddAlbum(),
                ),
                child: const Icon(CupertinoIcons.add),
              ),
            ),
            AlbumList(
              children: [
                for (final item in data)
                  AlbumTile(
                    onTap: () => of<Home>().dispatch(Pushed(
                      "/album",
                      arguments: AlbumArguments(
                        id: item.id,
                        title: item.title,
                      ),
                    )),
                    viewModel: item,
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
