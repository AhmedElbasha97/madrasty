// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../Utils/Colors_File.dart';
import '../../../Utils/constant.dart';
import '../../../Utils/localization_services.dart';
import '../../../Utils/memory.dart';
import '../../../Utils/translation_key.dart';
import '../../../Widgets/custom_text_widget.dart';
import 'controller/otp_controller.dart';

class OtpScreen extends StatelessWidget {
  final  bool comingFromSignUp;
  final  bool comingFromForgetPassword;

  const OtpScreen({super.key, required this.comingFromSignUp, required this.comingFromForgetPassword});

  @override
  Widget build(BuildContext context) {
    return  GetBuilder(
      init: OTPController(comingFromSignUp,comingFromForgetPassword),
      builder: (OTPController controller) => SafeArea(
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
                  child: Form(
                    key: controller.formKey,
                    child:  SingleChildScrollView(
                      child: Container(
                        height: Get.height * 0.9,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [

                            SizedBox(
                              height: Get.height * 0.15,
                              width: Get.width * 0.6,
                              child: Image.asset(
                                Get.find<StorageService>().activeLocale ==
                                    SupportedLocales.english
                                    ? "assets/images/appMultiColorLogoEnWithoutbackground.png"
                                    : "assets/images/appMultiColorLogoArWithoutbackground.png",
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            Column(
                              children: [
                                CustomText(
                                  "رمز التحقيق",
                                  style: TextStyle(
                                      fontFamily:
                                      Get.find<StorageService>().activeLocale ==
                                          SupportedLocales.english
                                          ? fontFamilyEnglishName
                                          : fontFamilyArabicName,
                                      color: kBlueColor,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20),
                                ),
                                SizedBox(height: Get.height*0.04,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                  child: CustomText(
                                    "تم إرسال رمز التحقق لرقم الجوال الذى تم تسجيل سابقا",
                                    style: TextStyle(
                                        fontFamily:
                                        Get.find<StorageService>().activeLocale ==
                                            SupportedLocales.english
                                            ? fontFamilyEnglishName
                                            : fontFamilyArabicName,
                                        color: kGrayColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(height: Get.height*0.04,),
                                SizedBox(
                                  width: Get.width*0.7,
                                  height: Get.height * 0.15,
                                  child: TextFormField(

                                    focusNode: controller.text1FocusNode,
                                    controller: controller.textController1,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ], // Only numbers can be entered
                                    maxLength: 6,
                                    textAlign: Get.find<StorageService>()
                                        .activeLocale ==
                                        SupportedLocales.english
                                        ? TextAlign.left
                                        : TextAlign.right,

                                    style:  TextStyle(
                                      fontSize: 15.0,
                                      fontFamily: Get.find<StorageService>().activeLocale == SupportedLocales.english?fontFamilyEnglishName:fontFamilyArabicName,
                                      color: kGrayColor,
                                    ),
                                    cursorColor: kGrayColor,
                                    decoration: InputDecoration(
                                      hintText: textOfOTPTextField.tr,
                                      hintStyle: TextStyle(
                                          fontFamily:
                                          Get.find<StorageService>().activeLocale ==
                                              SupportedLocales.english
                                              ? fontFamilyEnglishName
                                              : fontFamilyArabicName,
                                          color: kGrayColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15),
                                      contentPadding: const EdgeInsets.only(right: 10,bottom: -10),
                                      counterText: '',
                                      isDense: false,
                                      fillColor: Colors.white,
                                      filled: true,
                                      labelStyle:TextStyle(
                                        fontSize: 15.0,
                                        fontFamily: Get.find<StorageService>().activeLocale == SupportedLocales.english?fontFamilyEnglishName:fontFamilyArabicName,
                                        color: kGrayColor,
                                      ),
                                      suffixStyle:  TextStyle(
                                        fontSize: 15.0,
                                        fontFamily: Get.find<StorageService>().activeLocale == SupportedLocales.english?fontFamilyEnglishName:fontFamilyArabicName,
                                        color: kGrayColor,
                                      ),
                                      border:  UnderlineInputBorder(
                                          borderSide: const BorderSide(width: 1, color:kLightGrayColor,),
                                          borderRadius: BorderRadius.circular(0)
                                      ),
                                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                                      errorBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(width: 3,color: Colors.red),
                                          borderRadius: BorderRadius.circular(10)),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(width: 3,color: Colors.red),
                                          borderRadius: BorderRadius.circular(10)),
                                      enabledBorder:   OutlineInputBorder(
                                          borderSide:  const BorderSide(width: 3, color:kBlueColor,),
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:  const BorderSide(width: 3, color:kBlueColor,),
                                          borderRadius: BorderRadius.circular(10)),
                                    ),

                                  ),
                                ),

                                InkWell(
                                  onTap: (){
                                    controller.getBackToAnotherScreen( context);
                                  },
                                  child: Container(
                                    width: Get.width*0.9,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.keyboard_return_sharp,color: kDarkBlueColor,),
                                        const SizedBox(width: 10,),
                                        CustomText(
                                          textOfOTPBTNGoBack.tr,
                                          style: TextStyle(
                                              fontFamily:
                                              Get.find<StorageService>().activeLocale ==
                                                  SupportedLocales.english
                                                  ? fontFamilyEnglishName
                                                  : fontFamilyArabicName,
                                              color: kDarkBlueColor,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),


                            InkWell(
                              onTap: () {
                               controller.checkOtp(context);
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
                                            offset:
                                            Offset(1, 1), // Shadow position
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: CustomText(
                                          textOfOTPBTN.tr,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily:
                                              Get.find<StorageService>()
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
                          ]
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
