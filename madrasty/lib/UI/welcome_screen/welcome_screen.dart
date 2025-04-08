import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madrasty/UI/auth/otp_screen/controller/otp_controller.dart';
import 'package:madrasty/UI/school_list/school_list_screen.dart';
import '../../Utils/Colors_File.dart';
import '../../Utils/constant.dart';
import '../../Utils/localization_services.dart';
import '../../Utils/memory.dart';
import '../../Utils/translation_key.dart';
import '../../Widgets/custom_text_widget.dart';
import '../auth/sign_in/sign_in_screen.dart';
import '../auth/sign_up/detect_phone_number_screen.dart';


class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

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
              height: Get.height * 0.9,
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
                  children: [

                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: (){
                          Get.to(()=>const SchoolListScreen());
                          },
                          child:  Row(
                            children: [
                              Container(

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  image: const DecorationImage(
                                      image: AssetImage(
                                          "assets/images/backgroundImage.png"),
                                      fit: BoxFit.cover),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(

                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: kDarkBlueColor,
                                        boxShadow: const [
                                          BoxShadow(
                                            color: kGrayColor,
                                            blurRadius: 2,
                                            offset: Offset(1, 1), // Shadow position
                                          ),
                                        ],
                                      ),
                                      child: const Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Icon(Icons.home,color: Colors.white,size: 15,),
                                          )
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              CustomText(skipToHomeBTN.tr,
                                textAlign: TextAlign.center,
                                style:  TextStyle(
                                    fontFamily: Get.find<StorageService>()
                                    .activeLocale ==
                                    SupportedLocales.english
                                    ? fontFamilyEnglishName
                                    : fontFamilyArabicName,
                                    color: kDarkBlueColor,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13),),


                            ],
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            Get.find<LocalizationService>().toggleLocale();

                            Get.offAll(const WelcomeScreen());
                          },
                          child:  Row(
                            children: [

                              CustomText(languageWelcomeBTN.tr,
                                textAlign: TextAlign.center,
                                style:  TextStyle(
                                    fontFamily: Get.find<StorageService>()
                                    .activeLocale ==
                                    SupportedLocales.english
                                    ? fontFamilyEnglishName
                                    : fontFamilyArabicName,
                                    color: kDarkBlueColor,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15),),
                              const SizedBox(width: 10,),
                              Container(

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  image: const DecorationImage(
                                      image: AssetImage(
                                          "assets/images/backgroundImage.png"),
                                      fit: BoxFit.cover),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(

                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: kDarkBlueColor,
                                        boxShadow: const [
                                          BoxShadow(
                                            color: kGrayColor,
                                            blurRadius: 2,
                                            offset: Offset(1, 1), // Shadow position
                                          ),
                                        ],
                                      ),
                                      child: const Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Icon(Icons.translate,color: Colors.white,size: 15,),
                                          )
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Get.height * 0.1,
                    ),
                    SizedBox(
                      height: Get.height * 0.25,
                      width: Get.width * 0.7,
                      child: Image.asset(
                        Get.find<StorageService>().activeLocale ==
                                SupportedLocales.english
                            ? "assets/images/appMultiColorLogoEnWithoutbackground.png"
                            : "assets/images/appMultiColorLogoArWithoutbackground.png",
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.2,
                    ),
                    InkWell(
                      onTap: () {
                        bool test4 = Get.isRegistered<OTPController>();
                        if(test4){
                          Get.delete<OTPController>();
                        }
                        Get.to(() => const SignInScreen());
                      },
                      child: Container(
                        height: Get.height * 0.1,
                        width: Get.width * 0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          image: const DecorationImage(
                              image: AssetImage(
                                  "assets/images/backgroundImage.png"),
                              fit: BoxFit.cover),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: Get.height * 0.1,
                              width: Get.width * 0.8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: kDarkBlueColor,
                                boxShadow: const [
                                  BoxShadow(
                                    color: kGrayColor,
                                    blurRadius: 2,
                                    offset: Offset(1, 1), // Shadow position
                                  ),
                                ],
                              ),
                              child: Center(
                                child: CustomText(
                                  signInBTN.tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: Get.find<StorageService>()
                                                  .activeLocale ==
                                              SupportedLocales.english
                                          ? fontFamilyEnglishName
                                          : fontFamilyArabicName,
                                      color: kLightBlueColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        bool test4 = Get.isRegistered<OTPController>();
                        if(test4){
                          Get.delete<OTPController>();
                        }
                         Get.to(() => const DetectPhoneNumberScreen());
                      },
                      child: Container(
                        height: Get.height * 0.1,
                        width: Get.width * 0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          image: const DecorationImage(
                              image: AssetImage(
                                  "assets/images/backgroundImage.png"),
                              fit: BoxFit.cover),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: Get.height * 0.1,
                              width: Get.width * 0.8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: kDarkBlueColor,
                                boxShadow: const [
                                  BoxShadow(
                                    color: kGrayColor,
                                    blurRadius: 2,
                                    offset: Offset(1, 1), // Shadow position
                                  ),
                                ],
                              ),
                              child: Center(
                                child: CustomText(
                                  signUpTitle.tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: Get.find<StorageService>()
                                                  .activeLocale ==
                                              SupportedLocales.english
                                          ? fontFamilyEnglishName
                                          : fontFamilyArabicName,
                                      color: kLightBlueColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18),
                                ),
                              ),
                            ),
                          ),
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
