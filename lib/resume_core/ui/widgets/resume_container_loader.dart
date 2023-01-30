import 'package:flutter/material.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/widgets/shimmer_page.dart';

class ResumeContainerLoader extends StatelessWidget {

  final double height;

  const ResumeContainerLoader(
      {Key? key,  this.height = 200,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Card(
          child: Container(
            height: height,
            width: double.maxFinite,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(8)),

          ),
        ),
      ),
    );
  }
}
