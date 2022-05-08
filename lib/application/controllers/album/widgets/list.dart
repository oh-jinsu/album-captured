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

  final List<PhotoViewModel> _items = [];

  @override
  void initState() {
    initialize();

    super.initState();
  }

  void initialize() async {
    await Future.delayed(const Duration(milliseconds: 16));

    await Future.wait(widget.items.map(
      (item) async {
        final uri = item.publicImageUri;

        await precacheImage(NetworkImage(uri), context);

        return uri;
      },
    ));

    _items.addAll(widget.items);

    setState(() {
      _isLoaded = true;
    });
  }

  void onRemove(int index) async {
    setState(() {
      _items.removeAt(index);
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
                for (int i = 0; i < _items.length; i++)
                  AlbumFloorWidget(
                    index: i,
                    imageUri: _items[i].publicImageUri,
                    date: _items[i].date,
                    description: _items[i].description,
                    popDuration: 1000 ~/ _items.length,
                    onRemove: onRemove,
                  ),
              ],
            )
          : const CupertinoActivityIndicator(),
    );
  }
}
