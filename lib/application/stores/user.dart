import 'package:album/application/controller.dart';
import 'package:album/application/controllers/signup/models/form.dart';
import 'package:album/application/events/signed_out.dart';
import 'package:album/application/events/user_found.dart';
import 'package:album/application/models/user.dart';
import 'package:album/core/store/store.dart';
import 'package:album/core/store/util.dart';

class UserStore extends Store<UserModel?> {
  UserStore() : super(InitialData(null));

  @override
  void onListen() {
    of<App>()
      ..on<UserFound>(_onUserFound)
      ..on<SignedOut>(_onSignedOut);
  }

  Future<UserModel?> _onUserFound(UserFound event) async {
    return event.body.copy(
      avatarImageUri: event.body.avatarImageUri != null
          ? Arg(
              await StoreCacheUtil.network(
                event.body.avatarImageUri!,
                resolution: StoreCacheRes.mdpi,
              ),
            )
          : null,
    );
  }

  Future<UserModel?> _onSignedOut(SignedOut event) async {
    return null;
  }
}
