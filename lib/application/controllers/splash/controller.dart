import 'package:album/core/controller/arguments.dart';
import 'package:album/core/controller/controller.dart';
import 'package:flutter/cupertino.dart';

class Splash extends Controller {
  Splash({Key? key}) : super(const Arguments(), key: key);

  @override
  Widget render(BuildContext context) {
    return const CupertinoPageScaffold(
      child: Center(
        child: CupertinoActivityIndicator(),
      ),
    );
  }
}
