import 'package:flutter/cupertino.dart';

class AlbumDefaultCover extends StatelessWidget {
  const AlbumDefaultCover({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoColors.secondarySystemBackground,
      child: const Icon(
        CupertinoIcons.photo,
        color: CupertinoColors.systemGrey,
      ),
    );
  }
}
