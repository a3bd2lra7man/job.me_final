import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:job_me/_main/ui/splash_screen.dart';
import 'package:job_me/_utils/localizations/app_localization.dart';
import 'package:job_me/_utils/localizations/localization_proivder.dart';
import 'package:provider/provider.dart';
// import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await LocalizationProvider.init();
  runApp(MyApp.init());
}

class MyApp extends StatelessWidget {
  static Widget init() {
    return ChangeNotifierProvider(
      create: (_) => LocalizationProvider(),
      child: const MyApp._(),
    );
  }

  const MyApp._();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var localizationProvider = context.watch<LocalizationProvider>();
    return GetMaterialApp(
      navigatorObservers: [routeObserver],
      locale: Locale(localizationProvider.locale),
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      debugShowCheckedModeBanner: false,
      title: 'Job.Me',
      localizationsDelegates: const [...GlobalMaterialLocalizations.delegates, AppLocalizations.delegate],
      home: const SplashScreen(),
    );
  }
}
