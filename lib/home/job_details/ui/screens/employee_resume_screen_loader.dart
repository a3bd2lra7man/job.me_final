import 'package:flutter/material.dart';
import 'package:job_me/_shared/widgets/shimmer_page.dart';
import 'package:job_me/home/job_details/ui/widgets/header_loader.dart';
import 'package:job_me/resume_core/ui/widgets/resume_container_loader.dart';

class EmployeeResumeScreenLoader extends StatelessWidget {
  const EmployeeResumeScreenLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: ListView(
        children: [
          const SizedBox(
            height: 40,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: HeaderLoader(),
          ),
          const SizedBox(height: 8),
          Row(
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Card(
                  child: SizedBox(
                    height: 20,
                    width: 80,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Card(
                  child: SizedBox(
                    height: 20,
                    width: 80,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Card(
                  child: SizedBox(
                    height: 20,
                    width: 80,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Card(
                  child: SizedBox(
                    height: 20,
                    width: 80,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...List.generate(
              5,
              (index) => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: ResumeContainerLoader(),
                  ))
        ],
      ),
    );
  }
}
