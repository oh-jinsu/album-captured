import 'package:album/core/event.dart';

class SumbmitFailed extends OutputEvent<String> {
  SumbmitFailed({required body}) : super(body: body);
}
