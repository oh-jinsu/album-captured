import 'package:album/application/controllers/home/widgets/grid_tile/default_cover.dart';
import 'package:flutter/material.dart';

class HomeGridTile extends StatelessWidget {
  final String title;
  final int count;
  final String? coverImageUri;
  final Widget people;

  const HomeGridTile({
    Key? key,
    required this.title,
    required this.count,
    required this.coverImageUri,
    required this.people,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: () {},
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
                  child: coverImageUri != null
                      ? Image(
                          image: NetworkImage(
                            coverImageUri!,
                          ),
                        )
                      : const HomeGridTileDefaultCover(),
                ),
                const SizedBox(height: 8.0),
                people,
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
                title,
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 2.0),
              Text(
                count.toString(),
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
