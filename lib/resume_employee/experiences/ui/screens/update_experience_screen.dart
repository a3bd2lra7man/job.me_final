// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/extensions/date_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/widgets/date_picker.dart';
import 'package:job_me/_shared/widgets/loading_widget.dart';
import 'package:job_me/_shared/widgets/primary_app_bar.dart';
import 'package:job_me/_shared/widgets/primary_button.dart';
import 'package:job_me/_shared/widgets/primary_edit_text.dart';
import 'package:job_me/resume_employee/experiences/models/experience.dart';
import 'package:job_me/resume_employee/experiences/providers/experiences_provider.dart';
import 'package:job_me/resume_employee/resume/providers/resume_provider.dart';
import 'package:provider/provider.dart';

class UpdateExperienceScreen extends StatelessWidget {
  final Experience experience;

  static Widget init(
      {required ResumeProvider resumeProvider,
      required ExperiencesProvider experiencesProvider,
      required Experience experience}) {
    experiencesProvider.onStartUpdatingExperience(experience);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: resumeProvider),
        ChangeNotifierProvider.value(value: experiencesProvider),
      ],
      child: UpdateExperienceScreen._(
        experience: experience,
      ),
    );
  }

  UpdateExperienceScreen._({Key? key, required this.experience}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var experiencesProvider = context.watch<ExperiencesProvider>();
    var resumeProvider = context.watch<ResumeProvider>();
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PrimaryAppBar(
        title: context.translate('experience_edit'),
        titleColor: AppColors.black,
        elevation: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: experiencesProvider.isLoading
            ? const LoadingWidget()
            : PrimaryButton(
                onPressed: () async {
                  if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                    var isUpdated = await experiencesProvider.updateExperience(experience.id!);
                    if (isUpdated == true) {
                      await resumeProvider.fetchResume();
                      Navigator.of(context).pop();
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
                'assets/images/img_4.png',
                width: 200,
                height: 200,
              ),
            ),
            const SizedBox(height: 16),
            PrimaryEditText(
              hint: context.translate('facility_name'),
              controller: experiencesProvider.enterpriseNameController,
              validator: experiencesProvider.isStringValid,
            ),
            const SizedBox(height: 32),
            PrimaryEditText(
              hint: context.translate('field'),
              controller: experiencesProvider.filedController,
              validator: experiencesProvider.isStringValid,
            ),
            const SizedBox(height: 32),
            PrimaryEditText(
              hint: context.translate('job_title'),
              controller: experiencesProvider.jobNameController,
              validator: experiencesProvider.isStringValid,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: DatePicker(
                    initialDate: DateTime.now(),
                    startDate: DateTime(1950),
                    lastDate: DateTime.now(),
                    onDateSelected: (dateTime) {
                      experiencesProvider.startDate = dateTime;
                    },
                    title: experiencesProvider.startDate!.toRawString(),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: DatePicker(
                    initialDate: DateTime.now(),
                    startDate: DateTime(1950),
                    lastDate: DateTime.now(),
                    onDateSelected: (dateTime) {
                      experiencesProvider.endDate = dateTime;
                    },
                    title: experiencesProvider.endDate!.toRawString(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            PrimaryEditText(
              hint: context.translate('job_description'),
              controller: experiencesProvider.descriptionController,
              validator: experiencesProvider.isStringValid,
            ),
            const SizedBox(height: 32),
            PrimaryEditText(
              hint: context.translate('country'),
              controller: experiencesProvider.countryController,
              validator: experiencesProvider.isCountryValid,
            ),
            const SizedBox(height: 180),
          ],
        ),
      ),
    );
  }
}
