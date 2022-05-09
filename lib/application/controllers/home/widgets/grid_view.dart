import 'package:flutter/material.dart';

class AlbumList extends StatelessWidget {
  final List<Widget> children;

  const AlbumList({
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12.0,
      childAspectRatio: 1 / 1.6,
      padding: const EdgeInsets.all(16.0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: children,
    );
  }
}
