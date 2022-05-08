import 'package:album/application/controllers/home/stores/albums.dart';
import 'package:album/application/controllers/home/widgets/grid_tile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlbumTile extends StatelessWidget {
  final void Function()? onTap;
  final AlbumViewModel viewModel;

  const AlbumTile({
    Key? key,
    this.onTap,
    required this.viewModel,
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
                  child: viewModel.coverImageUri != null
                      ? Image(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            viewModel.coverImageUri!,
                          ),
                        )
                      : Container(
                          color: CupertinoColors.secondarySystemBackground,
                        ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    for (int j = 0; j < viewModel.users.length * 2 - 1; j++)
                      if (j % 2 == 0)
                        AlbumTileAvatar(
                          networkImageUri:
                              viewModel.users[j ~/ 2].avatarImageUri,
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
                viewModel.title,
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 2.0),
              Text(
                viewModel.photoCount.toString(),
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
