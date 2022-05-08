import 'package:album/application/controllers/editor/widgets/bottom_inset.dart';
import 'package:album/application/controllers/editor/widgets/drawer.dart';
import 'package:album/application/controllers/editor/widgets/label.dart';
import 'package:album/application/widgets/button.dart';
import 'package:flutter/material.dart';

class PhotoEditorContainer extends StatefulWidget {
  final void Function()? onCanceled;

  final List<Widget> children;

  const PhotoEditorContainer({
    Key? key,
    this.onCanceled,
    required this.children,
  }) : super(key: key);

  @override
  State<PhotoEditorContainer> createState() => _PhotoEditorContainerState();
}

class _PhotoEditorContainerState extends State<PhotoEditorContainer> {
  late final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 6.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PhotoEditorDrawer(),
          const SizedBox(height: 12.0),
          AppButton(
            onPressed: () => widget.onCanceled?.call(),
            child: const Text(
              "취소",
            ),
          ),
          const SizedBox(height: 16.0),
          const PhotoEditorLabel(),
          const SizedBox(height: 16.0),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  ...widget.children,
                  BottomInset(
                    onEnlarge: () {
                      _scrollController
                          .jumpTo(_scrollController.position.maxScrollExtent);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
