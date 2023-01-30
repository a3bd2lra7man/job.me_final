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
import 'package:job_me/resume_employee/educations/providers/educations_provider.dart';
import 'package:job_me/resume_employee/resume/providers/resume_provider.dart';
import 'package:provider/provider.dart';

class AddEducationFormScreen extends StatelessWidget {
  static Widget init({required ResumeProvider resumeProvider, required EducationsProvider educationsProvider}) {
    educationsProvider.onStartAddingEducation();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: resumeProvider),
        ChangeNotifierProvider.value(value: educationsProvider),
      ],
      child: AddEducationFormScreen._(),
    );
  }

  AddEducationFormScreen._({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var educationProvider = context.watch<EducationsProvider>();
    var resumeProvider = context.watch<ResumeProvider>();
    return Scaffold(
      backgroundColor: AppColors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: PrimaryAppBar(
        title: context.translate('educations'),
        titleColor: AppColors.black,
        elevation: 0,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: educationProvider.isLoading
            ? const LoadingWidget()
            : PrimaryButton(
                onPressed: () async {
                  if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                    var isAdded = await educationProvider.addEducation();
                    if (isAdded == true) {
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
                'assets/images/img_3.png',
                width: 200,
                height: 200,
              ),
            ),
            const SizedBox(height: 16),
            PrimaryEditText(
              hint: context.translate('facility_of_education_name'),
              controller: educationProvider.universityNameController,
              validator: educationProvider.isStringValid,
            ),
            const SizedBox(height: 32),
            PrimaryEditText(
              hint: context.translate('study_field'),
              controller: educationProvider.specializationController,
              validator: educationProvider.isStringValid,
            ),
            const SizedBox(height: 32),
            PrimaryEditText(
              hint: context.translate('higher_education'),
              controller: educationProvider.levelController,
              validator: educationProvider.isStringValid,
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
                      educationProvider.startDate = dateTime;
                    },
                    title: educationProvider.startDate?.toRawString() ?? context.translate('start_date'),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: DatePicker(
                    initialDate: DateTime.now(),
                    startDate: DateTime(1950),
                    lastDate: DateTime.now(),
                    onDateSelected: (dateTime) {
                      educationProvider.endDate = dateTime;
                    },
                    title: educationProvider.endDate?.toRawString() ?? context.translate('end_date'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            PrimaryEditText(
              hint: context.translate('education_result'),
              controller: educationProvider.markController,
              validator: educationProvider.isMarkValid,
            ),
            const SizedBox(height: 32),
            PrimaryEditText(
              hint: context.translate('country'),
              controller: educationProvider.countryController,
              validator: educationProvider.isCountryValid,
            ),
            const SizedBox(height: 180),
          ],
        ),
      ),
    );
  }
}
