import 'package:flutter/material.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';

class PrimaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double? elevation;
  final Color? titleColor;
  final List<Widget>? actions;

  const PrimaryAppBar({Key? key, required this.title, this.elevation, this.titleColor,  this.actions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: elevation,
      backgroundColor: Colors.white,
      leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: Icon(
            Icons.arrow_back_ios,
            color: titleColor ?? AppColors.darkGrey,
          )),
      centerTitle: true,
      title: Text(
        title,
        style: AppTextStyles.titleBold.copyWith(color: titleColor ?? AppColors.darkGrey),
      ),
      actions: actions,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size(double.maxFinite, 56);
}
