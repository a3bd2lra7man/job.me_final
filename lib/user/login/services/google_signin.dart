import 'package:google_sign_in/google_sign_in.dart';
import 'package:job_me/_shared/exceptions/unknown_exception.dart';
import 'package:job_me/user/_user_core/models/roles.dart';
import 'package:job_me/user/login/models/social_login.dart';

class GoogleAppSignIn {

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  Future<SocialLoginModel> googleSignIn(Roles role) async {
    try {
      await _googleSignIn.signOut();
      GoogleSignInAccount? signInAccount = await _googleSignIn.signIn();
      if (signInAccount != null) {
        return SocialLoginModel(
          socialType: SocialLoginType.google,
          email: signInAccount.email,
          socialId: signInAccount.id,
          photo: signInAccount.photoUrl ?? 'https://www.jobme.me/assets/images/unknown_person.png',
          fullName: signInAccount.displayName ?? "User",
          role: role,
        );
      } else {
        throw UnknownException();
      }
    } catch (e) {
      throw UnknownException();
    }
  }
}
