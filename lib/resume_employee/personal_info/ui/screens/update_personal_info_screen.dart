import 'package:country_list_picker/country_list_picker.dart';
import 'package:flutter/material.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/_shared/widgets/date_picker.dart';
import 'package:job_me/_shared/widgets/loading_widget.dart';
import 'package:job_me/_shared/widgets/primary_app_bar.dart';
import 'package:job_me/_shared/widgets/primary_button.dart';
import 'package:job_me/_shared/widgets/primary_edit_text.dart';
import 'package:job_me/_utils/localizations/localization_proivder.dart';
import 'package:job_me/resume_employee/personal_info/providers/personal_info_provider.dart';
import 'package:job_me/resume_employee/personal_info/ui/widgets/personal_image_container.dart';
import 'package:provider/provider.dart';

class UpdatePersonalInfoScreen extends StatelessWidget {
  static Widget init(PersonalInfoProvider provider) {
    provider.onStartUpdating();
    return ChangeNotifierProvider.value(value: provider, child: UpdatePersonalInfoScreen._());
  }

  final _formKey = GlobalKey<FormState>();

  UpdatePersonalInfoScreen._({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<PersonalInfoProvider>();
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PrimaryAppBar(
        title: context.translate('personal_info'),
        titleColor: AppColors.black,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          children: [
            const SizedBox(height: 20),
            Center(
              child: ImageContainer(
                imageUrl: provider.getUserImage(),
                onImageSelected: provider.onImageSelected,
              ),
            ),
            const SizedBox(height: 80),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => provider.onGenderSelected(isMan: true),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          context.translate('male'),
                          style: AppTextStyles.hint.copyWith(color: AppColors.darkGrey),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          (provider.isGenderMan ?? false)
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off_outlined,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => provider.onGenderSelected(isMan: false),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          context.translate('female'),
                          style: AppTextStyles.hint.copyWith(color: AppColors.darkGrey),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          (!(provider.isGenderMan ?? true))
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off_outlined,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            DatePicker(
              initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
              startDate: DateTime(1950),
              lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
              title: (provider.getDateOfBirth() ?? context.translate('birthday')),
              onDateSelected: provider.onDateSelected,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.translate('nationality'),
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.darkGrey),
                ),
                CountryListPicker(
                  dialogTheme: DialogThemeData(
                    appBar: PrimaryAppBar(
                      title: context.translate('select_country'),
                    ),
                  ),
                  initialCountry: Countries.United_States,
                  isShowDiallingCode: true,
                  diallingCodeStyle: const TextStyle(color: Colors.transparent),
                  isShowInputField: false,
                  isShowCountryName: false,
                  isShowFlag: provider.countryName == null,
                  language: context.watch<LocalizationProvider>().isEn() ? Languages.English : Languages.Arabic,
                  onCountryChanged: ((value) {
                    provider.selectCountry(value.name.official);
                  }),
                ),
                Text(
                  provider.countryName ?? "",
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.darkGrey),
                ),
              ],
            ),
            const SizedBox(height: 40),
            PrimaryEditText(
              hint: context.translate('phone'),
              controller: provider.phoneController,
              validator: provider.isPhoneValid,
              inputType: TextInputType.number,
            ),
            const SizedBox(height: 80),
            provider.isLoading
                ? const LoadingWidget()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child:
                        PrimaryButton(onPressed: () => _updatePersonalInfo(provider), title: context.translate('save')),
                  ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  _updatePersonalInfo(PersonalInfoProvider provider) {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      provider.updateProfileData();
    }
  }
}
