import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/_shared/widgets/loading_widget.dart';
import 'package:job_me/company_profile/company_department/providers/company_departments_provider.dart';
import 'package:job_me/company_profile/company_department/ui/screens/add_company_department.dart';
import 'package:job_me/company_profile/company_department/ui/screens/update_company_department.dart';
import 'package:job_me/company_profile/company_info/providers/company_departments_provider.dart';
import 'package:job_me/resume_core/ui/widgets/resume_container.dart';
import 'package:job_me/resume_core/ui/widgets/row_tile.dart';
import 'package:provider/provider.dart';

class CompanyDepartmentCard extends StatelessWidget {
  static Widget init() {
    return ChangeNotifierProvider(
      create: (context) => CompanyDepartmentProvider(context),
      child: const CompanyDepartmentCard._(),
    );
  }

  const CompanyDepartmentCard._({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var companyProvider = context.watch<CompanyInfoProvider>();
    var departmentProvider = context.watch<CompanyDepartmentProvider>();
    return ResumeContainer(
      title: context.translate('departments'),
      iconData: Icons.add_box_rounded,
      buttonText: context.translate('add_department'),
      onButtonClicked: () {
        Get.to(AddCompanyDepartmentScreen.init(
            companyInfo: companyProvider.companyInfo!,
            companyInfoProvider: companyProvider,
            companyDepartmentProvider: departmentProvider));
      },
      children: [
        ...companyProvider.companyInfo!.companyDepartments
            .map(
              (companyDepartment) => Column(
                children: [
                  const SizedBox(height: 16),
                  RowTile(title: context.translate('country'), subTitle: companyDepartment.country),
                  RowTile(title: context.translate('city'), subTitle: companyDepartment.city),
                  RowTile(
                      title: context.translate('employees_count'),
                      subTitle: companyDepartment.employeesCount.toString()),
                  const SizedBox(height: 20),
                  departmentProvider.isLoading
                      ? const LoadingWidget()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.to(UpdateCompanyDepartmentScreen.init(
                                    companyInfoProvider: companyProvider,
                                    companyDepartment: companyDepartment,
                                    companyDepartmentProvider: departmentProvider));
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
                                await departmentProvider.deleteCompanyDepartment(companyDepartment.id!);
                                await companyProvider.fetchCompanyInfo();
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
    );
  }
}
