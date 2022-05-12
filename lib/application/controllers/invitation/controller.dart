import 'package:album/core/controller/arguments.dart';
import 'package:album/core/controller/controller.dart';
import 'package:flutter/cupertino.dart';

class InvitationArguments extends Arguments {
  final String token;

  const InvitationArguments({
    required this.token,
  });
}

class Invitation extends Controller<InvitationArguments> {
  Invitation(InvitationArguments arguments, {Key? key})
      : super(
          arguments,
          key: key,
        );

  @override
  Widget render(BuildContext context) {
    return const CupertinoPageScaffold(
      child: Center(
        child: CupertinoActivityIndicator(),
      ),
    );
  }
}
