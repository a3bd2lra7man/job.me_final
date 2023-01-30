// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/widgets/primary_app_bar.dart';
import 'package:job_me/company_profile/company_department/ui/widgets/company_departments_card.dart';
import 'package:job_me/company_profile/company_info/providers/company_departments_provider.dart';
import 'package:job_me/company_profile/company_info/ui/widgets/company_info_card.dart';
import 'package:provider/provider.dart';

import 'company_info_screen_loader.dart';

class CompanyInfoScreen extends StatefulWidget {
  static Widget init() {
    return ChangeNotifierProvider(
      create: (context) => CompanyInfoProvider(context),
      child: const CompanyInfoScreen._(),
    );
  }

  const CompanyInfoScreen._({Key? key}) : super(key: key);

  @override
  State<CompanyInfoScreen> createState() => _CompanyInfoScreenState();
}

class _CompanyInfoScreenState extends State<CompanyInfoScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<CompanyInfoProvider>().fetchCompanyInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<CompanyInfoProvider>();
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: PrimaryAppBar(
        title: context.translate('company_info'),
        titleColor: AppColors.black,
        elevation: 0,
      ),
      body: provider.isLoading || provider.companyInfo == null
          ? const CompanyInfoScreenLoader()
          : Container(
              color: AppColors.primary.withOpacity(.04),
              child: ListView(
                children: [
                  const SizedBox(height: 20),
                  const CompanyInfoCard(),
                  const SizedBox(height: 20),
                  CompanyDepartmentCard.init(),
                  const SizedBox(height: 180),
                ],
              ),
            ),
    );
  }
}
