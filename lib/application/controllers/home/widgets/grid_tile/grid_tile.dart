import 'package:album/application/controllers/home/widgets/grid_tile_avatar.dart';
import 'package:album/application/models/album.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlbumTile extends StatelessWidget {
  final void Function()? onTap;
  final AlbumModel album;

  const AlbumTile({
    Key? key,
    this.onTap,
    required this.album,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4.0,
                  offset: const Offset(0.0, 2.0),
                )
              ],
            ),
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 1.0,
                  child: album.coverImageUri != null
                      ? Image(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            album.coverImageUri!,
                          ),
                        )
                      : Container(
                          color: CupertinoColors.secondarySystemBackground,
                        ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    for (int j = 0; j < album.users.length * 2 - 1; j++)
                      if (j % 2 == 0)
                        AlbumTileAvatar(
                          networkImageUri: album.users[j ~/ 2].avatarImageUri,
                        )
                      else
                        const SizedBox(width: 4.0)
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 4.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                album.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 2.0),
              Text(
                album.photoCount.toString(),
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
