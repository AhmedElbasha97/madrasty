// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Utils/Colors_File.dart';
import '../../../Utils/constant.dart';
import '../../../Utils/localization_services.dart';
import '../../../Utils/memory.dart';
import '../../../Utils/translation_key.dart';
import '../../../Widgets/custom_text_widget.dart';
import '../../../Widgets/text_field_widget.dart';
import 'controller/sign_up_controller.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: SignUpController(),
      builder: (SignUpController controller) => SafeArea(
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
                    key: controller.formKey1,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
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
                          const SizedBox(
                            height: 10,
                          ),

                          Center(
                            child: CustomText(
                              "${completeUserDataText1.tr} ${ Get.find<StorageService>().getUserName}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily:
                                  Get.find<StorageService>()
                                      .activeLocale ==
                                      SupportedLocales.english
                                      ? fontFamilyEnglishName
                                      : fontFamilyArabicName,
                                  color: kDarkBlueColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Center(
                            child: CustomText(
                              "${completeUserDataText2.tr}${ Get.find<StorageService>().getUserType}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily:
                                  Get.find<StorageService>()
                                      .activeLocale ==
                                      SupportedLocales.english
                                      ? fontFamilyEnglishName
                                      : fontFamilyArabicName,
                                  color: kDarkBlueColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          Container(
                            width: Get.width * 0.8,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    color: kGrayColor,
                                    blurRadius: 2,
                                    offset: Offset(1, 1), // Shadow position
                                  ),
                                ],
                                border: Border.all(
                                    color: kDarkBlueColor, width: 1)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: Get.height * 0.07,
                                      width: Get.width * 0.95,
                                      child: CustomInputField(
                                          textAligning:
                                              Get.find<StorageService>()
                                                          .activeLocale ==
                                                      SupportedLocales.english
                                                  ? TextAlign.left
                                                  : TextAlign.right,
                                          hasborder: true,
                                          labelText: signUpTitlePass.tr,
                                          onchange: controller.onpPassUpdate,
                                          textInputAction: TextInputAction.next,
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          iconOfTextField: const Icon(
                                              Icons.password,
                                              color: kBlueColor),
                                          hasGreenBorder: false,
                                          controller:
                                              controller.passwordController,
                                          validator:
                                              controller.validatePassword,
                                          obsecure: !controller.visiblePsd,
                                          icon: IconButton(
                                            // Based on passwordVisible state choose the icon
                                            icon: SizedBox(
                                              width: Get.width*0.1,
                                              child: Row(
                                                children: [
                                                  Icon(
                                                      (controller.passValidated)
                                                          ? (controller.passState)
                                                          ?Icons.check_rounded:Icons.close_outlined:Icons.close_outlined,
                                                      color: (controller.passValidated)
                                                          ? (controller.passState)
                                                          ?kBlueColor:kErrorColor:Colors.white),

                                                  Icon(
                                                    controller.visiblePsd
                                                        ? Icons.visibility
                                                        : Icons.visibility_off,
                                                    color: kLightGrayColor,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            onPressed: () {
                                              controller.toggleVisiblePsd();
                                            },
                                          ), isPhoneNumber: false,),
                                    ),
                                    SizedBox(
                                      height: Get.height * 0.07,
                                      width: Get.width * 0.95,
                                      child: CustomInputField(
                                          isPhoneNumber: false,
                                          textAligning:
                                              Get.find<StorageService>()
                                                          .activeLocale ==
                                                      SupportedLocales.english
                                                  ? TextAlign.left
                                                  : TextAlign.right,
                                          hasborder: false,
                                          labelText: signUpTitleConfirmPass.tr,
                                          iconOfTextField: const Icon(
                                              Icons.password,
                                              color: kBlueColor),
                                          textInputAction: TextInputAction.done,
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          hasGreenBorder: false,
                                          controller: controller
                                              .reTypePasswordController,
                                          validator:
                                              controller.validateReTypePassword,

                                          onchange: controller.onpReTypePassUpdate,
                                          obsecure: !controller.visiblePsd,
                                          icon: IconButton(
                                            // Based on passwordVisible state choose the icon
                                            icon: SizedBox(
                                              width: Get.width*0.1,
                                              child: Row(
                                                children: [
                                                  Icon(
                                                      (controller.reTypePasswordValidated)
                                                          ? (controller.reTypePasswordState)
                                                          ?Icons.check_rounded:Icons.close_outlined:Icons.close_outlined,
                                                      color: (controller.reTypePasswordValidated)
                                                          ? (controller.reTypePasswordState)
                                                          ?kBlueColor:kErrorColor:Colors.white),

                                                  Icon(
                                                    controller.visiblePsd
                                                        ? Icons.visibility
                                                        : Icons.visibility_off,
                                                    color: kLightGrayColor,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            onPressed: () {
                                              controller.toggleVisiblePsd();
                                            },
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),


                          InkWell(
                            onTap: () {

                              controller.sendPressed1(context);
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
                                        completeUserDataBTN.tr,
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
                        ],
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
