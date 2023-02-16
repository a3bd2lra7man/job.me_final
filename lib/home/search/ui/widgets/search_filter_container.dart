import 'package:flutter/material.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';

class SearchFilterContainer extends StatelessWidget {
  final String title;
  final String subTitle;
  final VoidCallback onTap;
  const SearchFilterContainer({Key? key, required this.title, required this.subTitle, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 6),
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8)
        ),
        child: ListTile(
          onTap: onTap,
          title: Text(title,style: AppTextStyles.title,),
          subtitle: Text(subTitle,style: AppTextStyles.bodyNormal,),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.arrow_forward_ios,size: 16,),
            ],
          ),
        ),
      ),
    );
  }
}
