import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/home/job_details/models/job_ads_details.dart';
import 'package:job_me/resume_core/models/resume.dart';

class EmployeeInfoHeader extends StatelessWidget {
  final Resume resume;
  final JobAdsDetails job;

  const EmployeeInfoHeader({Key? key, required this.resume, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  width: 32,
                ),
                resume.userInfo.image != null
                    ? CachedNetworkImage(
                        imageUrl: resume.userInfo.image!,
                        height: 80,
                        width: 80,
                        fit: BoxFit.fill,
                        placeholder: (_, __) =>  Image.asset(
                          'assets/images/unknown_person.png',
                          height: 80,
                          width: 80,
                        ),
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.grey),
                            borderRadius: BorderRadius.circular(24),
                            image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                          ),
                        ),
                      )
                    : Image.asset(
                        'assets/images/img_2.png',
                        height: 80,
                        width: 80,
                        fit: BoxFit.contain,
                      ),
                const SizedBox(
                  width: 16,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.title,
                      style: AppTextStyles.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      resume.userInfo.fullName,
                      style: AppTextStyles.hint.copyWith(color: AppColors.darkGrey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const SizedBox(
              width: 40,
            ),
            Expanded(
              child: TitleWithIcon(
                title: resume.userInfo.country ?? "",
                icon: Icon(
                  Icons.location_on_rounded,
                  size: 20,
                  color: Colors.grey[600],
                ),
              ),
            ),
              Expanded(
              child: TitleWithIcon(
                title: "${job.workTime} ${context.translate('hours')}",
                icon: SvgPicture.asset(
                  'assets/images/chair.svg',
                  height: 20,
                  width: 20,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
          Row(
          children: [
            const SizedBox(
              width: 40,
            ),
            Expanded(
              child: TitleWithIcon(
                title:
                    "${job.yearsOfExperiences} ${context.translate('year${job.yearsOfExperiences > 10 ? '' : 's'}_of_experience')}",
                icon: SvgPicture.asset(
                  'assets/images/contract_length.svg',
                  height: 20,
                  width: 20,
                  color: Colors.grey[600],
                ),
              ),
            ),
            Expanded(
              child: TitleWithIcon(
                title: job.publishTime,
                icon: Icon(
                  Icons.access_time_filled,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class TitleWithIcon extends StatelessWidget {
  final String title;
  final Widget icon;

  const TitleWithIcon({Key? key, required this.title, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icon,
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title ,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyNormal.copyWith(
              color: Colors.grey[600],
            ),
          ),
        )
      ],
    );
  }
}
