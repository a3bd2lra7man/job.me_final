import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/_job_advertisement_core/models/job_advertisement.dart';
import 'package:job_me/home/home/providers/home_provider.dart';
import 'package:provider/provider.dart';

class SpecialAdJobCard extends StatelessWidget {
  final JobAdvertisement job;

  const SpecialAdJobCard({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        var provider = context.read<HomePageProvider>();
        provider.onJobCardClicked(job.id);
      },
      child: SizedBox(
        width: 300,
        child: Card(
          margin: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Row(
                children: [
                  const SizedBox(width: 20),
                  job.userImage != null
                      ? Image.network(
                          job.userImage!,
                          height: 64,
                          width: 72,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/images/img_2.png',
                    height: 64,
                    width: 72,
                        ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 2,
                    child: Text(
                      job.userName,
                      style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w400),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(thickness: 2,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  job.title,
                  style: AppTextStyles.headerSmall,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(width: 8),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/chair.svg',
                          height: 20,
                          width: 20,
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          height: 20,
                          width: 56,
                          child: Text(
                            job.workTime.toString() + context.translate('hours'),
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.smallStyle,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          height: 20,
                          width: 56,
                          child: Text(
                            job.jobCountry ?? "",
                            style: AppTextStyles.smallStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ),
                  // Expanded(
                  //   child: Row(
                  //     children: [
                  //       const Icon(
                  //         Icons.desk,
                  //         size: 20,
                  //       ),
                  //       const SizedBox(width: 2),
                  //       Expanded(
                  //           child: Text(
                  //         job.contractType,
                  //         style: AppTextStyles.bottomNavigation,
                  //       ))
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
