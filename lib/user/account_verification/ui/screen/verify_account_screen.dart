import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/_shared/widgets/loading_widget.dart';
import 'package:job_me/_shared/widgets/primary_app_bar.dart';
import 'package:job_me/_shared/widgets/primary_button.dart';
import 'package:job_me/_shared/widgets/primary_edit_text.dart';
import 'package:job_me/user/account_verification/providers/account_verification_proivder.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class VerifyAccountScreen extends StatefulWidget {
  static Widget init({required Color color}) {
    return ChangeNotifierProvider(
      create: (context) => AccountVerificationProvider(context),
      child: VerifyAccountScreen._(color: color),
    );
  }

  final Color color;

  const VerifyAccountScreen._({Key? key, required this.color}) : super(key: key);

  @override
  State<VerifyAccountScreen> createState() => _VerifyAccountScreenState();
}

class _VerifyAccountScreenState extends State<VerifyAccountScreen> {
  final _phoneNumberController = TextEditingController();
  String countryCode = "+965";
  String code = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<AccountVerificationProvider>();
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const PrimaryAppBar(
        elevation: 0,
        title: '',
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        children: [
          const SizedBox(height: 40),
          Text(
            context.translate('phone'),
            style: AppTextStyles.headerHuge.copyWith(color: widget.color),
          ),
          const SizedBox(height: 80),
          if (!provider.isCodeSent)
            Row(
              children: [
                Expanded(
                  child: PrimaryEditText(
                    controller: _phoneNumberController,
                    hint: context.translate('phone'),
                  ),
                ),
                CountryCodePicker(
                  onChanged: _onChangeCountryCode,
                  initialSelection: 'KW',
                  favorite: const ['+965', 'KW', '+970', 'PS'],
                  showCountryOnly: false,
                  showOnlyCountryWhenClosed: false,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  alignLeft: false,
                ),
              ],
            ),
          const SizedBox(height: 16),
          if (provider.isCodeSent)
            Directionality(
              textDirection: TextDirection.ltr,
              child: PinCodeTextField(
                length: 6,
                appContext: context,
                obscureText: false,
                showCursor: true,
                keyboardType: TextInputType.number,
                animationType: AnimationType.fade,
                validator: (val) => val == null || val.isEmpty ? 'Enter otp here' : null,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  fieldHeight: 63,
                  fieldWidth: 55,
                  borderWidth: 1,
                  borderRadius: BorderRadius.circular(10),
                  selectedColor: widget.color,
                  selectedFillColor: Colors.transparent,
                  inactiveFillColor: Colors.transparent,
                  inactiveColor: AppColors.grey,
                  activeColor: widget.color,
                  activeFillColor: Colors.white,
                ),
                animationDuration: const Duration(milliseconds: 300),
                backgroundColor: Colors.transparent,
                enableActiveFill: true,
                onChanged: onCodeChanged,
                beforeTextPaste: (text) {
                  return true;
                },
              ),
            ),
          const SizedBox(height: 80),
          if (!provider.isCodeSent)
            provider.isTransactionLoading
                ? const LoadingWidget()
                : PrimaryButton(
                    onPressed: () => provider.onSendActivationCode(countryCode + _phoneNumberController.text),
                    color: widget.color,
                    title: context.translate('send_code'),
                  ),
          if (provider.isCodeSent)
            provider.isTransactionLoading
                ? const LoadingWidget()
                : PrimaryButton(
                    onPressed: () => provider.activateAccount(countryCode + _phoneNumberController.text, code),
                    color: widget.color,
                    title: context.translate('activate'),
                  ),
          const SizedBox(height: 20),
          Center(
            child: GestureDetector(
              onTap: () => provider.onSendActivationCode(countryCode + _phoneNumberController.text),
              child: Text(
                context.translate('resend_code'),
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.darkGrey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onChangeCountryCode(CountryCode value) {
    countryCode = value.toString();
  }

  void onCodeChanged(String code) {
    this.code = code;
  }
}
