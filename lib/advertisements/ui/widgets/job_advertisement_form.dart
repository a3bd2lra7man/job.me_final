import 'package:flutter/material.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/widgets/primary_edit_text.dart';
import 'package:job_me/advertisements/providers/job_advertisement_form_provider.dart';
import 'package:job_me/advertisements/ui/widgets/multi_line_edit_text.dart';
import 'package:provider/provider.dart';

class JobAdvertisementForm extends StatelessWidget {
  const JobAdvertisementForm({Key? key, required this.formKey}) : super(key: key);

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<JobAdvertisementFormProvider>();

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
                controller: provider.titleController,
                hint: context.translate('job_name'),
                validator: provider.isJobNameValid,
              ),
              const SizedBox(height: 40),
              LargeEditText(
                controller: provider.descriptionController,
                validator: provider.isLongTextValid,
                hint: context.translate('job_description'),
              ),
              const SizedBox(height: 20),
              Visibility(
                visible: provider.isUserCompany(),
                child: LargeEditText(
                  controller: provider.requirementController,
                  validator: provider.isLongTextValid,
                  hint: context.translate('job_requirements'),
                  maxLines: 4,
                ),
              ),
              Visibility(
                visible: provider.isUserCompany(),
                child: const SizedBox(height: 20),
              ),
              PrimaryEditText(
                controller: provider.yearsOfExperienceController,
                hint: context.translate('years_of_experience'),
                validator: provider.isNumberValid,
                inputType: TextInputType.number,
              ),
              const SizedBox(height: 40),
              PrimaryEditText(
                controller: provider.hoursToWorkInPerDayController,
                hint: context.translate('work_hours'),
                validator: provider.isNumberValid,
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
