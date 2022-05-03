import 'package:album/core/controller.dart';
import 'package:flutter/cupertino.dart';

class HomeController extends Controller {
  const HomeController({Key? key}) : super(key: key);

  @override
  Widget render(BuildContext context) {
    return const CupertinoPageScaffold(
      child: Center(
        child: Text("Hello world!"),
      ),
    );
  }
}
