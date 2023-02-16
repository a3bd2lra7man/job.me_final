import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/_shared/widgets/primary_edit_text.dart';
import 'package:job_me/_utils/localizations/localization_proivder.dart';
import 'package:job_me/advertisements/models/category.dart';
import 'package:job_me/advertisements/providers/advertisement_provider.dart';
import 'package:job_me/advertisements/providers/job_advertisement_form_provider.dart';
import 'package:job_me/advertisements/ui/screens/select_category.dart';
import 'package:job_me/advertisements/ui/widgets/multi_line_edit_text.dart';
import 'package:provider/provider.dart';

class JobAdvertisementForm extends StatelessWidget {
  const JobAdvertisementForm({Key? key, required this.formKey}) : super(key: key);

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    var formProvider = context.watch<JobAdvertisementFormProvider>();
    var provider = context.watch<AdvertisementOffersProvider>();
    var isEnglish = context.watch<LocalizationProvider>().isEn();

    return Form(
      key: formKey,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              PrimaryEditText(
                controller: formProvider.titleController,
                hint: context.translate('job_name'),
                validator: formProvider.isJobNameValid,
              ),
              const SizedBox(height: 40),
              LargeEditText(
                controller: formProvider.descriptionController,
                validator: formProvider.isLongTextValid,
                hint: context.translate('job_description'),
              ),
              const SizedBox(height: 20),
              Visibility(
                visible: formProvider.isUserCompany(),
                child: LargeEditText(
                  controller: formProvider.requirementController,
                  validator: formProvider.isLongTextValid,
                  hint: context.translate('job_requirements'),
                  maxLines: 4,
                ),
              ),
              Visibility(
                visible: formProvider.isUserCompany(),
                child: const SizedBox(height: 20),
              ),
              const SizedBox(height: 8),
              Container(
                decoration:
                    BoxDecoration(border: Border.all(color: AppColors.grey), borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  onTap: () => Get.to(SelectCategory.init(provider.selectableCategories, formProvider)),
                  title: Text(
                    context.translate('search_category'),
                    style: AppTextStyles.title,
                  ),
                  subtitle: Text(
                    formProvider.selectedCategory!.getName(isEnglish),
                    style: AppTextStyles.bodyNormal,
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              PrimaryEditText(
                controller: formProvider.yearsOfExperienceController,
                hint: context.translate('years_of_experience'),
                validator: formProvider.isNumberValid,
                inputType: TextInputType.number,
              ),
              const SizedBox(height: 40),
              PrimaryEditText(
                controller: formProvider.hoursToWorkInPerDayController,
                hint: context.translate('work_hours'),
                validator: formProvider.isNumberValid,
                inputType: TextInputType.number,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
