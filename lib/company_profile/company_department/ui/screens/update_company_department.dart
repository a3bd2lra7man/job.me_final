// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/widgets/loading_widget.dart';
import 'package:job_me/_shared/widgets/primary_app_bar.dart';
import 'package:job_me/_shared/widgets/primary_button.dart';
import 'package:job_me/_shared/widgets/primary_edit_text.dart';
import 'package:job_me/company_profile/company_department/models/company_department.dart';
import 'package:job_me/company_profile/company_department/providers/company_departments_provider.dart';
import 'package:job_me/company_profile/company_info/providers/company_departments_provider.dart';
import 'package:provider/provider.dart';

class UpdateCompanyDepartmentScreen extends StatelessWidget {
  final CompanyDepartment companyDepartment;

  static Widget init(
      {required CompanyInfoProvider companyInfoProvider,
      required CompanyDepartment companyDepartment,
      required CompanyDepartmentProvider companyDepartmentProvider}) {
    companyDepartmentProvider.onStartUpdatingCompanyDepartment(companyDepartment);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CompanyDepartmentProvider(context)..onStartUpdatingCompanyDepartment(companyDepartment),
        ),
        ChangeNotifierProvider.value(value: companyInfoProvider),
      ],
      child: UpdateCompanyDepartmentScreen._(
        companyDepartment: companyDepartment,
      ),
    );
  }

  UpdateCompanyDepartmentScreen._({Key? key, required this.companyDepartment}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<CompanyDepartmentProvider>();
    var companyInfoProvider = context.watch<CompanyInfoProvider>();
    return Scaffold(
      backgroundColor: AppColors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: PrimaryAppBar(
        title: context.translate('departments'),
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
                    var isUpdated = await provider.updateCompanyDepartment(companyDepartment.id!);
                    if (isUpdated == true) {
                      await companyInfoProvider.fetchCompanyInfo();
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
                'assets/images/img_14.png',
                width: 200,
                height: 200,
              ),
            ),
            const SizedBox(height: 16),
            PrimaryEditText(
              hint: context.translate('country'),
              controller: provider.countryController,
              validator: provider.isStringValid,
            ),
            const SizedBox(height: 32),
            PrimaryEditText(
              hint: context.translate('city'),
              controller: provider.cityController,
              validator: provider.isStringValid,
            ),
            const SizedBox(height: 32),
            PrimaryEditText(
              hint: context.translate('employees_count'),
              controller: provider.employeeCountController,
              validator: provider.isNumberValid,
              inputType: TextInputType.number,
            ),
            const SizedBox(height: 180),
          ],
        ),
      ),
    );
  }
}
