import 'package:album/application/controller.dart';
import 'package:album/application/events/signed_out.dart';
import 'package:album/application/events/user_found.dart';
import 'package:album/application/models/user.dart';
import 'package:album/core/store/store.dart';

class UserStore extends Store<UserModel?> {
  UserStore() : super(InitialData(null));

  @override
  void onListen() {
    of<App>()
      ..on<UserFound>(_onUserFound)
      ..on<SignedOut>(_onSignedOut);
  }

  UserModel? _onUserFound(UserFound event) {
    return event.body;
  }

  UserModel? _onSignedOut(SignedOut event) {
    return null;
  }
}
