import 'package:flutter/material.dart';
import 'package:job_me/_shared/widgets/shimmer_page.dart';

class HeaderLoader extends StatelessWidget {
  const HeaderLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: Card(
        child: Column(
          children: [
            Stack(
              children: [
                const Positioned(
                  bottom: 10,
                  right: 0,
                  left: 0,
                  child: SizedBox(
                    child: Divider(
                      color: Colors.black,
                      height: 2,
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 56,
                    ),
                    const SizedBox(
                      height: 40,
                      width: 80,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: const [
                SizedBox(
                  width: 56,
                ),
                Expanded(
                  child: TitleWithIconLoader(),
                ),
                Expanded(
                  child: TitleWithIconLoader(),
                ),
              ],
            ),
            Row(
              children: const [
                SizedBox(
                  width: 56,
                ),
                Expanded(
                  child: TitleWithIconLoader(),
                ),
                Expanded(
                  child: TitleWithIconLoader(),
                ),
              ],
            ),
            // Row(
            //   children: [
            //     const SizedBox(
            //       width: 56,
            //     ),
            //     Expanded(
            //               child: TitleWithIcon(
            //                 title: job.jobCountry ?? "",
            //                 icon: SvgPicture.asset(
            //                   'assets/images/job_country.svg',
            //                   height: 20,
            //                   width: 20,
            //                   color: Colors.grey[600],
            //                 ),
            //               ),
            //             ),
            //     Expanded(
            //       child: TitleWithIcon(
            //         title: job.all,
            //         icon: Icon(
            //           Icons.attachment,
            //           color: Colors.grey[600],
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}

class TitleWithIconLoader extends StatelessWidget {
  const TitleWithIconLoader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        SizedBox(
          width: 20,
          height: 20,
        ),
        SizedBox(width: 8),
        SizedBox(
          width: 20,
          height: 20,
        ),
      ],
    );
  }
}
