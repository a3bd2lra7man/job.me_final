import 'package:flutter/material.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/home/home/providers/home_provider.dart';
import 'package:provider/provider.dart';

class BasicHomeBottomNavigationBar extends StatelessWidget {
  final Color color;

  const BasicHomeBottomNavigationBar({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<HomePageProvider>();
    return ClipRRect(
      borderRadius: const BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
      child: BottomAppBar(
        elevation: 20,
        color: AppColors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 12,
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconNavBar(
                      title: context.translate('home'),
                      icon: Icons.home_filled,
                      color: provider.isPageSelectedPage(HomePages.main) ? color : AppColors.grey,
                      onIconClick: () => provider.changeSelectedPageTo(HomePages.main),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    IconNavBar(
                      title: context.translate('offers'),
                      icon: Icons.list_alt_rounded,
                      color: provider.isPageSelectedPage(HomePages.offers) ? color : AppColors.grey,
                      onIconClick: () => provider.changeSelectedPageTo(HomePages.offers),
                    ),
                  ],
                ),
              ),
              FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconNavBar(
                      title: context.translate('saved'),
                      icon: Icons.bookmark,
                      color: provider.isPageSelectedPage(HomePages.saved) ? color : AppColors.grey,
                      onIconClick: () => provider.changeSelectedPageTo(HomePages.saved),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    IconNavBar(
                      title: context.translate('account'),
                      icon: Icons.person,
                      color: provider.isPageSelectedPage(HomePages.account) ? color : AppColors.grey,
                      onIconClick: () => provider.changeSelectedPageTo(HomePages.account),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IconNavBar extends StatelessWidget {
  const IconNavBar({Key? key, required this.title, required this.icon, required this.color, required this.onIconClick})
      : super(key: key);
  final String? title;
  final IconData? icon;
  final Color? color;
  final Function()? onIconClick;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onIconClick,
      minWidth: 48,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 28,
            color: color,
          ),
          CustomTextView(
            text: title,
            textStyle: AppTextStyles.smallStyle.copyWith(color: color),
          )
        ],
      ),
    );
  }
}

class CustomTextView extends StatelessWidget {
  final String? text;
  final TextAlign? textAlign;
  final TextStyle? textStyle;
  final int? maxLine;
  final TextOverflow? textOverflow;
  final bool? isUpperCase;

  const CustomTextView(
      {Key? key, this.text, this.textAlign, this.textStyle, this.maxLine, this.textOverflow, this.isUpperCase = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      isUpperCase! ? text!.toUpperCase() : text ?? "",
      overflow: textOverflow,
      textAlign: textAlign,
      style: textStyle,
      softWrap: true,
      maxLines: maxLine,
    );
  }
}
