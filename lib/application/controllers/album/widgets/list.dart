import 'package:album/application/controllers/album/store/photo_list.dart';
import 'package:album/application/controllers/album/widgets/floor.dart';
import 'package:flutter/cupertino.dart';

class AlbumListWidget extends StatefulWidget {
  final List<PhotoViewModel> items;

  const AlbumListWidget({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  State<AlbumListWidget> createState() => _AlbumListWidgetState();
}

class _AlbumListWidgetState extends State<AlbumListWidget> {
  bool _isLoaded = false;

  final List<String> _imageUris = [];

  @override
  void initState() {
    initialize();

    super.initState();
  }

  void initialize() async {
    await Future.delayed(const Duration(milliseconds: 16));

    final imageUris = await Future.wait(widget.items.map(
      (item) async {
        final uri = item.publicImageUri;

        await precacheImage(NetworkImage(uri), context);

        return uri;
      },
    ));

    _imageUris.addAll(imageUris);

    setState(() {
      _isLoaded = true;
    });
  }

  void onRemove(int index) async {
    setState(() {
      _imageUris.removeAt(index);
    });

    if (index != 0) {
      return;
    }

    initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isLoaded
          ? Stack(
              children: [
                for (int i = 0; i < _imageUris.length; i++)
                  AlbumFloorWidget(
                    index: i,
                    imageUri: _imageUris[i],
                    popDuration: 1000 ~/ _imageUris.length,
                    onRemove: onRemove,
                  ),
              ],
            )
          : const CupertinoActivityIndicator(),
    );
  }
}
