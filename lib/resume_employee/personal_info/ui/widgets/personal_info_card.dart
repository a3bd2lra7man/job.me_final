import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/resume_employee/personal_info/providers/personal_info_provider.dart';
import 'package:job_me/resume_employee/personal_info/ui/screens/update_personal_info_screen.dart';
import 'package:job_me/resume_employee/personal_info/ui/widgets/personal_image_container.dart';
import 'package:job_me/resume_core/ui/widgets/resume_container.dart';
import 'package:job_me/resume_core/ui/widgets/resume_container_loader.dart';
import 'package:job_me/resume_core/ui/widgets/row_tile.dart';
import 'package:provider/provider.dart';

class PersonalInfoCard extends StatelessWidget {
  static Widget init() {
    return ChangeNotifierProvider(
      create: (context) => PersonalInfoProvider(context),
      child: const PersonalInfoCard._(),
    );
  }

  const PersonalInfoCard._({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<PersonalInfoProvider>();
    return provider.isLoading
        ? const ResumeContainerLoader()
        : ResumeContainer(
            title: context.translate('personal_info'),
            iconData: Icons.edit_road_rounded,
            buttonText: context.translate('update_personal_info'),
            onButtonClicked: () {
              Get.to(UpdatePersonalInfoScreen.init(provider));
            },
            children: [
              const SizedBox(height: 20),
              ImageContainer(
                imageUrl: provider.getUserImage(),
                width: 80,
                height: 80,
              ),
              const SizedBox(height: 16),
              RowTile(title: context.translate('gender'), subTitle: provider.getUserGender()),
              RowTile(title: context.translate('birthday'), subTitle: provider.getDateOfBirth() ?? ""),
              RowTile(title: context.translate('nationality'), subTitle: provider.getUserCountry()),
              RowTile(title: context.translate('phone'), subTitle: provider.getUserPhone()),
            ],
          );
  }
}
