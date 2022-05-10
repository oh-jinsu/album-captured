import 'package:album/core/event/event.dart';

class EmailChanged extends Event {
  final String value;

  const EmailChanged({
    required this.value,
  });
}
