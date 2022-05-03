import 'package:album/core/controller.dart';
import 'package:flutter/cupertino.dart';

class SplashController extends Controller {
  const SplashController({Key? key}) : super(key: key);

  @override
  Widget render(BuildContext context) {
    return const CupertinoPageScaffold(
      child: Center(
        child: CupertinoActivityIndicator(),
      ),
    );
  }
}
