import 'package:flutter/material.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/home/account/providers/account_proivder.dart';
import 'package:job_me/home/home/providers/home_provider.dart';
import 'package:job_me/resume_employee/personal_info/ui/widgets/personal_image_container.dart';
import 'package:provider/provider.dart';

class AccountHeader extends StatelessWidget {
  const AccountHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider= context.watch<AccountProvider>();
    var homeProvider = context.watch<HomePageProvider>();
    return Container(
      height: 350,
      color: AppColors.primary,
      child: SafeArea(
        child: Column(
          children: [
            Text(
              context.translate('account'),
              style: AppTextStyles.titleBold.copyWith(color: AppColors.white),
            ),
            const SizedBox(height: 20),
            ImageContainer(
              imageUrl: provider.getUserImage(),
              height: 120,
              width: 120,
            ),
            const SizedBox(height: 16),
            Text(
              homeProvider.getUserName(),
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white, fontWeight: FontWeight.bold, height: 1),
            ),
            Text(
              homeProvider.getUserName(),
              style: AppTextStyles.hint.copyWith(color: AppColors.white),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              color: AppColors.primaryDark.withOpacity(.2),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      homeProvider.getUserEmail(),
                      style: AppTextStyles.hint.copyWith(color: AppColors.white),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    child: VerticalDivider(
                      color: AppColors.white,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${context.translate('credit')} ${provider.userBalance} ${context.translate('coins')}',
                      style: AppTextStyles.hint.copyWith(color: AppColors.white),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
