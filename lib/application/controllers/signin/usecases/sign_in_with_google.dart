import 'package:album/application/controller.dart';
import 'package:album/application/controllers/signin/controller.dart';
import 'package:album/application/controllers/signin/events/google_sign_in_requested.dart';
import 'package:album/application/controllers/signup/controller.dart';
import 'package:album/application/events/user_found.dart';
import 'package:album/application/models/user.dart';
import 'package:album/core/event/event.dart';
import 'package:album/core/usecase/usecase.dart';
import 'package:album/infrastructure/client/client.dart';
import 'package:album/infrastructure/client/response.dart';
import 'package:album/infrastructure/repositories/auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInWithGoogleUseCase extends UseCase {
  @override
  void onAwaken() {
    of<SignIn>().on<GoogleSignInRequested>((event) async {
      final account = await _getAccount();

      if (account == null) {
        return;
      }

      final authentication = await account.authentication;

      final idToken = authentication.idToken;

      if (idToken == null) {
        return;
      }

      final response =
          await use<Client>().post("auth/signin?provider=google", body: {
        "id_token": idToken,
      });

      if (response is FailureResponse) {
        if (response.code == 2) {
          of<SignIn>().dispatch(Replaced("/signup",
              arguments: SignUpArguments(
                provider: "google",
                idToken: idToken,
                name: account.displayName,
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

  Future<GoogleSignInAccount?> _getAccount() async {
    try {
      final result = await GoogleSignIn(scopes: [
        "email",
      ]).signIn();

      return result;
    } catch (e) {
      return null;
    }
  }
}
