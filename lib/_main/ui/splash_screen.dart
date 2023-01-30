import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/widgets/primary_button.dart';
import 'package:job_me/_utils/localizations/localization_proivder.dart';
import 'package:job_me/home/home/ui/screens/home_page.dart';
import 'package:job_me/user/_user_core/repositories/user_repository.dart';
import 'package:job_me/user/select_user_type/ui/screens/select_user_type.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  bool isLanguageSelected = false;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    animation = CurvedAnimation(parent: animationController, curve: Curves.easeOut);
    animation.addListener(() => setState(() {}));
    animationController.forward();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      isLanguageSelected = await context.read<LocalizationProvider>().isLanguageSelected();
      Future.delayed(const Duration(seconds: 1), () {
        if (isLanguageSelected) {
          _goToHomeIfThereIsAUserElseGoToLogin();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: context.height,
        width: context.width,
        color: AppColors.primary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SvgPicture.asset(
                "assets/images/logo.svg",
                width: animation.value * 400,
                height: animation.value * 400,
              ),
            ),
            const SizedBox(height: 80),
            if(!isLanguageSelected)
            Opacity(
              opacity: animation.value,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                          color: AppColors.white,
                          titleColor: AppColors.primary,
                          onPressed: () => _selectLanguage('en'),
                          title: 'English'),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: PrimaryButton(
                          color: AppColors.white,
                          titleColor: AppColors.primary,
                          onPressed: () => _selectLanguage('ar'),
                          title: 'عربي'),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future _goToHomeIfThereIsAUserElseGoToLogin() async {
    await UserRepository.initRepo();
    var isUserLoggedIn = UserRepository().isUserLoggedIn();
    if (isUserLoggedIn) {
      Get.offAll(HomePage.init(), transition: Transition.downToUp);
    } else {
      Get.offAll(() => const SelectUserTypeScreen(), transition: Transition.downToUp);
    }
  }

  _selectLanguage(String locale) async {
    var provider = context.read<LocalizationProvider>();
    await provider.changeLanguageTo(locale);
    _goToHomeIfThereIsAUserElseGoToLogin();
  }
}
