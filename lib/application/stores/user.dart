import 'package:album/application/controller.dart';
import 'package:album/application/events/user_found.dart';
import 'package:album/application/models/user.dart';
import 'package:album/core/store/store.dart';

class UserStore extends Store<UserModel> {
  @override
  void onListen() {
    of<App>().on<UserFound>(_onUserFound);
  }

  UserModel _onUserFound(UserFound event) {
    return event.body;
  }
}
