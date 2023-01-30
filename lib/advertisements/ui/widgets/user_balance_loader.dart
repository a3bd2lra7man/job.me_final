import 'package:flutter/material.dart';
import 'package:job_me/_shared/widgets/shimmer_page.dart';

class UserBalanceLoader extends StatelessWidget {

  const UserBalanceLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ShimmerEffect(
      child: SizedBox(
        height: 52,
        width: double.maxFinite,
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          shape: ContinuousRectangleBorder(),
        ),
      ),
    );
  }
}
