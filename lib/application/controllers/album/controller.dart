import 'package:album/core/controller/arguments.dart';
import 'package:album/core/controller/controller.dart';
import 'package:flutter/cupertino.dart';

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
  }) : super(key: key, arguments: arguments);

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
      ],
    ));
  }
}
