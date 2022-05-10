import 'package:album/core/event/event.dart';

class NameChanged extends Event {
  final String value;

  const NameChanged({
    required this.value,
  });
}
