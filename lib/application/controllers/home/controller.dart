import 'package:album/application/controller.dart';
import 'package:album/application/controllers/album/controller.dart';
import 'package:album/application/controllers/home/contollers/dialog_to_add_album/controller.dart';
import 'package:album/application/stores/album_list.dart';
import 'package:album/application/controllers/home/widgets/grid_tile/grid_tile.dart';
import 'package:album/application/controllers/home/widgets/grid_view.dart';
import 'package:album/application/widgets/button.dart';
import 'package:album/core/controller/arguments.dart';
import 'package:album/core/controller/controller.dart';
import 'package:album/infrastructure/providers/navigation.dart';
import 'package:flutter/cupertino.dart';

class Home extends Controller {
  Home({Key? key})
      : super(
          const Arguments(),
          key: key,
        );

  @override
  Widget render(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      child: Column(
        children: [
          Expanded(
            child: of<App>().require<AlbumListStore>().subscribe(
                  onLoad: () => Container(),
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
                                onTap: () => use<Coordinator>().push(
                                  "/album",
                                  arguments: AlbumArguments(
                                    id: item.id,
                                    title: item.title,
                                  ),
                                ),
                                album: item,
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
                use<Coordinator>().push("/profile");
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
