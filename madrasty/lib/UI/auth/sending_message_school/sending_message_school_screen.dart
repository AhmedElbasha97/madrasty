// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madrasty/Utils/Colors_File.dart';

import '../../../Models/school_model.dart';
import '../../../Utils/constant.dart';
import '../../../Utils/localization_services.dart';
import '../../../Utils/memory.dart';
import '../../../Widgets/custom_text_widget.dart';
import '../../../Widgets/loading_alert_dialogue.dart';
import 'controller/sending_message_school_controller.dart';

class SendingMessageSchoolScreen extends StatelessWidget {

  const SendingMessageSchoolScreen({super.key, required this.phoneNumber});
 final String phoneNumber;
  @override
  Widget build(BuildContext context) {
    return  GetBuilder(
      init: SendingMessageSchoolController(phoneNumber),
      builder: (SendingMessageSchoolController controller) => SafeArea(
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
                              SizedBox(height: Get.height*0.005,),
                              CustomText(
                                "أرسال رساله للمدرسه",
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
                              SizedBox(height: Get.height*0.005,),
                              PopupMenuButton<SchoolModel>(
                                constraints: BoxConstraints(
                                  maxWidth: Get.width * 0.8,
                                  minWidth: Get.width * 0.8,
                                ),
                                itemBuilder: (context) =>
                                    controller.schoolsListData!.map((e) {
                                      return PopupMenuItem(
                                        value: e,
                                        textStyle: TextStyle(
                                            color: kDarkBlueColor,
                                            fontFamily:
                                            Get.find<StorageService>().activeLocale ==
                                                SupportedLocales.english
                                                ? fontFamilyEnglishName
                                                : fontFamilyArabicName,
                                            fontWeight: FontWeight.w700),
                                        onTap: () {
                                          controller.selectingSchool(e);
                                        },
                                        child: SizedBox(
                                          width: Get.width * 0.8,
                                          child: Column(
                                            children: [
                                              CustomText(
                                                e.name??"",
                                                style: TextStyle(
                                                    color: kWhiteColor,
                                                    fontFamily: Get.find<StorageService>()
                                                        .activeLocale ==
                                                        SupportedLocales.english
                                                        ? fontFamilyEnglishName
                                                        : fontFamilyArabicName,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              e == controller.schoolsListData?.last
                                                  ? const SizedBox()
                                                  :  Divider(
                                                color: kDarkBlueColor.withValues(alpha:0.5),
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
                                  padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 0),
                                  child:Container(
                                    height: Get.height * 0.1,
                                    width: Get.width * 0.8,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      image: const DecorationImage(
                                          image: AssetImage(
                                              "assets/images/backgroundImage.png"),
                                          fit: BoxFit.cover),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        constraints: BoxConstraints(
                                          minHeight: Get.height * 0.06,
                                        ),
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
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  width: Get.width * 0.6,
                                                  child: CustomText(
                                                    textAlign: TextAlign.center,
                                                    maxLines: 3,
                                                    controller.selectedSchool==null?Get.find<StorageService>()
                                                        .activeLocale ==
                                                        SupportedLocales.english
                                                        ?"Select school":"أختر المدرسه":controller.selectedSchool?.name??"",
                                                    style: TextStyle(
                                                      shadows: <Shadow>[
                                                        Shadow(
                                                            offset:
                                                            const Offset(0.5, 0.5),
                                                            blurRadius: 0.5,
                                                            color: Colors.black
                                                                .withValues(alpha:0.5)),
                                                      ],
                                                      fontSize: 13,
                                                      letterSpacing: 0,
                                                      fontFamily:
                                                      Get.find<StorageService>()
                                                          .activeLocale ==
                                                          SupportedLocales.english
                                                          ? fontFamilyEnglishName
                                                          : fontFamilyArabicName,
                                                      color: kWhiteColor,
                                                    ),
                                                  ),
                                                ),
                                                const Icon(Icons.arrow_downward_sharp,
                                                    color: kWhiteColor, size: 20),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              Column(
                                children: [

                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                    child: CustomText(
                                      "أختر المدرسه التى تريد رساله لها لكى تقوم بتسجيلك",
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
                                      maxLines: 4,
                                      focusNode: controller.text1FocusNode,
                                      controller: controller.textController1,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      keyboardType: TextInputType.text,

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
                                        hintText: "أدخال الرساله التى تريد أرسالها",
                                        hintStyle: TextStyle(
                                            fontFamily:
                                            Get.find<StorageService>().activeLocale ==
                                                SupportedLocales.english
                                                ? fontFamilyEnglishName
                                                : fontFamilyArabicName,
                                            color: kGrayColor,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15),
                                        contentPadding: const EdgeInsets.only(right: 10,bottom: 10),
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

                                ],
                              ),


                              InkWell(
                                onTap: () {
                                  if(controller.isLoading){
                                  showDialog(context: context,
                                  builder: (context) {
                                  return const LoadingAlertDialogue();
                                  });
                                  }else{
                                    controller.sendingMessage(context);}

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
                                          "أرسال رساله للمدرسه",
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
