import 'package:album/application/controller.dart';
import 'package:album/application/controllers/signin/controller.dart';
import 'package:album/application/controllers/signin/events/apple_sign_in_requested.dart';
import 'package:album/application/controllers/signup/controller.dart';
import 'package:album/application/events/user_found.dart';
import 'package:album/application/models/user.dart';
import 'package:album/core/event/event.dart';
import 'package:album/core/usecase/usecase.dart';
import 'package:album/infrastructure/client/client.dart';
import 'package:album/infrastructure/client/response.dart';
import 'package:album/infrastructure/repositories/auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SignInWithAppleUseCase extends UseCase {
  @override
  void onAwaken() {
    of<SignIn>().on<AppleSignInRequested>((event) async {
      final account = await _getAccount();

      if (account == null) {
        return;
      }

      final idToken = account.identityToken;

      if (idToken == null) {
        return;
      }

      final response =
          await use<Client>().post("auth/signin?provider=apple", body: {
        "id_token": idToken,
      });

      if (response is FailureResponse) {
        if (response.code == 2) {
          of<SignIn>().dispatch(Replaced("/signup",
              arguments: SignUpArguments(
                provider: "apple",
                idToken: idToken,
                name: account.givenName,
                email: account.email,
              )));
        }

        return;
      }

      if (response is! SuccessResponse) {
        return;
      }

      final accessToken = response.body["access_token"];

      final refreshToken = response.body["refresh_token"];

      await use<AuthRepository>().saveAccessToken(accessToken);

      await use<AuthRepository>().saveRefreshToken(refreshToken);

      await _fetchUser(accessToken);

      of<SignIn>().dispatch(const Popped());
    });
  }

  Future<void> _fetchUser(String accessToken) async {
    final response = await use<Client>().get("user/me", headers: {
      "Authorization": "Bearer $accessToken",
    });

    if (response is! SuccessResponse) {
      return;
    }

    final user = UserModel.fromJson(response.body);

    of<App>().dispatch(UserFound(body: user));
  }

  Future<AuthorizationCredentialAppleID?> _getAccount() async {
    try {
      final result = await SignInWithApple.getAppleIDCredential(scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ]);

      return result;
    } catch (e) {
      return null;
    }
  }
}
