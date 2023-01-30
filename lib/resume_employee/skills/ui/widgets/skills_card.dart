import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/resume_employee/resume/providers/resume_provider.dart';
import 'package:job_me/resume_employee/skills/providers/skills_provider.dart';
import 'package:job_me/resume_core/ui/widgets/resume_container.dart';
import 'package:job_me/resume_core/ui/widgets/resume_container_loader.dart';
import 'package:job_me/resume_employee/skills/ui/screens/add_skills_screen.dart';
import 'package:provider/provider.dart';

class SkillsCard extends StatelessWidget {
  static Widget init() {
    return ChangeNotifierProvider(
      create: (context) => SkillsProvider(context),
      child: const SkillsCard._(),
    );
  }

  const SkillsCard._({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<SkillsProvider>();
    var resumeProvider = context.watch<ResumeProvider>();
    return resumeProvider.isLoading || provider.isLoading
        ? const ResumeContainerLoader()
        : ResumeContainer(
            title: context.translate('skills'),
            iconData: Icons.add_box_rounded,
            buttonText: context.translate('add_skill'),
            onButtonClicked: () {
              Get.to(AddSkillsFormScreen.init(resumeProvider: resumeProvider, skillsProvider: provider));
            },
            children: [
              const SizedBox(height: 16),
              Wrap(
                direction: Axis.horizontal,
                children: resumeProvider.resume.skills
                    .map(
                      (skill) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Chip(
                          onDeleted: () async {
                            await provider.deleteSkill(skill.id!);
                            await resumeProvider.fetchResume();
                          },
                          deleteIcon: Icon(
                            Icons.delete_outline_rounded,
                            color: AppColors.darkGrey,
                            size: 20,
                          ),
                          backgroundColor: AppColors.primary.withOpacity(.5),
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(width: 2),
                              Text(
                                skill.name,
                                style: AppTextStyles.hintBold.copyWith(color: AppColors.darkGrey),
                              ),
                              const SizedBox(width: 2),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          );
  }
}
