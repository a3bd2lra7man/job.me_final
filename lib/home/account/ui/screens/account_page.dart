import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/widgets/loading_widget.dart';
import 'package:job_me/_utils/check_is_user_logged_in.dart';
import 'package:job_me/_utils/localizations/localization_proivder.dart';
import 'package:job_me/advertisement_special/ui/pages/prepare_to_add_to_special_my_advertisement_screen.dart';
import 'package:job_me/advertisements/ui/screens/add_job_advertisement_screen.dart';
import 'package:job_me/advertisements/ui/screens/my_advertisement_screen.dart';
import 'package:job_me/buy_coins/ui/screens/coins_screen.dart';
import 'package:job_me/company_profile/company_info/ui/screens/company_info_screen.dart';
import 'package:job_me/home/account/providers/account_proivder.dart';
import 'package:job_me/home/account/ui/widget/account_header.dart';
import 'package:job_me/home/account/ui/widget/account_list_tile.dart';
import 'package:job_me/home/account/ui/widget/delete_confirmation_dialog.dart';
import 'package:job_me/home/home/providers/home_provider.dart';
import 'package:job_me/main.dart';
import 'package:job_me/resume_employee/resume/ui/screens/employee_resume_screen.dart';
import 'package:job_me/terms_and_conditions_and_privacy/ui/screens/privacy.dart';
import 'package:job_me/terms_and_conditions_and_privacy/ui/screens/terms_and_conditions.dart';
import 'package:job_me/user/_user_core/repositories/user_repository.dart';
import 'package:job_me/user/account_verification/ui/screen/verify_account_screen.dart';
import 'package:job_me/user/change_password/ui/change_password_screen.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  static Widget init() {
    return ChangeNotifierProvider(
      create: (context) => AccountProvider(context),
      child: const AccountPage._(),
    );
  }

  const AccountPage._({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (isUserNotLoggedIn(context)) return;
      context.read<AccountProvider>().getUserBalance();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  // this function get called when user pop from inside screen balance and user info in some scenarios needs an update
  @override
  void didPopNext() {
    setState(() {});
    context.read<AccountProvider>().getUserBalance();
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<AccountProvider>();
    var homeProvider = context.watch<HomePageProvider>();
    return Container(
      color: AppColors.primary.withOpacity(.04),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const AccountHeader(),
          const SizedBox(height: 8),
          Visibility(
            visible: homeProvider.isUserEmployee(),
            child: AccountListTile(
              title: context.translate('resume'),
              icon: SvgPicture.asset('assets/images/resume.svg'),
              onTap: () => _checkUserLoggedInAndDo(() => Get.to(EmployeeResumeScreen.init())),
            ),
          ),
          Visibility(
            visible: homeProvider.isUserCompany(),
            child: AccountListTile(
              title: context.translate('company_info'),
              icon: SvgPicture.asset('assets/images/resume.svg'),
              onTap: () => _checkUserLoggedInAndDo(() => Get.to(CompanyInfoScreen.init())),
            ),
          ),
          AccountListTile(
            title: context.translate('activate_account'),
            icon: SvgPicture.asset('assets/images/activate.svg'),
            onTap: homeProvider.isUserActivated()
                ? () {}
                : () => _checkUserLoggedInAndDo(() => Get.to(() => VerifyAccountScreen.init(color: AppColors.primary))),
            trailingIcon: homeProvider.isUserActivated()
                ? const Icon(
                    Icons.done,
                    color: Colors.green,
                  )
                : null,
          ),
          AccountListTile(
            title: homeProvider.isUserEmployee()
                ? context.translate('promote_my_self')
                : context.translate('promote_a_job_position'),
            icon: SvgPicture.asset('assets/images/promote_my_self.svg'),
            onTap: () => _checkUserLoggedInAndDo(() {
              Get.to(()=>AddJobAdvertisementScreen.init());
            }),
          ),
          AccountListTile(
            title: context.translate('my_ads'),
            icon: const Icon(Icons.addchart_sharp),
            onTap: () => _checkUserLoggedInAndDo(() => Get.to(()=>MyAdvertisementScreen.init())),
          ),
          AccountListTile(
            title: context.translate('add_advertisement_to_special'),
            icon: SvgPicture.asset('assets/images/buy_coins.svg'),
            onTap: () => _checkUserLoggedInAndDo(() {
              Get.to(()=>PrepareMyAdvertisementToSpecialScreen.init());
            }),
          ),
          AccountListTile(
            title: context.translate('buy_coins'),
            icon: SvgPicture.asset('assets/images/buy_coins.svg'),
            onTap: () => _checkUserLoggedInAndDo(() {
              Get.to(CoinsScreen.init());
            }),
          ),
          AccountListTile(
            title: context.translate('terms_and_conditions'),
            icon: SvgPicture.asset('assets/images/terms_and_conditions.svg'),
            onTap: () => Get.to(() => const TermsAndConditionScreen()),
          ),
          AccountListTile(
            title: context.translate('privacy'),
            icon: SvgPicture.asset('assets/images/privacy.svg'),
            onTap: () => Get.to(() => const PrivacyScreen()),
          ),
          AccountListTile(
            title: context.translate('change_password'),
            icon: const Icon(Icons.password,),
            onTap: () => _checkUserLoggedInAndDo(() {
              Get.to(ChangePasswordScreen.init());
            }),
          ),
          AccountListTile(
            title: context.translate('change_language'),
            icon: const Icon(Icons.language_rounded),
            onTap: () {
              var provider = context.read<LocalizationProvider>();
              var locale = provider.locale;
              if (locale == 'en') {
                provider.changeLanguageTo('ar');
              } else {
                provider.changeLanguageTo('en');
              }
            },
          ),
          if (UserRepository().isUserLoggedIn())
            AccountListTile(
              title: context.translate('log_out'),
              icon: SvgPicture.asset('assets/images/log_out.svg'),
              onTap: provider.logOut,
            ),
          if (UserRepository().isUserLoggedIn())
            provider.isLoading
                ? const LoadingWidget()
                : AccountListTile(
                    titleColor: Colors.red,
                    title: context.translate('delete_account'),
                    icon: const SizedBox(),
                    onTap: () => Get.bottomSheet(ChangeNotifierProvider.value(value: provider,child: const DeleteConfirmationDialog(),)),
                  ),
          const SizedBox(height: 80,),
        ],
      ),
    );
  }

  void _checkUserLoggedInAndDo(Function doo) {
    if (isUserNotLoggedIn(context)) return;
    doo();
  }
}
