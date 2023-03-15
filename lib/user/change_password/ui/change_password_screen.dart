
import 'package:flutter/material.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/_shared/widgets/loading_widget.dart';
import 'package:job_me/_shared/widgets/primary_app_bar.dart';
import 'package:job_me/_shared/widgets/primary_button.dart';
import 'package:job_me/user/_shared/widgets/password_edit_text.dart';
import 'package:job_me/user/change_password/provider/change_password_proivder.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatelessWidget {
  static Widget init() {
    return ChangeNotifierProvider(
      create: (context) => ChangePasswordProvider(context),
      child: const ChangePasswordScreen._(),
    );
  }

  const ChangePasswordScreen._({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<ChangePasswordProvider>();
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PrimaryAppBar(
        title: context.translate('change_password'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 120,
                ),
                Text(
                  context.translate('new_password'),
                  style: AppTextStyles.bodyNormal.copyWith(color: AppColors.primary),
                ),
                const SizedBox(
                  height: 40,
                ),
                PasswordEditText(
                  hint: context.translate('old_password'),
                  passwordController: provider.oldPassword,
                  validator: provider.isPasswordValid,
                ),
                const SizedBox(height: 40),
                PasswordEditText(
                  hint: context.translate('new_password'),
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
                  PrimaryButton(onPressed: provider.sendNewPassword, title: context.translate('proceed')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
