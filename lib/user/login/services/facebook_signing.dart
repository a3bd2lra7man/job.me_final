import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:job_me/_shared/exceptions/unknown_exception.dart';
import 'package:job_me/user/_user_core/models/roles.dart';
import 'package:job_me/user/login/models/social_login.dart';

class FacebookSignIn {
  FacebookSignIn();

  Future<SocialLoginModel> facebookLogin(Roles role) async {
    try {
      await FacebookAuth.instance.logOut();
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email'],
      );
      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.instance.getUserData();
        return SocialLoginModel(
          socialType: SocialLoginType.facebook,
          email: userData['email'],
          socialId: userData['id'],
          photo: userData['picture']['data']['url'] ?? 'https://www.jobme.me/assets/images/unknown_person.png',
          fullName: userData['name'],
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

// face book response
///{
///  "name": "Open Graph Test User",
///  "email": "open_jygexjs_user@tfbnw.net",
///  "picture": {
///    "data": {
///      "height": 126,
///      "url": "https://scontent.fuio21-1.fna.fbcdn.net/v/t1.30497-1/s200x200/8462.jpg",
///      "width": 200
///    }
///  },
///  "id": "136742241592917"
/// }
