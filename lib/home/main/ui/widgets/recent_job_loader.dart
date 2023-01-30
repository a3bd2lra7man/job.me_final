import 'package:flutter/material.dart';
import 'package:job_me/_shared/widgets/shimmer_page.dart';
import 'package:job_me/_shared/widgets/card_loader.dart';

class RecentJobLoader extends StatelessWidget {
  const RecentJobLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: ListView(
        shrinkWrap: true,
        children: List.generate(
          16,
          (index) => const CardLoader(),
        ),
      ),
    );
  }
}
