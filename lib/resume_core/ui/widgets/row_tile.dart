import 'package:flutter/cupertino.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';

class RowTile extends StatelessWidget {
  final String title;

  final String subTitle;
  final TextStyle? textStyle;

  const RowTile({Key? key, required this.title, required this.subTitle, this.textStyle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.bodyMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Expanded(
          child: Text(
            subTitle,
            style: textStyle ?? AppTextStyles.hint.copyWith(color: AppColors.darkGrey),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
