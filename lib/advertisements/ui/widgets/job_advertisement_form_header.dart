import 'package:flutter/material.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/advertisements/providers/advertisement_provider.dart';
import 'package:job_me/advertisements/ui/widgets/user_balance_loader.dart';
import 'package:provider/provider.dart';

class JobAdvertisementFormHeader extends StatelessWidget {
  const JobAdvertisementFormHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<AdvertisementOffersProvider>();
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Card(
        margin: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "${context.translate('hello')} ${provider.getUsersName()}",
                style: AppTextStyles.headerSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            provider.isLoading
                ? const UserBalanceLoader()
                : Container(
                    color: AppColors.whiteGrey,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            context.translate('current_credit'),
                            style: AppTextStyles.title.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const Spacer(),
                          Text(
                            "${provider.getUsersCredit()} ${provider.getUsersCredit() > 10 ? context.translate('coin') : context.translate('coins')}",
                            style: AppTextStyles.title.copyWith(color: Colors.green, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
