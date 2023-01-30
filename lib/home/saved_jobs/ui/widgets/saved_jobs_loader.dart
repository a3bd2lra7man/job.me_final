import 'package:flutter/material.dart';
import 'package:job_me/_shared/widgets/shimmer_page.dart';
import 'package:job_me/_shared/widgets/card_loader.dart';

class SavedJobsPageLoader extends StatelessWidget {
  const SavedJobsPageLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16 ),
        children: List.generate(
          16,
              (index) => const CardLoader(height: 120,),
        ),
      ),
    );
  }
}
