import 'package:flutter/material.dart';
import 'package:job_me/_shared/widgets/shimmer_page.dart';
import 'package:job_me/_shared/widgets/card_loader.dart';

class NotificationsLoader extends StatelessWidget {
  const NotificationsLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: List.generate(
          16,
          (index) => const CardLoader(),
        ),
      ),
    );
  }
}
