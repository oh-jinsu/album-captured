import 'package:album/application/controllers/signup/controller.dart';
import 'package:album/application/controllers/signup/events/avatar_picked.dart';
import 'package:album/application/controllers/signup/events/email_changed.dart';
import 'package:album/application/controllers/signup/events/name_changed.dart';
import 'package:album/application/controllers/signup/events/pending.dart';
import 'package:album/application/controllers/signup/events/privacy_agreement_changed.dart';
import 'package:album/application/controllers/signup/events/service_agreement_changed.dart';
import 'package:album/application/controllers/signup/models/form.dart';
import 'package:album/core/common/state.dart';
import 'package:album/core/store/store.dart';

class SignUpFormStore extends Store<SignUpFormModel> {
  SignUpFormStore()
      : super(InitialData(
          const SignUpFormModel(
            avatar: null,
            name: "",
            nameMessage: null,
            email: "",
            emailMessage: null,
            isServiceAgreed: false,
            isPrivacyAgreed: false,
            state: SubmitFormState.disabled,
          ),
        ));

  @override
  void onListen() {
    of<SignUp>()
      ..on<AvatarPicked>(_onAvatarPicked)
      ..on<NameChanged>(_onNameChanged)
      ..on<EmailChanged>(_onEmailChanged)
      ..on<ServiceAgreementChanged>(_onServiceAgreementChanged)
      ..on<PrivacyAgreementChanged>(_onPrivacyAgreementChanged)
      ..on<Pending>(_onPending);
  }

  Future<SignUpFormModel> _onAvatarPicked(AvatarPicked event) async {
    return value.copy(avatar: Arg(event.file));
  }

  Future<SignUpFormModel> _onNameChanged(NameChanged event) async {
    if (event.value.isEmpty) {
      return value.copy(
        name: Arg(event.value),
        nameMessage: const Arg("이름은 1글자 이상이어야 합니다."),
        state: const Arg(SubmitFormState.disabled),
      );
    }

    if (event.value.length > 12) {
      return value.copy(
        name: Arg(event.value),
        nameMessage: const Arg("이름은 12글자 이하여야 합니다."),
        state: const Arg(SubmitFormState.disabled),
      );
    }

    if (value.isPrivacyAgreed && value.isServiceAgreed) {
      return value.copy(
        name: Arg(event.value),
        nameMessage: const Arg(null),
        state: const Arg(SubmitFormState.enabled),
      );
    }

    return value.copy(name: Arg(event.value), nameMessage: const Arg(null));
  }

  Future<SignUpFormModel> _onEmailChanged(EmailChanged event) async {
    return value.copy(email: Arg(event.value), emailMessage: null);
  }

  Future<SignUpFormModel> _onServiceAgreementChanged(
      ServiceAgreementChanged event) async {
    if (event.value &&
        value.name.isNotEmpty &&
        value.name.length <= 12 &&
        value.isPrivacyAgreed) {
      return value.copy(
        isServiceAgreed: Arg(event.value),
        state: const Arg(SubmitFormState.enabled),
      );
    }

    if (!event.value) {
      return value.copy(
        isServiceAgreed: Arg(event.value),
        state: const Arg(SubmitFormState.disabled),
      );
    }

    return value.copy(isServiceAgreed: Arg(event.value));
  }

  Future<SignUpFormModel> _onPrivacyAgreementChanged(
      PrivacyAgreementChanged event) async {
    if (event.value &&
        value.name.isNotEmpty &&
        value.name.length <= 12 &&
        value.isServiceAgreed) {
      return value.copy(
        isPrivacyAgreed: Arg(event.value),
        state: const Arg(SubmitFormState.enabled),
      );
    }

    if (!event.value) {
      return value.copy(
        isPrivacyAgreed: Arg(event.value),
        state: const Arg(SubmitFormState.disabled),
      );
    }

    return value.copy(isPrivacyAgreed: Arg(event.value));
  }

  Future<SignUpFormModel> _onPending(Pending event) async {
    return value.copy(state: const Arg(SubmitFormState.pending));
  }
}
