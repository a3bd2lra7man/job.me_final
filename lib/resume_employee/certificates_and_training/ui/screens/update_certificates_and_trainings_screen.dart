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
import 'package:job_me/resume_employee/certificates_and_training/models/certificate_or_training.dart';
import 'package:job_me/resume_employee/certificates_and_training/providers/certificates_and_training_provider.dart';
import 'package:job_me/resume_employee/resume/providers/resume_provider.dart';
import 'package:provider/provider.dart';

class UpdateCertificatesAndTrainingsScreen extends StatelessWidget {
  final CertificateOrTraining certificateOrTraining;

  static Widget init(
      {required ResumeProvider resumeProvider,
      required CertificatesAndTrainingsProvider certificatesAndTrainingsProvider,
      required CertificateOrTraining certificateOrTraining}) {
    certificatesAndTrainingsProvider.onStartUpdatingCertificateOrTraining(certificateOrTraining);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: resumeProvider),
        ChangeNotifierProvider.value(value: certificatesAndTrainingsProvider),
      ],
      child: UpdateCertificatesAndTrainingsScreen._(
        certificateOrTraining: certificateOrTraining,
      ),
    );
  }

  UpdateCertificatesAndTrainingsScreen._({Key? key, required this.certificateOrTraining}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<CertificatesAndTrainingsProvider>();
    var resumeProvider = context.watch<ResumeProvider>();
    return Scaffold(
      backgroundColor: AppColors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: PrimaryAppBar(
        title: context.translate('certificates_and_trainings'),
        titleColor: AppColors.black,
        elevation: 0,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: provider.isLoading
            ? const LoadingWidget()
            : PrimaryButton(
                onPressed: () async {
                  if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                    var isUpdated = await provider.updateCertificateOrTraining(certificateOrTraining.id!);
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
                'assets/images/img_5.png',
                width: 200,
                height: 200,
              ),
            ),
            const SizedBox(height: 16),
            PrimaryEditText(
              hint: context.translate('certificate_name_or_training'),
              controller: provider.nameController,
              validator: provider.isStringValid,
            ),
            const SizedBox(height: 32),
            PrimaryEditText(
              hint: context.translate('certificate_provider_name'),
              controller: provider.providerNameController,
              validator: provider.isStringValid,
            ),
            const SizedBox(height: 32),
            DatePicker(
              initialDate: DateTime.now(),
              startDate: DateTime(1950),
              lastDate: DateTime.now(),
              onDateSelected: (dateTime) {
                provider.date = dateTime;
              },
              title: provider.date?.toRawString() ?? context.translate('start_date'),
            ),
            const SizedBox(height: 12),
            PrimaryEditText(
              hint: context.translate('field'),
              controller: provider.filedController,
              validator: provider.isStringValid,
            ),
            const SizedBox(height: 32),
            PrimaryEditText(
              hint: context.translate('description'),
              controller: provider.descriptionController,
              validator: provider.isStringValid,
            ),
            const SizedBox(height: 180),
          ],
        ),
      ),
    );
  }
}
