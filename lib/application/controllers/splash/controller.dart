import 'package:album/core/controller.dart';
import 'package:flutter/cupertino.dart';

class Splash extends Controller {
  Splash({Key? key}) : super(key: key);

  @override
  Widget render(BuildContext context) {
    return const CupertinoPageScaffold(
      child: Center(
        child: CupertinoActivityIndicator(),
      ),
    );
  }
}
