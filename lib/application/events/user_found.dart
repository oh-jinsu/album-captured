import 'package:album/application/models/user.dart';
import 'package:album/core/event/event.dart';

class UserFound extends OutputEvent<UserModel> {
  const UserFound({required UserModel body}) : super(body: body);
}
