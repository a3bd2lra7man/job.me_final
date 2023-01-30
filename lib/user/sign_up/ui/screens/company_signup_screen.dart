import 'package:flutter/material.dart';
import 'package:job_me/user/sign_up/providers/signup_provider.dart';
import 'package:job_me/user/sign_up/ui/screens/base_signup_screen.dart';
import 'package:provider/provider.dart';

class CompanySignUpScreen extends StatelessWidget {
  static Widget init() {
    return ChangeNotifierProvider(
      create: (context) => SignUpProvider(context),
      child: CompanySignUpScreen._(),
    );
  }

  CompanySignUpScreen._({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<SignUpProvider>();
    return Form(
      key: _formKey,
      child: BaseSignUpScreen(
        color: const Color.fromRGBO(38, 195, 174, 1),
        provider: provider,
        onRegister: () => _signUp(provider),
      ),
    );
  }

  void _signUp(SignUpProvider provider) {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      provider.signUpCompany();
    }
  }
}
