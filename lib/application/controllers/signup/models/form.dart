import 'dart:io';

import 'package:album/core/common/state.dart';

class Arg<T> {
  final T value;

  const Arg(this.value);
}

class SignUpFormModel {
  final File? avatar;
  final String name;
  final String? nameMessage;
  final String email;
  final String? emailMessage;
  final bool isServiceAgreed;
  final bool isPrivacyAgreed;
  final SubmitFormState state;

  const SignUpFormModel({
    required this.avatar,
    required this.name,
    required this.nameMessage,
    required this.email,
    required this.emailMessage,
    required this.isServiceAgreed,
    required this.isPrivacyAgreed,
    required this.state,
  });

  SignUpFormModel copy({
    Arg<File?>? avatar,
    Arg<String>? name,
    Arg<String?>? nameMessage,
    Arg<String>? email,
    Arg<String?>? emailMessage,
    Arg<bool>? isServiceAgreed,
    Arg<bool>? isPrivacyAgreed,
    Arg<SubmitFormState>? state,
  }) {
    return SignUpFormModel(
      avatar: avatar != null ? avatar.value : this.avatar,
      name: name != null ? name.value : this.name,
      nameMessage: nameMessage != null ? nameMessage.value : this.nameMessage,
      email: email != null ? email.value : this.email,
      emailMessage:
          emailMessage != null ? emailMessage.value : this.emailMessage,
      isServiceAgreed: isServiceAgreed != null
          ? isServiceAgreed.value
          : this.isServiceAgreed,
      isPrivacyAgreed: isPrivacyAgreed != null
          ? isPrivacyAgreed.value
          : this.isPrivacyAgreed,
      state: state != null ? state.value : this.state,
    );
  }
}
