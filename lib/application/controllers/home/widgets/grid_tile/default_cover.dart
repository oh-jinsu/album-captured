import 'package:flutter/cupertino.dart';

class HomeGridTileDefaultCover extends StatelessWidget {
  const HomeGridTileDefaultCover({Key? key}) : super(key: key);

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
