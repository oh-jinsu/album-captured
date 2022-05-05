import 'package:album/application/controllers/home/stores/albums.dart';
import 'package:album/application/controllers/home/widgets/grid_tile/grid_tile.dart';
import 'package:album/application/controllers/home/widgets/grid_view.dart';
import 'package:album/application/widgets/button.dart';
import 'package:album/core/controller.dart';
import 'package:flutter/cupertino.dart';

class Home extends Controller {
  const Home({Key? key}) : super(key: key);

  @override
  Widget render(BuildContext context) {
    return CupertinoPageScaffold(
      child: AlbumListStore().subscribe(
        onNext: (data) => CustomScrollView(
          slivers: [
            CupertinoSliverNavigationBar(
              largeTitle: const Text("앨범"),
              leading: AppButton(
                onPressed: () {},
                child: const Icon(CupertinoIcons.add),
              ),
            ),
            AlbumList(
              children: [
                for (final item in data)
                  AlbumTile(
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
