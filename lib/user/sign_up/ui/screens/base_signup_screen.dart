import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/_shared/widgets/loading_widget.dart';
import 'package:job_me/_shared/widgets/primary_button.dart';
import 'package:job_me/_shared/widgets/primary_edit_text.dart';
import 'package:job_me/_shared/widgets/snack_bar.dart';
import 'package:job_me/user/_shared/widgets/password_edit_text.dart';
import 'package:job_me/user/sign_up/providers/signup_provider.dart';
import 'package:job_me/terms_and_conditions_and_privacy/ui/screens/terms_and_conditions.dart';
import 'package:provider/provider.dart';

class BaseSignUpScreen extends StatefulWidget {
  final Color color;
  final SignUpProvider provider;
  final VoidCallback onRegister;

  const BaseSignUpScreen({
    Key? key,
    required this.color,
    required this.provider,
    required this.onRegister,
  }) : super(key: key);

  @override
  State<BaseSignUpScreen> createState() => _BaseSignUpScreenState();
}

class _BaseSignUpScreenState extends State<BaseSignUpScreen> {
  bool isTermsAndConditionsConfirmed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: widget.color,
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
                context.translate('create_your_account_with_ease'),
                style: AppTextStyles.headerSemiBold,
              ),
            ),
            const SizedBox(height: 40),
            Container(
              width: context.width,
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    const SizedBox(height: 80),
                    PrimaryEditText(
                      controller: widget.provider.nameController,
                      hint: context.translate('user_name'),
                      validator: widget.provider.isNameValid,
                    ),
                    const SizedBox(height: 40),
                    PrimaryEditText(
                      controller: widget.provider.fullNameController,
                      hint: context.translate('full_name'),
                      validator: widget.provider.isNameValid,
                    ),
                    const SizedBox(height: 40),
                    PrimaryEditText(
                      inputType: TextInputType.emailAddress,
                      controller: widget.provider.emailController,
                      hint: context.translate('email'),
                      validator: widget.provider.isValidEmail,
                    ),
                    const SizedBox(height: 40),
                    PasswordEditText(
                      hint: context.translate('password'),
                      passwordController: widget.provider.passwordController,
                      validator: widget.provider.isPasswordValid,
                    ),
                    const SizedBox(height: 40),
                    PasswordEditText(
                      hint: context.translate('password_confirmation'),
                      passwordController: widget.provider.passwordConfirmationController,
                      validator: widget.provider.isPasswordValid,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: isTermsAndConditionsConfirmed,
                          onChanged: (_) {
                            setState(() {
                              isTermsAndConditionsConfirmed = !isTermsAndConditionsConfirmed;
                            });
                          },
                          fillColor: MaterialStateColor.resolveWith((states) => AppColors.grey),
                        ),
                        GestureDetector(
                          onTap: () => Get.to(() => const TermsAndConditionScreen()),
                          child: Row(
                            children: [
                              Text(
                                context.translate('agree_to'),
                                style: AppTextStyles.bodyNormal,
                              ),
                              Text(context.translate('terms_and_conditions'),
                                  style: AppTextStyles.bodyNormal.copyWith(color: widget.color)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    if (context.watch<SignUpProvider>().isLoading)
                      const LoadingWidget()
                    else
                      PrimaryButton(
                          color: widget.color,
                          onPressed: () {
                            if (isTermsAndConditionsConfirmed) {
                              widget.onRegister();
                            } else {
                              showSnackBar(body: context.translate('please_confirm_terms_and_condition'));
                            }
                          },
                          title: context.translate('register')),
                    const SizedBox(height: 16),
                    const SizedBox(
                      height: 180,
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
