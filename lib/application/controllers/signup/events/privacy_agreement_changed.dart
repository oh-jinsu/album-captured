import 'package:album/core/event/event.dart';

class PrivacyAgreementChanged extends Event {
  final bool value;

  const PrivacyAgreementChanged({
    required this.value,
  });
}
