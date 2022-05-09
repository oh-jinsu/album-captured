import 'package:album/application/controllers/album/store/photo_list.dart';
import 'package:album/application/controllers/album/usecases/find_photo_list.dart';
import 'package:album/application/controllers/album/widgets/list.dart';
import 'package:album/application/controllers/editor/controller.dart';
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
          arguments,
          key: key,
          stores: [
            PhotoListStore(),
          ],
          usecases: [
            FindPhotoListUseCase(),
          ],
        );

  @override
  Widget render(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          get<PhotoListStore>().subscribe(
            onNext: (data) => Padding(
              padding: const EdgeInsets.only(top: 48.0),
              child: AlbumListWidget(items: data.items),
            ),
            onLoad: () => Container(),
          ),
          CupertinoNavigationBar(
            middle: Text(
              arguments.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              padding: const EdgeInsets.only(top: 16.0),
              color: CupertinoColors.systemBackground,
              child: SafeArea(
                top: false,
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
                        expand: true,
                        context: context,
                        builder: (context) => Editor(
                          EditorArguments(
                            albumId: arguments.id,
                          ),
                        ),
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
              ),
            ),
          )
        ],
      ),
    );
  }
}
