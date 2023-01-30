import 'package:flutter/material.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/home/home/providers/home_provider.dart';
import 'package:job_me/home/notifications/ui/widgets/notifications_icon.dart';
import 'package:provider/provider.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomePageProvider provider = context.watch<HomePageProvider>();
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.primary.withOpacity(.4), width: 2))),
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: const ContinuousRectangleBorder(),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  provider.isUserLoggedIn()
                      ? Expanded(
                          flex: 6,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "${context.translate('hello')} ${provider.getUserName()}",
                              style: AppTextStyles.titleBold.copyWith(color: AppColors.black),
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: provider.onGuestClickOnGoToLogin,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              context.translate('go_to_login'),
                              style: AppTextStyles.titleBold.copyWith(color: AppColors.primary),
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                  if (provider.isUserLoggedIn()) Expanded(child: NotificationsIcon.init())
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size(double.maxFinite, 104);
}
