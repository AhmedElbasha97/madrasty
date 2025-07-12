// ignore_for_file: sized_box_for_whitespace, deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madrasty/UI/privacy_policy/privacy_policy_screen.dart';
import 'package:madrasty/UI/terms_and_condition/terms_and_condition_screen.dart';

import '../../../Utils/Colors_File.dart';
import '../../../Utils/constant.dart';
import '../../../Utils/localization_services.dart';
import '../../../Utils/memory.dart';
import '../../../Utils/services.dart';
import '../../../Utils/translation_key.dart';
import '../../../Widgets/custom_text_widget.dart';
import '../../../Widgets/loading_alert_dialogue.dart';
import '../../../Widgets/text_field_widget.dart';
import 'controller/sign_up_controller.dart';

class DetectPhoneNumberScreen extends StatelessWidget {
  const DetectPhoneNumberScreen({super.key});

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
                    key: controller.formKey,
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
                            height: 30,
                          ),
                          PopupMenuButton<String>(
                            constraints: BoxConstraints(
                              maxWidth: Get.width * 0.45,
                              minWidth: Get.width * 0.45,
                            ),
                            itemBuilder: (context) =>
                                controller.userType.map((e) {
                                  return PopupMenuItem(
                                    value: e,
                                    textStyle: TextStyle(
                                        color: kDarkBlueColor,
                                        fontFamily: Get.find<StorageService>()
                                            .activeLocale ==
                                            SupportedLocales.english
                                            ? fontFamilyEnglishName
                                            : fontFamilyArabicName,
                                        fontWeight: FontWeight.w700),
                                    onTap: () {
                                      controller.chooseUserType(e);
                                    },
                                    child: SizedBox(
                                      width: Get.width * 0.45,
                                      child: Column(
                                        children: [
                                          CustomText(
                                            e,
                                            style: TextStyle(
                                                color: kLightBlueColor,
                                                fontFamily:
                                                Get.find<StorageService>()
                                                    .activeLocale ==
                                                    SupportedLocales.english
                                                    ? fontFamilyEnglishName
                                                    : fontFamilyArabicName,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          e == controller.userType.last
                                              ? const SizedBox()
                                              : const Divider(
                                            color: kLightBlueColor,
                                            height: 1,
                                            thickness: 1,
                                            endIndent: 0,
                                            indent: 0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                            color: kDarkBlueColor,
                            child: Padding(
                              padding:
                              const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                              child: Container(
                                constraints: BoxConstraints(
                                  minHeight: Get.height * 0.04,
                                ),
                                width: Get.width * 0.45,
                                decoration: BoxDecoration(
                                  color: kLightBlueColor,
                                  borderRadius: BorderRadius.circular(10), //
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        8.0, 0, 8.0, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: Get.width * 0.34,
                                          child: CustomText(
                                            textAlign: TextAlign.center,
                                            maxLines: 3,
                                            controller.chosenUserType,

                                            style: TextStyle(
                                              shadows: <Shadow>[
                                                Shadow(
                                                    offset:
                                                    const Offset(0.5, 0.5),
                                                    blurRadius: 0.5,
                                                    color: Colors.black
                                                        .withOpacity(0.5)),
                                              ],
                                              fontSize: 15,
                                              letterSpacing: 0,
                                              fontFamily:
                                              Get.find<StorageService>()
                                                  .activeLocale ==
                                                  SupportedLocales
                                                      .english
                                                  ? fontFamilyEnglishName
                                                  : fontFamilyArabicName,
                                              color: kDarkBlueColor,
                                            ),
                                          ),
                                        ),
                                        const Icon(Icons.arrow_downward_sharp,
                                            color: kBlueColor, size: 20),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
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
                                        textAligning: Get.find<StorageService>()
                                            .activeLocale ==
                                            SupportedLocales.english
                                            ? TextAlign.left
                                            : TextAlign.right,
                                        hasborder: false,
                                        labelText: signUpTitlePhone.tr,
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.number,
                                        iconOfTextField: const Icon(Icons.phone,
                                            color: kBlueColor),
                                        controller: controller.phoneController,
                                        onchange:
                                        controller.onPhoneNumberUpdate,
                                        validator:
                                        controller.validatePhoneNumber,
                                        icon: (controller.phoneValidated)
                                            ? (controller.phoneState)
                                            ?  InkWell(
                                          onTap: (){
                                            controller. choosingCountryCode( context);
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl:"${Services.baseUrl}${controller.selectedCountryCode?.flag}",
                                                imageBuilder: ((context, image) {
                                                  return Container(
                                                      height: Get.height * 0.04,
                                                      width: Get.width * 0.07,

                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),

                                                        image: DecorationImage(
                                                          image: image,
                                                          fit: BoxFit.fitWidth,
                                                        ),
                                                      ));
                                                }),
                                                placeholder: (context, image) {
                                                  return Padding(
                                                    padding: const EdgeInsets.all(5),
                                                    child: Container(
                                                        height: Get.height * 0.04,
                                                        width: Get.width * 0.07,
                                                        decoration: const BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15))),
                                                        child:const CircularProgressIndicator(
                                                          color: kBlueColor,
                                                        )),
                                                  );
                                                },
                                                errorWidget: (context, url, error) {
                                                  return Container(
                                                      height: Get.height * 0.04,
                                                      width: Get.width * 0.07,

                                                      decoration: const BoxDecoration(

                                                          image: DecorationImage(
                                                            image: AssetImage(
                                                                "assets/images/27002.jpg"),
                                                            fit: BoxFit.fitWidth,
                                                          ),
                                                          borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))));
                                                },
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              CustomText(
                                                "   ${controller.selectedCountryCode?.code??"wait"}    ",
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontFamily: Get.find<
                                                      StorageService>()
                                                      .activeLocale ==
                                                      SupportedLocales
                                                          .english
                                                      ? fontFamilyEnglishName
                                                      : fontFamilyArabicName,
                                                  color: kBlueColor,
                                                ),
                                              ),
                                              const Icon(
                                                  Icons.check_rounded,
                                                  color: kSuccessColor),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                            ],
                                          ),
                                        )
                                            : InkWell(
                                          onTap: (){
                                            controller. choosingCountryCode( context);
                                          },
                                          child: (controller.isFoundCountry)?Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl:"${Services.baseUrl}${controller.selectedCountryCode?.flag}",
                                                imageBuilder: ((context, image) {
                                                  return Container(
                                                      height: Get.height * 0.04,
                                                      width: Get.width * 0.07,

                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),

                                                        image: DecorationImage(
                                                          image: image,
                                                          fit: BoxFit.fitWidth,
                                                        ),
                                                      ));
                                                }),
                                                placeholder: (context, image) {
                                                  return Padding(
                                                    padding: const EdgeInsets.all(5),
                                                    child: Container(
                                                        height: Get.height * 0.04,
                                                        width: Get.width * 0.07,
                                                        decoration: const BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15))),
                                                        child:const CircularProgressIndicator(
                                                          color: kBlueColor,
                                                        )),
                                                  );
                                                },
                                                errorWidget: (context, url, error) {
                                                  return Container(
                                                      height: Get.height * 0.04,
                                                      width: Get.width * 0.07,

                                                      decoration: const BoxDecoration(

                                                          image: DecorationImage(
                                                            image: AssetImage(
                                                                "assets/images/27002.jpg"),
                                                            fit: BoxFit.fitWidth,
                                                          ),
                                                          borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))));
                                                },
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),

                                              CustomText(
                                                "   ${controller.selectedCountryCode?.code??"wait"}    ",
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontFamily: Get.find<
                                                      StorageService>()
                                                      .activeLocale ==
                                                      SupportedLocales
                                                          .english
                                                      ? fontFamilyEnglishName
                                                      : fontFamilyArabicName,
                                                  color: kBlueColor,
                                                ),
                                              ),
                                              const Icon(
                                                Icons.close_outlined,
                                                color: kErrorColor,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                            ],
                                          ):Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(Icons.warning_amber,color: kDarkBlueColor,),
                                              const SizedBox(
                                                width: 5,
                                              ),

                                              CustomText(
                                                "choose",
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontFamily: Get.find<
                                                      StorageService>()
                                                      .activeLocale ==
                                                      SupportedLocales
                                                          .english
                                                      ? fontFamilyEnglishName
                                                      : fontFamilyArabicName,
                                                  color: kBlueColor,
                                                ),
                                              ),

                                              const SizedBox(
                                                width: 5,
                                              ),
                                            ],
                                          ),
                                        )
                                            :  InkWell(
                                          onTap: (){
                                            controller. choosingCountryCode( context);
                                          },
                                          child:(controller.isFoundCountry)? Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl:"${Services.baseUrl}${controller.selectedCountryCode?.flag}",
                                                imageBuilder: ((context, image) {
                                                  return Container(
                                                      height: Get.height * 0.04,
                                                      width: Get.width * 0.07,

                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),

                                                        image: DecorationImage(
                                                          image: image,
                                                          fit: BoxFit.fitWidth,
                                                        ),
                                                      ));
                                                }),
                                                placeholder: (context, image) {
                                                  return Padding(
                                                    padding: const EdgeInsets.all(5),
                                                    child: Container(
                                                        height: Get.height * 0.04,
                                                        width: Get.width * 0.07,
                                                        decoration: const BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15))),
                                                        child:const CircularProgressIndicator(
                                                          color: kBlueColor,
                                                        )),
                                                  );
                                                },
                                                errorWidget: (context, url, error) {
                                                  return Container(
                                                      height: Get.height * 0.04,
                                                      width: Get.width * 0.07,

                                                      decoration: const BoxDecoration(

                                                          image: DecorationImage(
                                                            image: AssetImage(
                                                                "assets/images/27002.jpg"),
                                                            fit: BoxFit.fitWidth,
                                                          ),
                                                          borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))));
                                                },
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              CustomText(
                                                "   ${controller.selectedCountryCode?.code??"wait"}    ",
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontFamily: Get.find<
                                                      StorageService>()
                                                      .activeLocale ==
                                                      SupportedLocales
                                                          .english
                                                      ? fontFamilyEnglishName
                                                      : fontFamilyArabicName,
                                                  color: kBlueColor,
                                                ),
                                              ),
                                            ],
                                          ):Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(Icons.warning_amber,color: kDarkBlueColor,),
                                              const SizedBox(
                                                width: 5,
                                              ),

                                              CustomText(
                                                "choose",
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontFamily: Get.find<
                                                      StorageService>()
                                                      .activeLocale ==
                                                      SupportedLocales
                                                          .english
                                                      ? fontFamilyEnglishName
                                                      : fontFamilyArabicName,
                                                  color: kBlueColor,
                                                ),
                                              ),

                                              const SizedBox(
                                                width: 5,
                                              ),
                                            ],
                                          ),
                                        ),
                                        hasGreenBorder: false, isPhoneNumber: true,
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: Get.width*0.9,
                            child: Center(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    const WidgetSpan(
                                    child: Icon(Icons.warning, size: 14,color: kDarkBlueColor,),
                                  ),

                                    TextSpan(
                                      text: detectPhoneNumberText.tr,

                                      style: TextStyle(

                                          fontFamily: Get.find<StorageService>()
                                              .activeLocale ==
                                              SupportedLocales.english
                                              ? fontFamilyEnglishName
                                              : fontFamilyArabicName,
                                          color: kGrayColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Radio(
                                value: 1,
                                fillColor: MaterialStateProperty.all<Color>(
                                    kDarkBlueColor),
                                groupValue: controller.val,
                                onChanged: (value) {
                                  controller.changeValueOfRadioBTN(
                                      value, context);
                                },
                                toggleable: true,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    readAppPolicyAndTerms.tr,
                                    style: TextStyle(
                                        fontFamily: Get.find<StorageService>()
                                            .activeLocale ==
                                            SupportedLocales.english
                                            ? fontFamilyEnglishName
                                            : fontFamilyArabicName,
                                        color: kGrayColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Get.to(()=>const PrivacyPolicyScreen());
                                        },
                                        child: Text(
                                          privacyPolicy.tr,
                                          style: TextStyle(
                                              fontFamily:
                                              Get.find<StorageService>()
                                                  .activeLocale ==
                                                  SupportedLocales
                                                      .english
                                                  ? fontFamilyEnglishName
                                                  : fontFamilyArabicName,
                                              color: kDarkBlueColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15),
                                        ),
                                      ),
                                      Text(
                                        and.tr,
                                        style: TextStyle(
                                            fontFamily:
                                            Get.find<StorageService>()
                                                .activeLocale ==
                                                SupportedLocales.english
                                                ? fontFamilyEnglishName
                                                : fontFamilyArabicName,
                                            color: kGrayColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15),
                                      ),

                                    ],
                                  ),InkWell(
                                    onTap: () {
                                      Get.to(()=>const TermsAndConditionScreen());

                                    },
                                    child: Text(
                                      termsAndCondition.tr,
                                      style: TextStyle(
                                          fontFamily:
                                          Get.find<StorageService>()
                                              .activeLocale ==
                                              SupportedLocales
                                                  .english
                                              ? fontFamilyEnglishName
                                              : fontFamilyArabicName,
                                          color: kDarkBlueColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            width: Get.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  signUpText1.tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: Get.find<StorageService>()
                                          .activeLocale ==
                                          SupportedLocales.english
                                          ? fontFamilyEnglishName
                                          : fontFamilyArabicName,
                                      color: kGrayColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: CustomText(
                                    signInBTN.tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: Get.find<StorageService>()
                                            .activeLocale ==
                                            SupportedLocales.english
                                            ? fontFamilyEnglishName
                                            : fontFamilyArabicName,
                                        color: kDarkBlueColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              if(controller.isLoading){
                                showDialog(context: context,
                                    builder: (context) {
                                      return const LoadingAlertDialogue();
                                    });
                              }else{
                                controller.sendPressed(context);
                              }

                              
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
                                        detectPhoneNumberBTN.tr,
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
