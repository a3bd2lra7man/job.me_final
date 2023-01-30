import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/exceptions/unknown_exception.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/_shared/widgets/primary_button.dart';
import 'package:job_me/user/_user_core/models/roles.dart';
import 'package:job_me/user/login/models/social_login.dart';
import 'package:job_me/user/login/exceptions/apple_email_is_missing.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AppleSignIn {

  Future<SocialLoginModel?> login(BuildContext context, Roles role) async {

    var isToShare = await showShareEmailWithUs(context);
    if (!isToShare) return null;
    FirebaseAuth.instance.signOut();

    try {
      await FirebaseAuth.instance.signOut();
    } catch (_) {}

    try {
      final appleProvider = AppleAuthProvider()..addScope('email')..addScope('name');
      var user = (await FirebaseAuth.instance.signInWithProvider(appleProvider)).user;
      if (user == null || user.email == null || user.email!.isEmpty) throw AppleEmailIsMissing();

      SocialLoginModel socialLoginModel = SocialLoginModel(
          email: user.email!,
          socialType: SocialLoginType.apple,
          socialId: user.uid,
          photo: user.photoURL ?? "https://www.jobme.me/assets/images/unknown_person.png",
          fullName: user.displayName ?? user.uid,
          role: role);
      return socialLoginModel;
    } catch (e) {
      throw UnknownException();
    }
  }
}

Future showShareEmailWithUs(BuildContext context) async {
  return await Get.bottomSheet(Container(
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 40,
          ),
          Text(
            context.translate('apple_email_is_missing'),
            style: AppTextStyles.title,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            context.translate('agreed'),
            style: AppTextStyles.headerBig,
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            children: [
              const Expanded(child: SizedBox()),
              Expanded(
                child: PrimaryButton(
                  onPressed: () async {
                    Get.back(result: true);
                  },
                  title: context.translate('yes'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: PrimaryButton(
                  color: AppColors.white,
                  titleColor: AppColors.primary,
                  onPressed: () {
                    Get.back(result: false);
                  },
                  title: context.translate('no'),
                ),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
          const SizedBox(
            height: 80,
          ),
        ],
      ),
    ),
  ));
}
