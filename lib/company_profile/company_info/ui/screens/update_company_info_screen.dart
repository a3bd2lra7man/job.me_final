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
import 'package:job_me/company_profile/company_info/providers/company_departments_provider.dart';
import 'package:job_me/resume_employee/personal_info/ui/widgets/personal_image_container.dart';
import 'package:provider/provider.dart';

class UpdateCompanyInfoScreen extends StatelessWidget {
  static Widget init(CompanyInfoProvider provider) {
    provider.onStartUpdatingCompanyInfo();
    return ChangeNotifierProvider.value(
      value: provider,
      child: UpdateCompanyInfoScreen._(),
    );
  }

  UpdateCompanyInfoScreen._({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<CompanyInfoProvider>();
    return Scaffold(
      backgroundColor: AppColors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: PrimaryAppBar(
        title: context.translate('company_info'),
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
                    var isUpdated = await provider.updateCompanyInfo();
                    if (isUpdated == true) {
                      await provider.fetchCompanyInfo();
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
              child: ImageContainer(
                imageUrl: provider.companyInfo!.photo,
                onImageSelected: provider.onImageSelected,
              ),
            ),
            const SizedBox(height: 16),
            PrimaryEditText(
              hint: context.translate('company_name'),
              controller: provider.nameController,
              validator: provider.isStringValid,
            ),
            const SizedBox(height: 32),
            DatePicker(
              onDateSelected: (dateTime) {
                provider.date = dateTime;
              },
              title: provider.date?.toRawString() ?? context.translate('company_date'),
              initialDate: DateTime.now(),
              startDate: DateTime(1900),
              lastDate: DateTime.now(),
            ),
            const SizedBox(height: 12),
            PrimaryEditText(
              hint: context.translate('field'),
              controller: provider.fieldController,
              validator: provider.isStringValid,
            ),
            const SizedBox(height: 32),
            PrimaryEditText(
              hint: context.translate('email'),
              controller: provider.emailController,
              validator: provider.isStringValid,
            ),
            const SizedBox(height: 32),
            PrimaryEditText(
              hint: context.translate('company_size'),
              controller: provider.sizeController,
              validator: provider.isStringValid,
            ),
            const SizedBox(height: 32),
            PrimaryEditText(
              hint: context.translate('notes'),
              controller: provider.notesController,
              validator: provider.isStringValid,
            ),
            const SizedBox(height: 180),
          ],
        ),
      ),
    );
  }
}
