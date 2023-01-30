// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:job_me/_shared/widgets/shimmer_page.dart';
import 'package:job_me/resume_core/ui/widgets/resume_container_loader.dart';

class CompanyInfoScreenLoader extends StatelessWidget {
  const CompanyInfoScreenLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
        child: ListView(
      padding: const EdgeInsets.only(top: 20),
      children: List.generate(
        2,
        (index) => const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: ResumeContainerLoader(
            height: 240,
          ),
        ),
      ),
    ));
  }
}
