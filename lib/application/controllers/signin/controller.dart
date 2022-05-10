import 'package:album/application/controllers/signin/events/apple_sign_in_requested.dart';
import 'package:album/application/controllers/signin/events/google_sign_in_requested.dart';
import 'package:album/application/controllers/signin/usecases/sign_in_with_apple.dart';
import 'package:album/application/controllers/signin/usecases/sign_in_with_google.dart';
import 'package:album/core/controller/arguments.dart';
import 'package:album/core/controller/controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

class SignIn extends Controller {
  SignIn({Key? key})
      : super(
          const Arguments(),
          key: key,
          usecases: [
            SignInWithAppleUseCase(),
            SignInWithGoogleUseCase(),
          ],
        );

  @override
  Widget render(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBackground,
        border: Border(),
        transitionBetweenRoutes: false,
      ),
      child: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 3),
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "로그인하고 🤟\n",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 32.0,
                      ),
                    ),
                    TextSpan(
                      text: "소중한 추억",
                      style: TextStyle(
                        color: CupertinoColors.activeBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 32.0,
                      ),
                    ),
                    TextSpan(
                      text: "을\n",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 32.0,
                      ),
                    ),
                    TextSpan(
                      text: "소중한 사람",
                      style: TextStyle(
                        color: CupertinoColors.activeBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 32.0,
                      ),
                    ),
                    TextSpan(
                      text: "과 함께\n",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 32.0,
                      ),
                    ),
                    TextSpan(
                      text: "저장해 보세요.",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 32.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48.0),
              Center(
                child: SignInButton(
                  Buttons.AppleDark,
                  onPressed: () =>
                      to<SignIn>().dispatch(const AppleSignInRequested()),
                  text: "Apple로 로그인",
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Center(
                child: SignInButton(
                  Buttons.GoogleDark,
                  onPressed: () =>
                      to<SignIn>().dispatch(const GoogleSignInRequested()),
                  text: "Google로 로그인",
                ),
              ),
              const Spacer(flex: 5)
            ],
          ),
        ),
      ),
    );
  }
}
