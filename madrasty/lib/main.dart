// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:madrasty/Utils/Colors_File.dart';
import 'UI/splash_screen/splash_screen.dart';
import 'Utils/connection_service.dart';
import 'Utils/localization_services.dart';
import 'Utils/memory.dart';
import 'Utils/transelation/app_transelation.dart';


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Get.putAsync(() => StorageService.init(), permanent: true);
  Get.put(LocalizationService.init(), permanent: true);
  await Get.putAsync(() => ConnectionService.init(), permanent: true);

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);



  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: kYellowColor, // navigation bar color
    statusBarColor: kBlueColor, // status bar color
  ));
  runApp( const MyApp());

}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: AppTranslations(),



      locale:  Get.find<LocalizationService>().activeLocale,
      supportedLocales: SupportedLocales.all,
      fallbackLocale: SupportedLocales.english,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),

    );
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
