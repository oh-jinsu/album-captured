import 'package:flutter/material.dart';

class MenuContainer extends StatelessWidget {
  final List<Widget> children;

  const MenuContainer({
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            for (int i = 0; i < children.length * 2 - 1; i++)
              if (i % 2 == 0)
                children[i ~/ 2]
              else
                const Divider(
                  height: 1.0,
                ),
          ],
        ),
      ),
    );
  }
}
