import 'package:flutter/material.dart';
import 'package:job_me/_shared/widgets/shimmer_page.dart';

class SpecialJobsLoader extends StatelessWidget {
  const SpecialJobsLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: SizedBox(
        height: 220,
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, index) => SizedBox(
            width: 300,
            child: Card(
              margin: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Row(
                    children: const [
                      Expanded(
                        child: SizedBox(
                          height: 40,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: SizedBox(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  const Center(child: SizedBox()),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(width: 8),
                      Expanded(
                        child: Row(
                          children: const [
                            SizedBox(
                              height: 20,
                              width: 20,
                            ),
                            SizedBox(width: 2),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: const [
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(width: 2),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: const [
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(width: 2),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
            ),
          ),
          itemCount: 12,
        ),
      ),
    );
  }
}
