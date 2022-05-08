import 'package:album/core/event/event.dart';

class DateChanged extends Event {
  final DateTime value;

  const DateChanged({required this.value});
}
