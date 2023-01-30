import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/resume_employee/educations/providers/educations_provider.dart';
import 'package:job_me/resume_employee/educations/ui/screens/add_education_screen.dart';
import 'package:job_me/resume_employee/educations/ui/screens/update_education_screen.dart';
import 'package:job_me/resume_employee/resume/providers/resume_provider.dart';
import 'package:job_me/resume_core/ui/widgets/resume_container.dart';
import 'package:job_me/resume_core/ui/widgets/resume_container_loader.dart';
import 'package:job_me/resume_core/ui/widgets/row_tile.dart';
import 'package:provider/provider.dart';

class EducationsCard extends StatefulWidget {
  static Widget init() {
    return ChangeNotifierProvider(
      create: (context) => EducationsProvider(context),
      child: const EducationsCard._(),
    );
  }

  const EducationsCard._({Key? key}) : super(key: key);

  @override
  State<EducationsCard> createState() => _EducationsCardState();
}

class _EducationsCardState extends State<EducationsCard> {
  @override
  Widget build(BuildContext context) {
    var resumeProvider = context.watch<ResumeProvider>();
    var educationProvider = context.watch<EducationsProvider>();
    return resumeProvider.isLoading || educationProvider.isLoading
        ? const ResumeContainerLoader()
        : Builder(
            builder: (_) => ResumeContainer(
                  title: context.translate('educations'),
                  iconData: Icons.add_box_rounded,
                  buttonText: context.translate('add_educations'),
                  onButtonClicked: () {
                    Get.to(AddEducationFormScreen.init(
                        resumeProvider: resumeProvider, educationsProvider: educationProvider));
                  },
                  children: [
                    ...resumeProvider.resume.educations
                        .map(
                          (education) => Column(
                            children: [
                              const SizedBox(height: 16),
                              RowTile(
                                  title: context.translate('facility_of_education'),
                                  subTitle: education.universityName),
                              RowTile(title: context.translate('college'), subTitle: education.specialization),
                              RowTile(title: context.translate('higher_education'), subTitle: education.level),
                              RowTile(
                                title: context.translate('date'),
                                subTitle: "${education.startDate} -> ${education.endDate}",
                                textStyle: AppTextStyles.smallStyle,
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(UpdateEducationFormScreen.init(
                                          resumeProvider: resumeProvider,
                                          educationsProvider: educationProvider,
                                          education: education));
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
                                      await educationProvider.deleteEducation(education.id!);
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
                ));
  }
}
