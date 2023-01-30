import 'package:flutter/material.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/_shared/widgets/loading_widget.dart';
import 'package:job_me/_shared/widgets/primary_app_bar.dart';
import 'package:job_me/_shared/widgets/primary_button.dart';
import 'package:job_me/_shared/widgets/primary_edit_text.dart';
import 'package:job_me/resume_employee/resume/providers/resume_provider.dart';
import 'package:job_me/resume_employee/skills/providers/skills_provider.dart';
import 'package:provider/provider.dart';

class AddSkillsFormScreen extends StatelessWidget {
  static Widget init({required ResumeProvider resumeProvider, required SkillsProvider skillsProvider}) {
    skillsProvider.onAddNewSkill();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: resumeProvider),
        ChangeNotifierProvider.value(value: skillsProvider),
      ],
      child: AddSkillsFormScreen._(),
    );
  }

  AddSkillsFormScreen._({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var skillsProvider = context.watch<SkillsProvider>();
    var resumeProvider = context.watch<ResumeProvider>();
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PrimaryAppBar(
        title: context.translate('skills'),
        titleColor: AppColors.black,
        elevation: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: skillsProvider.isLoading || resumeProvider.isLoading
            ? const LoadingWidget()
            : PrimaryButton(
                onPressed: () async {
                  if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                    var isAdded = await skillsProvider.addSkill();
                    if (isAdded == true) {
                      await resumeProvider.fetchResume();
                    }
                  }
                },
                title: context.translate('save')),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          children: [
            const SizedBox(height: 20),
            Center(
              child: Image.asset(
                'assets/images/img_5.png',
                width: 200,
                height: 200,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: PrimaryEditText(
                    hint: context.translate('enter_a_skill'),
                    controller: skillsProvider.nameController,
                    validator: (s) => s == null || s.isEmpty ? context.translate('enter_valid_string') : null,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 1,
                  child: TextButton(
                    onPressed: () async {
                      if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                        var isAdded = await skillsProvider.addSkill();
                        if (isAdded == true) {
                          await resumeProvider.fetchResume();
                        }
                      }
                    },
                    child: Text(
                      context.translate('add'),
                      style: AppTextStyles.titleBold.copyWith(color: AppColors.primary),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Wrap(
              direction: Axis.horizontal,
              children: resumeProvider.resume.skills
                  .map(
                    (skill) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Chip(
                        onDeleted: () async {
                          await skillsProvider.deleteSkill(skill.id!);
                          await resumeProvider.fetchResume();
                        },
                        deleteIcon: Icon(
                          Icons.delete_outline_rounded,
                          color: AppColors.darkGrey,
                          size: 20,
                        ),
                        backgroundColor: AppColors.primary.withOpacity(.4),
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
        ),
      ),
    );
  }
}
