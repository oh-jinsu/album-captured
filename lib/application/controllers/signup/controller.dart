import 'package:album/application/controllers/signup/usecases/submit.dart';
import 'package:album/application/controllers/signup/events/avatar_edit_tapped.dart';
import 'package:album/application/controllers/signup/events/email_changed.dart';
import 'package:album/application/controllers/signup/events/name_changed.dart';
import 'package:album/application/controllers/signup/events/privacy_agreement_changed.dart';
import 'package:album/application/controllers/signup/events/service_agreement_changed.dart';
import 'package:album/application/controllers/signup/events/submitted.dart';
import 'package:album/application/controllers/signup/stores/form.dart';
import 'package:album/application/controllers/signup/usecases/pick_avatar.dart';
import 'package:album/application/controllers/signup/widgets/avatar.dart';
import 'package:album/application/controllers/signup/widgets/container.dart';
import 'package:album/application/controllers/signup/widgets/radio_box.dart';
import 'package:album/application/widgets/button.dart';
import 'package:album/core/common/state.dart';
import 'package:album/core/controller/arguments.dart';
import 'package:album/core/controller/controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpArguments extends Arguments {
  final String provider;
  final String idToken;
  final String? name;
  final String? email;

  const SignUpArguments({
    required this.provider,
    required this.idToken,
    this.name,
    this.email,
  });
}

class SignUp extends Controller<SignUpArguments> {
  final _initialFocusNode = FocusNode();

  SignUp(SignUpArguments arguments, {Key? key})
      : super(
          arguments,
          key: key,
          stores: [
            SignUpFormStore(),
          ],
          usecases: [
            PickAvatarUseCase(),
            SubmitUseCase(),
          ],
        );

  @override
  void onStarted(BuildContext context) {
    if (arguments.name != null) {
      to<SignUp>().dispatch(NameChanged(value: arguments.name!));
    } else {
      _initialFocusNode.requestFocus();
    }

    if (arguments.email != null) {
      to<SignUp>().dispatch(EmailChanged(value: arguments.email!));
    }

    super.onStarted(context);
  }

  @override
  void onDestroyed(BuildContext context) {
    super.onDestroyed(context);

    _initialFocusNode.dispose();
  }

  @override
  Widget render(BuildContext context) {
    return get<SignUpFormStore>().subscribe(
      onNext: (data) => CupertinoPageScaffold(
        backgroundColor: CupertinoColors.systemGroupedBackground,
        navigationBar: const CupertinoNavigationBar(
          middle: Text("회원가입"),
          backgroundColor: CupertinoColors.systemGroupedBackground,
          border: Border(),
          transitionBetweenRoutes: false,
        ),
        child: SignUpContainer(
          bottom: CupertinoButton(
            color: data.state == SubmitFormState.enabled
                ? CupertinoColors.activeBlue
                : CupertinoColors.quaternarySystemFill,
            child: SizedBox(
              width: double.infinity,
              child: Center(
                child: data.state == SubmitFormState.pending
                    ? const CupertinoActivityIndicator(
                        color: CupertinoColors.white,
                      )
                    : Text(
                        "확인",
                        style: TextStyle(
                          color: data.state == SubmitFormState.enabled
                              ? CupertinoColors.white
                              : CupertinoColors.inactiveGray,
                        ),
                      ),
              ),
            ),
            onPressed: () {
              if (data.state != SubmitFormState.enabled) {
                return;
              }

              to<SignUp>().dispatch(
                Submitted(
                  provider: arguments.provider,
                  idToken: arguments.idToken,
                  avatar: data.avatar,
                  name: data.name,
                  email: data.email.isNotEmpty ? data.email : null,
                ),
              );
            },
          ),
          children: [
            const SizedBox(height: 24.0),
            SignUpAvatar(
              image: data.avatar,
              onTap: () => to<SignUp>().dispatch(
                const AvatarEditTapped(),
              ),
            ),
            const SizedBox(height: 8.0),
            CupertinoFormSection(
              header: const Text("필수"),
              footer: data.nameMessage != null
                  ? Text(
                      data.nameMessage!,
                      style: const TextStyle(
                        color: CupertinoColors.destructiveRed,
                      ),
                    )
                  : null,
              margin:
                  EdgeInsets.only(bottom: data.nameMessage != null ? 8.0 : 0.0),
              children: [
                CupertinoTextFormFieldRow(
                  focusNode: _initialFocusNode,
                  prefix: const Icon(
                    CupertinoIcons.person_alt,
                    color: CupertinoColors.systemGrey5,
                  ),
                  initialValue: arguments.name,
                  placeholder: "이름",
                  keyboardType: TextInputType.text,
                  onChanged: (text) =>
                      to<SignUp>().dispatch(NameChanged(value: text)),
                ),
              ],
            ),
            CupertinoFormSection(
              header: const Text("선택"),
              children: [
                CupertinoTextFormFieldRow(
                  prefix: const Icon(
                    CupertinoIcons.mail_solid,
                    color: CupertinoColors.systemGrey5,
                  ),
                  initialValue: arguments.email,
                  keyboardType: TextInputType.emailAddress,
                  placeholder: "이메일",
                  onChanged: (text) =>
                      to<SignUp>().dispatch(EmailChanged(value: text)),
                ),
              ],
            ),
            CupertinoFormSection(
              header: const Text("동의"),
              children: [
                CupertinoFormRow(
                  padding: const EdgeInsets.only(right: 12.0),
                  prefix: GestureDetector(
                    onTap: () => to<SignUp>().dispatch(
                        ServiceAgreementChanged(value: !data.isServiceAgreed)),
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 20.0,
                      ),
                      child: Row(
                        children: [
                          AppRadioBox(enabled: data.isServiceAgreed),
                          const SizedBox(width: 8.0),
                          const Text(
                            "서비스이용약관",
                            style: TextStyle(height: 1.3),
                          ),
                        ],
                      ),
                    ),
                  ),
                  child: AppButton(
                    onPressed: () {},
                    child: const Icon(
                      CupertinoIcons.chevron_forward,
                      size: 20.0,
                      color: CupertinoColors.systemGrey3,
                    ),
                  ),
                ),
                CupertinoFormRow(
                  padding: const EdgeInsets.only(right: 12.0),
                  prefix: GestureDetector(
                    onTap: () => to<SignUp>().dispatch(
                      PrivacyAgreementChanged(value: !data.isPrivacyAgreed),
                    ),
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 20.0,
                      ),
                      child: Row(
                        children: [
                          AppRadioBox(enabled: data.isPrivacyAgreed),
                          const SizedBox(width: 8.0),
                          const Text(
                            "개인정보처리방침",
                            style: TextStyle(height: 1.3),
                          ),
                        ],
                      ),
                    ),
                  ),
                  child: AppButton(
                    onPressed: () {},
                    child: const Icon(
                      CupertinoIcons.chevron_forward,
                      size: 20.0,
                      color: CupertinoColors.systemGrey3,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
