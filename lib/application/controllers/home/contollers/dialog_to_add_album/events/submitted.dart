import 'package:album/core/event.dart';

class Submitted extends Event {
  final String title;

  const Submitted({required this.title});
}
