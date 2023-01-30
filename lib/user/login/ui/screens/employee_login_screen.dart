import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/home/home/ui/screens/home_page.dart';
import 'package:job_me/user/_user_core/models/roles.dart';
import 'package:job_me/user/_user_core/repositories/user_repository.dart';
import 'package:job_me/user/login/providers/login_provider.dart';
import 'package:job_me/user/login/ui/screens/base_login_screen.dart';
import 'package:job_me/user/sign_up/ui/screens/employee_signup_screen.dart';
import 'package:provider/provider.dart';

class EmployeeLoginScreen extends StatelessWidget {
  static Widget init() {
    return ChangeNotifierProvider(
      create: (context) => LoginProvider(context),
      child: EmployeeLoginScreen._(),
    );
  }

  EmployeeLoginScreen._({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<LoginProvider>();
    return Form(
      key: _formKey,
      child: BaseLoginScreen(
        role: Roles.searcherForJob,
        color: const Color.fromRGBO(0, 169, 192, 1),
        provider: provider,
        onLoginClicked: () => _login(provider),
        onCreateNewAccountClicked: () => Get.to(EmployeeSignUpScreen.init()),
        onContinueAsGuest: () {
          UserRepository().setVisitorUserRole(Roles.searcherForJob);
          Get.to(HomePage.init(), transition: Transition.downToUp);
        },
      ),
    );
  }

  void _login(LoginProvider provider) {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      provider.login();
    }
  }
}
