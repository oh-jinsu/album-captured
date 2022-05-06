import 'package:album/application/controllers/album/store/photo_list.dart';
import 'package:album/application/controllers/album/usecases/find_photo_list.dart';
import 'package:album/application/controllers/album/widgets/list.dart';
import 'package:album/application/controllers/controllers/editor/controller.dart';
import 'package:album/application/widgets/button.dart';
import 'package:album/core/controller/arguments.dart';
import 'package:album/core/controller/controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AlbumArguments extends Arguments {
  final String id;
  final String title;

  const AlbumArguments({
    required this.id,
    required this.title,
  });
}

class Album extends Controller<AlbumArguments> {
  Album(
    AlbumArguments arguments, {
    Key? key,
  }) : super(
          key: key,
          arguments: arguments,
          usecases: [
            FindPhotoListUseCase(),
          ],
        );

  @override
  Widget render(BuildContext context) {
    return CupertinoPageScaffold(
      child: Column(
        children: [
          CupertinoNavigationBar(
            middle: Text(
              arguments.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: PhotoListStore().subscribe(
              onNext: (data) => AlbumListWidget(items: data.items),
              onLoad: () => Container(),
            ),
          ),
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AppButton(
                  child: const Icon(
                    CupertinoIcons.person_2,
                  ),
                  onPressed: () => {},
                ),
                AppButton(
                  child: const Icon(
                    CupertinoIcons.plus_square,
                  ),
                  onPressed: () =>
                      CupertinoScaffold.showCupertinoModalBottomSheet(
                    context: context,
                    builder: (context) => Editor(),
                  ),
                ),
                AppButton(
                  child: const Icon(
                    CupertinoIcons.ellipsis_circle,
                  ),
                  onPressed: () => {},
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
