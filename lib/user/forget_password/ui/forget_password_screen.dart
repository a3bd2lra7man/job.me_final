import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/_shared/widgets/loading_widget.dart';
import 'package:job_me/_shared/widgets/primary_button.dart';
import 'package:job_me/_shared/widgets/primary_edit_text.dart';
import 'package:job_me/user/_shared/widgets/password_edit_text.dart';
import 'package:job_me/user/forget_password/provider/forget_password_proivder.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class ForgetPasswordScreen extends StatelessWidget {
  static Widget init(Color color) {
    return ChangeNotifierProvider(
      create: (context) => ForgetPasswordProvider(context),
      child: ForgetPasswordScreen._(color: color),
    );
  }

  final Color color;

  const ForgetPasswordScreen._({
    Key? key,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<ForgetPasswordProvider>();
    return Scaffold(
      body: Container(
        color: color,
        child: ListView(
          children: [
            const SizedBox(height: 60),
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
                context.translate('password_recovery'),
                style: AppTextStyles.headerSemiBold,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: context.height,
              width: context.width,
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 120,
                    ),
                    if (!provider.isEmailFound) ...<Widget>[
                      Text(
                        context.translate('enter_email_associated_with_account'),
                        style: AppTextStyles.bodyNormal.copyWith(color: color),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      PrimaryEditText(
                        controller: provider.emailController,
                        validator: provider.isValidEmail,
                        hint: context.translate('email'),
                      ),
                      const SizedBox(height: 80),
                      if (provider.isLoading)
                        const Center(child: LoadingWidget())
                      else
                        PrimaryButton(
                            color: color, onPressed: provider.checkEmail, title: context.translate('proceed')),
                    ],
                    if (provider.isEmailFound && provider.codeNotCheckedYet) ...<Widget>[
                      Text(
                        context.translate('code_sent_to_you'),
                        style: AppTextStyles.bodyNormal.copyWith(color: color),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: PinCodeTextField(
                          length: 6,
                          appContext: context,
                          obscureText: false,
                          showCursor: true,
                          keyboardType: TextInputType.number,
                          animationType: AnimationType.fade,
                          validator: (val) => val == null || val.isEmpty ? 'Enter otp here' : null,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            fieldHeight: 63,
                            fieldWidth: 55,
                            borderWidth: 1,
                            borderRadius: BorderRadius.circular(10),
                            selectedColor: color,
                            selectedFillColor: Colors.transparent,
                            inactiveFillColor: Colors.transparent,
                            inactiveColor: AppColors.grey,
                            activeColor: color,
                            activeFillColor: Colors.white,
                          ),
                          animationDuration: const Duration(milliseconds: 300),
                          backgroundColor: Colors.transparent,
                          enableActiveFill: true,
                          onChanged: provider.onCodeChange,
                          beforeTextPaste: (text) {
                            return true;
                          },
                        ),
                      ),
                      const SizedBox(height: 40),
                      if (provider.isLoading)
                        const Center(child: LoadingWidget())
                      else
                        PrimaryButton(color: color, onPressed: provider.checkCode, title: context.translate('proceed')),
                    ],

                    if (provider.isCodeChecked) ...<Widget>[
                      Text(
                        context.translate('new_password'),
                        style: AppTextStyles.bodyNormal.copyWith(color: color),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      PasswordEditText(
                        hint: context.translate('password'),
                        passwordController: provider.passwordController,
                        validator: provider.isPasswordValid,
                      ),
                      const SizedBox(height: 40),
                      PasswordEditText(
                        hint: context.translate('password_confirmation'),
                        passwordController: provider.passwordConfirmationController,
                        validator: provider.isPasswordValid,
                      ),
                      const SizedBox(height: 40),
                      if (provider.isLoading)
                        const Center(child: LoadingWidget())
                      else
                        PrimaryButton(color: color, onPressed: provider.sendNewPassword, title: context.translate('proceed')),
                    ],

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
