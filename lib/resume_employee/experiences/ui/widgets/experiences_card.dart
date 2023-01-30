import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/resume_employee/experiences/providers/experiences_provider.dart';
import 'package:job_me/resume_employee/experiences/ui/screens/add_experience_screen.dart';
import 'package:job_me/resume_employee/experiences/ui/screens/update_experience_screen.dart';
import 'package:job_me/resume_employee/resume/providers/resume_provider.dart';
import 'package:job_me/resume_core/ui/widgets/resume_container.dart';
import 'package:job_me/resume_core/ui/widgets/resume_container_loader.dart';
import 'package:job_me/resume_core/ui/widgets/row_tile.dart';
import 'package:provider/provider.dart';

class ExperiencesCard extends StatelessWidget {
  static Widget init() {
    return ChangeNotifierProvider(
      create: (context) => ExperiencesProvider(context),
      child: const ExperiencesCard._(),
    );
  }

  const ExperiencesCard._({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var resumeProvider = context.watch<ResumeProvider>();
    var experiencesProvider = context.watch<ExperiencesProvider>();
    return resumeProvider.isLoading || experiencesProvider.isLoading
        ? const ResumeContainerLoader()
        : ResumeContainer(
            title: context.translate('experience'),
            iconData: Icons.add_box_rounded,
            buttonText: context.translate('add_experience'),
            onButtonClicked: () {
              Get.to(
                  AddExperienceScreen.init(resumeProvider: resumeProvider, experiencesProvider: experiencesProvider));
            },
            children: [
              ...resumeProvider.resume.experience
                  .map(
                    (experience) => Column(
                      children: [
                        const SizedBox(height: 16),
                        RowTile(title: context.translate('facility'), subTitle: experience.enterpriseName),
                        RowTile(title: context.translate('job_title'), subTitle: experience.jobName),
                        RowTile(title: context.translate('field'), subTitle: experience.field),
                        RowTile(
                          title: context.translate('date'),
                          subTitle: "${experience.startDate} -> ${experience.endDate}",
                          textStyle: AppTextStyles.smallStyle,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.to(UpdateExperienceScreen.init(
                                    resumeProvider: resumeProvider,
                                    experiencesProvider: experiencesProvider,
                                    experience: experience));
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.edit_road_sharp,
                                    color: AppColors.primary,
                                  ),
                                  Text(
                                    context.translate('edit'),
                                    style: AppTextStyles.smallStyle.copyWith(color: AppColors.primary),
                                  )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await experiencesProvider.deleteExperience(experience.id!);
                                await resumeProvider.fetchResume();
                              },
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  Text(
                                    context.translate('delete'),
                                    style: AppTextStyles.smallStyle.copyWith(color: Colors.red),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        Divider(
                          thickness: 1,
                          color: AppColors.lightGrey,
                        ),
                      ],
                    ),
                  )
                  .toList()
            ],
          );
  }
}
