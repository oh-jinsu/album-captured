import 'package:album/application/controllers/album/controller.dart';
import 'package:album/application/controllers/home/contollers/dialog_to_add_album/controller.dart';
import 'package:album/application/controllers/home/stores/albums.dart';
import 'package:album/application/controllers/home/usecases/find_albums.dart';
import 'package:album/application/controllers/home/widgets/grid_tile/grid_tile.dart';
import 'package:album/application/controllers/home/widgets/grid_view.dart';
import 'package:album/application/widgets/button.dart';
import 'package:album/core/controller/arguments.dart';
import 'package:album/core/controller/controller.dart';
import 'package:album/core/event/event.dart';
import 'package:flutter/cupertino.dart';

class Home extends Controller {
  Home({Key? key})
      : super(
          const Arguments(),
          key: key,
          stores: [
            AlbumListStore(),
          ],
          usecases: [
            FindAlbumsUseCase(),
          ],
        );

  @override
  Widget render(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      child: Column(
        children: [
          Expanded(
            child: get<AlbumListStore>().subscribe(
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
                    trailing: const Text(
                      "필름 10장",
                      style: TextStyle(
                        color: CupertinoColors.activeBlue,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: AlbumList(
                      children: [
                        for (final item in data)
                          AlbumTile(
                            onTap: () => to<Home>().dispatch(Pushed(
                              "/album",
                              arguments: AlbumArguments(
                                id: item.id,
                                title: item.title,
                              ),
                            )),
                            viewModel: item,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          CupertinoTabBar(
            currentIndex: 0,
            onTap: (index) {
              if (index == 1) {
                to<Home>().dispatch(const Replaced("/profile"));
              }
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(CupertinoIcons.photo)),
              BottomNavigationBarItem(icon: Icon(CupertinoIcons.person)),
            ],
          )
        ],
      ),
    );
  }
}
