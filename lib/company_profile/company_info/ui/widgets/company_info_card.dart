import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/company_profile/company_info/providers/company_departments_provider.dart';
import 'package:job_me/company_profile/company_info/ui/screens/update_company_info_screen.dart';
import 'package:job_me/resume_core/ui/widgets/resume_container.dart';
import 'package:job_me/resume_core/ui/widgets/resume_container_loader.dart';
import 'package:job_me/resume_core/ui/widgets/row_tile.dart';
import 'package:provider/provider.dart';

class CompanyInfoCard extends StatelessWidget {
  const CompanyInfoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<CompanyInfoProvider>();
    return provider.isLoading
        ? const ResumeContainerLoader()
        : Builder(builder: (context) {
            return ResumeContainer(
              title: context.translate('company_information'),
              iconData: Icons.edit_road_sharp,
              buttonText: context.translate('update_company_info'),
              onButtonClicked: () {
                Get.to(()=>UpdateCompanyInfoScreen.init(provider));
              },
              children: [
                const SizedBox(height: 16),
                RowTile(title: context.translate('company_name'), subTitle: provider.companyInfo!.name),
                RowTile(title: context.translate('company_date'), subTitle: provider.companyInfo!.date ?? ""),
                RowTile(title: context.translate('company_size'), subTitle: provider.companyInfo!.size ?? ""),
                RowTile(title: context.translate('email'), subTitle: provider.companyInfo!.email),
              ],
            );
          });
  }
}
