import 'package:album/core/event/event.dart';

class ServiceAgreementChanged extends Event {
  final bool value;

  const ServiceAgreementChanged({
    required this.value,
  });
}
