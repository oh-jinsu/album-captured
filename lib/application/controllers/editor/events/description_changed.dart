import 'package:album/core/event/event.dart';

class DescriptionChanged extends Event {
  final String value;

  const DescriptionChanged({required this.value});
}
