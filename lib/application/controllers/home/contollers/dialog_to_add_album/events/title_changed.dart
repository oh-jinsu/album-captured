import 'package:album/core/event/event.dart';

class TitleChanged extends Event {
  final String value;

  const TitleChanged({required this.value});
}
