import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/_shared/widgets/loading_widget.dart';
import 'package:job_me/_shared/widgets/primary_button.dart';
import 'package:job_me/_shared/widgets/primary_edit_text.dart';
import 'package:job_me/user/_shared/widgets/password_edit_text.dart';
import 'package:job_me/user/_user_core/models/roles.dart';
import 'package:job_me/user/login/providers/login_provider.dart';
import 'package:job_me/user/forget_password/ui/forget_password_screen.dart';

class BaseLoginScreen extends StatelessWidget {
  final Color color;
  final Roles role;
  final LoginProvider provider;
  final VoidCallback onLoginClicked;
  final VoidCallback onCreateNewAccountClicked;
  final VoidCallback onContinueAsGuest;

  const BaseLoginScreen(
      {Key? key,
      required this.color,
      required this.provider,
      required this.onLoginClicked,
      required this.onCreateNewAccountClicked,
      required this.role,
      required this.onContinueAsGuest})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: color,
        child: ListView(
          children: [
            const SizedBox(height: 120),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                context.translate('welcome_back'),
                style: AppTextStyles.headerHuge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                context.translate('please_enter_your_credentials'),
                style: AppTextStyles.headerSemiBold,
              ),
            ),
            const SizedBox(height: 80),
            Container(
              height: context.height,
              width: context.width,
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    const SizedBox(height: 120),
                    PrimaryEditText(
                      controller: provider.nameController,
                      validator: provider.isNameValid,
                      hint: context.translate('user_name'),
                    ),
                    const SizedBox(height: 40),
                    PasswordEditText(
                      passwordController: provider.passwordController,
                      validator: provider.isPasswordValid,
                      hint: context.translate('password'),
                    ),
                    const SizedBox(height: 80),
                    if (provider.isNormalLoginLoading)
                      const LoadingWidget()
                    else
                      PrimaryButton(color: color, onPressed: onLoginClicked, title: context.translate('login')),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: onCreateNewAccountClicked,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            context.translate('I_do_not_have_an_account'),
                            style: AppTextStyles.bodyNormal,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            context.translate('create_new_account'),
                            style: AppTextStyles.bodyNormal.copyWith(color: Colors.yellow[700]),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        Get.to(ForgetPasswordScreen.init(color));
                      },
                      child: Text(
                        context.translate('forget_password'),
                        style: AppTextStyles.bodyNormal.copyWith(color: color),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: onContinueAsGuest,
                      child: Text(
                        context.translate('continue_as_guest'),
                        style: AppTextStyles.bodyNormal.copyWith(color: color),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        provider.isGoogleLoginLoading
                            ? const LoadingWidget()
                            : Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: InkWell(
                                  onTap: () => provider.googleSocialLogin(role),
                                  child: Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Card(
                                      // color: Color(0xFF397AF3),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                            height: 30, width: 30, child: Image.asset("assets/images/google.png")),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        provider.isFacebookLoginLoading
                            ? const LoadingWidget()
                            : Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: InkWell(
                                  onTap: () => provider.facebookSocialLogin(role),
                                  child: Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                            height: 30, width: 30, child: Image.asset("assets/images/facebook.png")),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        if (Platform.isIOS)
                          provider.isAppleLoginLoading
                              ? const LoadingWidget()
                              : Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: InkWell(
                                    onTap: () => provider.appleSocialLogin(role),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6),
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                              height: 30, width: 30, child: Image.asset("assets/images/apple.png")),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
