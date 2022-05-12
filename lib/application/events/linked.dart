import 'package:album/core/event/event.dart';

class InvitationAccepted extends Event {
  final String token;

  const InvitationAccepted({
    required this.token,
  });
}
