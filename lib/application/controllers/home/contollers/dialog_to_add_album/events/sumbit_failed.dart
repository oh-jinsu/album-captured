import 'package:album/core/event/event.dart';

class SumbmitFailed extends OutputEvent<String> {
  SumbmitFailed({required body}) : super(body: body);
}
