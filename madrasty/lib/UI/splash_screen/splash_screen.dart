import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madrasty/UI/auth/otp_screen/otp_screen.dart';
import 'package:madrasty/UI/auth/sign_up/sign_up_screen.dart';
import 'package:madrasty/Utils/Colors_File.dart';

import '../../Utils/constant.dart';
import '../../Utils/localization_services.dart';
import '../../Utils/memory.dart';
import '../../Widgets/custom_text_widget.dart';
import '../home_screen/home_screen.dart';
import '../welcome_screen/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>  with TickerProviderStateMixin {

  late Animation<double> imgAnimation;
  late AnimationController imgAnimationController;
  late Animation<double> txtAnimation;
  late AnimationController txtAnimationController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    const quickForImg = Duration(milliseconds: 1000);
    final scaleTweenForImg = Tween(begin: 0.0, end: 1.0);
    const quickForTxt = Duration(milliseconds: 1000);
    final scaleTweenForTxt = Tween(begin: 0.0, end: 1.0);
    imgAnimationController = AnimationController(duration: quickForImg, vsync: this);
    imgAnimation = scaleTweenForImg.animate(
      CurvedAnimation(
        parent: imgAnimationController,
        curve: Curves.fastLinearToSlowEaseIn,
      ),
    )..addListener(() {
      setState(() => imgScale = imgAnimation.value);
    });
    txtAnimationController = AnimationController(duration: quickForTxt, vsync: this);
    txtAnimation = scaleTweenForTxt.animate(
      CurvedAnimation(
        parent: txtAnimationController,
        curve: Curves.fastLinearToSlowEaseIn,
      ),
    )..addListener(() {
      setState(() => txtScale = txtAnimation.value);
    });
    _imgAnimate();
  }
  @override
  void dispose() {
    imgAnimationController.dispose();
    txtAnimationController.dispose();
    super.dispose();
  }

  void _imgAnimate() {

    imgAnimationController.forward().then((e){
      _txtAnimate();
    });
  }
  void _txtAnimate() {

    txtAnimationController.forward().then((e){
      navigateToNextScreen();
    });
  }
navigateToNextScreen() {
  if (Get
      .find<StorageService>()
      .checkUserHasOtpAlready) {
    Get.offAll(() =>
        OtpScreen(comingFromSignUp: Get
            .find<StorageService>()
            .getCheckerSigningUp,
          comingFromForgetPassword:  Get
              .find<StorageService>()
              .getCheckerForgettingPassword,));
  } else if (Get
      .find<StorageService>()
      .checkCompleteHisData) {
    Get.offAll(() => const SignUpScreen());
  } else {
    if (Get
        .find<StorageService>()
        .getId != "0") {
      Get.offAll(() => const HomeScreen());
    } else {
      Get.offAll(() => const WelcomeScreen());
    }
  }
}
  double imgScale = 0.0;
  double txtScale = 0.0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: Get.height,
          width: Get.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/backgroundImage.png"),
                fit: BoxFit.cover),
          ),
          child: Center(
            child: Container(
              height: Get.height * 0.8,
              width: Get.width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: kLightBlueColor,
                boxShadow: const [
                  BoxShadow(
                    color: kGrayColor,
                    blurRadius: 2,
                    offset: Offset(1, 1), // Shadow position
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.scale(
                      scale: imgScale,
                      child: SizedBox(
                        height: Get.height * 0.25,
                        width: Get.width * 0.6,
                        child: Image.asset(
                          Get.find<StorageService>().activeLocale ==
                                  SupportedLocales.english
                              ? "assets/images/appMultiColorLogoEnWithoutbackground.png"
                              : "assets/images/appMultiColorLogoArWithoutbackground.png",
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    Transform.scale(
                      scale: txtScale,
                      child: CustomText(
                        textAlign: TextAlign.start,
                        maxLines: 3,
                        Get.find<StorageService>().activeLocale ==
                            SupportedLocales.english
                            ?"day":'تجربه جديده فى عالم التعلم',
                        style: TextStyle(

                          fontSize: 20,
                          letterSpacing: 0,
                          fontFamily:
                          Get.find<StorageService>().activeLocale ==
                              SupportedLocales.english
                              ? fontFamilyEnglishName
                              : fontFamilyArabicName,
                          fontWeight: FontWeight.w900,
                          color: kBlueColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
