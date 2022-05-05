import 'package:album/core/event/event.dart';

class Submitted extends Event {
  final String title;

  const Submitted({required this.title});
}
