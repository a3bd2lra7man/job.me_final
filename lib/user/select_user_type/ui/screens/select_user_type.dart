import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/_shared/widgets/primary_button.dart';
import 'package:job_me/user/login/ui/screens/company_login_screen.dart';
import 'package:job_me/user/login/ui/screens/employee_login_screen.dart';

class SelectUserTypeScreen extends StatelessWidget {
  const SelectUserTypeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 100,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.translate('please_select_user_type_1'),
                  style: AppTextStyles.headerBig,
                ),
                Text(
                  context.translate('please_select_user_type_2'),
                  style: AppTextStyles.headerBig.copyWith(fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 80,
          ),
          SvgPicture.asset("assets/images/select_user_type.svg"),
          const SizedBox(
            height: 120,
          ),
          Column(
            children: [
              PrimaryButton(
                onPressed: () {
                  Get.to(() => EmployeeLoginScreen.init());
                },
                title: context.translate('go_as_searcher_for_job'),
              ),
              const SizedBox(
                height: 40,
              ),
              PrimaryButton(
                onPressed: () {
                  Get.to(() => CompanyLoginScreen.init());
                },
                title: context.translate('go_as_job_poster'),
              ),
            ],
          ),
          const SizedBox(
            height: 200,
          ),
        ],
      ),
    );
  }
}
