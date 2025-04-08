// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../../Models/academic_and_behavior_recommendation_reason_model.dart';
import '../../../Models/class_teacher_model.dart';
import '../../../Models/student_model.dart';
import '../../../Utils/Colors_File.dart';
import '../../../Utils/constant.dart';
import '../../../Utils/localization_services.dart';
import '../../../Utils/memory.dart';
import '../../../Widgets/DrawerWidget.dart';
import '../../../Widgets/custom_text_widget.dart';
import '../../../Widgets/loading_alert_dialogue.dart';
import 'controller/add_academic_and_behavior_recommendation_controller.dart';

class AddAcademicAndBehaviorRecommendationScreen extends StatelessWidget {
  const AddAcademicAndBehaviorRecommendationScreen({super.key,});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: AddAcademicAndBehaviorRecommendationController(),
      builder: (AddAcademicAndBehaviorRecommendationController controller) =>
          Scaffold(
            key: controller.scaffoldState,
            drawer: AppDrawers(
              scaffoldKey: controller.scaffoldState,
            ),
            appBar: AppBar(
              actions: [
                const SizedBox(
                  width: 8,
                ),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: Get.height * 0.07,
                      width: Get.width * 0.11,
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
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          )),
                    ),
                  ),
                ),
              ],
              leading: InkWell(
                onTap: () {
                  controller.scaffoldState.currentState!.openDrawer();
                },
                child: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Image.asset(
                    "assets/icons/menu_icon.png",
                    fit: BoxFit.contain,
                    height: MediaQuery.of(context).size.height * 0.04,
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                ),
              ),
              backgroundColor: kYellowColor,
              title: Image.asset(
                "assets/images/appMultiColorLogoWithoutbackground.png",
                fit: BoxFit.fitHeight,
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.3,
              ),
              centerTitle: true,
            ),
            body: SizedBox(
              height: Get.height,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          const SizedBox(height: 10,),
                          CustomText(
                            textAlign: TextAlign.left,
                            maxLines: 3,
                            "${
                                Get.find<StorageService>().activeLocale ==
                                    SupportedLocales.english
                                    ? "type for recommendation"
                                    : "نوع التوصيه"
                            } : ",
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
                              color: kDarkBlueColor,
                            ),
                          ),
                          const SizedBox(height: 10,),
                          PopupMenuButton<String>(
                            constraints: BoxConstraints(
                              maxWidth: Get.width * 0.8,
                              minWidth: Get.width * 0.8,
                            ),
                            itemBuilder: (context) =>
                                controller.typeOfRecommendation.map((e) {
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
                                      controller.selectingTypeForRecommendation(e);
                                    },
                                    child: SizedBox(
                                      width: Get.width * 0.8,
                                      child: Column(
                                        children: [
                                          CustomText(
                                            e,
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
                                          e == controller.typeOfRecommendation.last
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
                                height: Get.height * 0.06,
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
                                            SizedBox(
                                              width: Get.width * 0.6,
                                              child: CustomText(
                                                textAlign: TextAlign.center,
                                                maxLines: 3,
                                                controller.chosenTypeOfRecommendation==""?controller.typeOfRecommendation[0]:controller.chosenTypeOfRecommendation,
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
                        ],
                      ),
                      controller.chosenTypeOfRecommendation==""?const SizedBox():

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          const SizedBox(height: 10,),
                          CustomText(
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            "${
                                Get.find<StorageService>().activeLocale ==
                                    SupportedLocales.english
                                    ? "reason for recommendation"
                                    : "سبب التوصيه"
                            } : ",
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
                              color: kDarkBlueColor,
                            ),
                          ),
                          const SizedBox(height: 10,),
                          controller.isReasonForRecommendationLoading?
                          Column(
                            children: [
                              Container(
                                height: Get.height * 0.06,
                                width: Get.width * 0.8,
                                decoration:  BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),

                                    color: const Color(0xFFDFDDDF)

                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      height: Get.height * 0.05,
                                      width: Get.width * 0.8,
                                      decoration:   BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),

                                        color:  const Color(0xFFDFDDDF),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: kGrayColor,
                                            blurRadius: 2,
                                            offset:
                                            Offset(1, 1), // Shadow position
                                          ),
                                        ],

                                      ),
                                    ),
                                  ),
                                ).animate(onPlay: (controller) => controller.repeat())
                                    .shimmer(duration: 1200.ms, color:  kBlueColor.withAlpha(55))
                                    .animate() // this wraps the previous Animate in another Animate
                                    .fadeIn(duration: 700.ms, curve: Curves.easeOutQuad)
                                    .slide(),
                              ),
                            ],
                          ).animate(onPlay: (controller) => controller.repeat())
                              .shimmer(duration: 1200.ms, color:  kBlueColor.withAlpha(55))
                              .animate() // this wraps the previous Animate in another Animate
                              .fadeIn(duration: 700.ms, curve: Curves.easeOutQuad)
                              .slide():PopupMenuButton<AcademicAndBehaviorRecommendationReasonModel>(
                            constraints: BoxConstraints(
                              maxWidth: Get.width * 0.8,
                              minWidth: Get.width * 0.8,
                            ),
                            itemBuilder: (context) =>
                                controller.reasonsForRecommendation!.map((e) {
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
                                      controller.selectingReasonsForRecommendation(e);
                                    },
                                    child: SizedBox(
                                      width: Get.width * 0.8,
                                      child: Column(
                                        children: [
                                          CustomText(
                                            Get.find<StorageService>()
                                                .activeLocale ==
                                                SupportedLocales.english
                                                ?(e.nameEn??""):(e.name??""),
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
                                          e == controller.reasonsForRecommendation?.last
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
                                height: Get.height * 0.06,
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
                                            SizedBox(
                                              width: Get.width * 0.6,
                                              child: CustomText(
                                                textAlign: TextAlign.center,
                                                maxLines: 3,
                                                controller.chosenReasonsForRecommendation==null?Get.find<StorageService>()
                                                    .activeLocale ==
                                                    SupportedLocales.english
                                                    ?"choose reason for recommendation":"أختر سبب التوصيه":Get.find<StorageService>()
                                                    .activeLocale ==
                                                    SupportedLocales.english
                                                    ?(controller.chosenReasonsForRecommendation?.nameEn??""):(controller.chosenReasonsForRecommendation?.name??""),
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
                        ],
                      ),
                      controller.chosenReasonsForRecommendation==null?const SizedBox():
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10,),
                          CustomText(
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            "${
                                Get.find<StorageService>().activeLocale ==
                                    SupportedLocales.english
                                    ? "education stage"
                                    : "المرحله الدراسيه"
                            } : ",
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
                              color: kDarkBlueColor,
                            ),
                          ),
                          const SizedBox(height: 10,),
                          PopupMenuButton<ClassTeacherModel>(
                            constraints: BoxConstraints(
                              maxWidth: Get.width * 0.8,
                              minWidth: Get.width * 0.8,
                            ),
                            itemBuilder: (context) =>
                                controller.eductionStage!.map((e) {
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
                                      controller.selectingEductionStage(e);
                                    },
                                    child: SizedBox(
                                      width: Get.width * 0.8,
                                      child: Column(
                                        children: [
                                          CustomText(
                                            Get.find<StorageService>()
                                                .activeLocale ==
                                                SupportedLocales.english
                                                ?(e.titleEn??""):(e.title??""),
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
                                          e == controller.eductionStage?.last
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
                                height: Get.height * 0.06,
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
                                            SizedBox(
                                              width: Get.width * 0.6,
                                              child: CustomText(
                                                textAlign: TextAlign.center,
                                                maxLines: 3,
                                                controller.chosenEductionStage==null?Get.find<StorageService>()
                                                    .activeLocale ==
                                                    SupportedLocales.english
                                                    ?"choose education stage":"أختر المرحله الدراسيه":Get.find<StorageService>()
                                                    .activeLocale ==
                                                    SupportedLocales.english
                                                    ?(controller.chosenEductionStage?.titleEn??""):(controller.chosenEductionStage?.title??""),
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
                        ],
                      ),
                      controller.chosenEductionStage==null?const SizedBox():
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10,),
                          CustomText(
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            "${
                                Get.find<StorageService>().activeLocale ==
                                    SupportedLocales.english
                                    ? "Academic year"
                                    : "السنه الدراسيه"
                            } : ",
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
                              color: kDarkBlueColor,
                            ),
                          ),
                          const SizedBox(height: 10,),
                          controller.isSubStageLoading?
                          Column(
                            children: [
                              const SizedBox(height: 10,),
                              Container(
                                height: Get.height * 0.06,
                                width: Get.width * 0.8,
                                decoration:  BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),

                                    color: const Color(0xFFDFDDDF)

                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      height: Get.height * 0.05,
                                      width: Get.width * 0.8,
                                      decoration:   BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),

                                        color:  const Color(0xFFDFDDDF),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: kGrayColor,
                                            blurRadius: 2,
                                            offset:
                                            Offset(1, 1), // Shadow position
                                          ),
                                        ],

                                      ),
                                    ),
                                  ),
                                ).animate(onPlay: (controller) => controller.repeat())
                                    .shimmer(duration: 1200.ms, color:  kBlueColor.withAlpha(55))
                                    .animate() // this wraps the previous Animate in another Animate
                                    .fadeIn(duration: 700.ms, curve: Curves.easeOutQuad)
                                    .slide(),
                              ),
                            ],
                          ).animate(onPlay: (controller) => controller.repeat())
                              .shimmer(duration: 1200.ms, color:  kBlueColor.withAlpha(55))
                              .animate() // this wraps the previous Animate in another Animate
                              .fadeIn(duration: 700.ms, curve: Curves.easeOutQuad)
                              .slide():PopupMenuButton<ClassTeacherModel>(
                            constraints: BoxConstraints(
                              maxWidth: Get.width * 0.8,
                              minWidth: Get.width * 0.8,
                            ),
                            itemBuilder: (context) =>
                                controller.supStageOfSchool!.map((e) {
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
                                      controller.selectingSubStageOfSchool(e);
                                    },
                                    child: SizedBox(
                                      width: Get.width * 0.8,
                                      child: Column(
                                        children: [
                                          CustomText(
                                            Get.find<StorageService>()
                                                .activeLocale ==
                                                SupportedLocales.english
                                                ? e.titleEn??""
                                                :e.title??"",
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
                                          e == controller.supStageOfSchool?.last
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
                                height: Get.height * 0.06,
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
                                            SizedBox(
                                              width: Get.width * 0.6,
                                              child: CustomText(
                                                textAlign: TextAlign.center,
                                                maxLines: 3,
                                                controller.supStageOfSchool?.isEmpty
                                                    ??true?Get.find<StorageService>().activeLocale ==
                                                    SupportedLocales.english
                                                    ? "There is no academic year registered for you"
                                                    : "لا يوجد السنه الدراسيه مسجل لك":controller.chosenSupStageOfSchool==null?Get.find<StorageService>()
                                                    .activeLocale ==
                                                    SupportedLocales.english
                                                    ?"choose Academic year":"أختر السنه الدراسيه":Get.find<StorageService>()
                                                    .activeLocale ==
                                                    SupportedLocales.english
                                                    ?(controller.chosenSupStageOfSchool?.titleEn??""):(controller.chosenSupStageOfSchool?.title??""),
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
                        ],
                      ),

                      controller.chosenSupStageOfSchool==null?const SizedBox():
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10,),
                          CustomText(
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            "${
                                Get.find<StorageService>().activeLocale ==
                                    SupportedLocales.english
                                    ? "class"
                                    : "الفصل"
                            } : ",
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
                              color: kDarkBlueColor,
                            ),
                          ),
                          const SizedBox(height: 10,),
                          controller.isClassLoading?
                          Column(
                            children: [
                              const SizedBox(height: 10,),
                              Container(
                                height: Get.height * 0.06,
                                width: Get.width * 0.8,
                                decoration:  BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),

                                    color: const Color(0xFFDFDDDF)

                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      height: Get.height * 0.05,
                                      width: Get.width * 0.8,
                                      decoration:   BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),

                                        color:  const Color(0xFFDFDDDF),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: kGrayColor,
                                            blurRadius: 2,
                                            offset:
                                            Offset(1, 1), // Shadow position
                                          ),
                                        ],

                                      ),
                                    ),
                                  ),
                                ).animate(onPlay: (controller) => controller.repeat())
                                    .shimmer(duration: 1200.ms, color:  kBlueColor.withAlpha(55))
                                    .animate() // this wraps the previous Animate in another Animate
                                    .fadeIn(duration: 700.ms, curve: Curves.easeOutQuad)
                                    .slide(),
                              ),
                            ],
                          ).animate(onPlay: (controller) => controller.repeat())
                              .shimmer(duration: 1200.ms, color:  kBlueColor.withAlpha(55))
                              .animate() // this wraps the previous Animate in another Animate
                              .fadeIn(duration: 700.ms, curve: Curves.easeOutQuad)
                              .slide():PopupMenuButton<ClassTeacherModel>(
                            constraints: BoxConstraints(
                              maxWidth: Get.width * 0.8,
                              minWidth: Get.width * 0.8,
                            ),
                            itemBuilder: (context) =>
                                controller.teacherClass!.map((e) {
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
                                      controller.selectingClassOfSchool(e);
                                    },
                                    child: SizedBox(
                                      width: Get.width * 0.8,
                                      child: Column(
                                        children: [
                                          CustomText(
                                            Get.find<StorageService>()
                                                .activeLocale ==
                                                SupportedLocales.english
                                                ? e.titleEn??""
                                                :e.title??"",
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
                                          e == controller.teacherClass?.last
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
                                height: Get.height * 0.06,
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
                                            SizedBox(
                                              width: Get.width * 0.6,
                                              child: CustomText(
                                                textAlign: TextAlign.center,
                                                maxLines: 3,
                                                  controller.teacherClass?.isEmpty
                                                      ??true?Get.find<StorageService>().activeLocale ==
                                                      SupportedLocales.english
                                                      ? "There is no class registered for you"
                                                      : "لا يوجد فصل مسجل لك":controller.chosenClassOfSchool==null?Get.find<StorageService>()
                                                    .activeLocale ==
                                                    SupportedLocales.english
                                                    ?"choose class":"أختر الفصل":Get.find<StorageService>()
                                                    .activeLocale ==
                                                    SupportedLocales.english
                                                    ?(controller.chosenClassOfSchool?.titleEn??""):(controller.chosenClassOfSchool?.title??""),
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
                        ],
                      ),
                      controller.chosenClassOfSchool==null?const SizedBox():

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10,),
                          CustomText(
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            "${
                                Get.find<StorageService>().activeLocale ==
                                    SupportedLocales.english
                                    ? "student name"
                                    : "أسم الطالب"
                            } : ",
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
                              color: kDarkBlueColor,
                            ),
                          ),
                          const SizedBox(height: 10,),
                          controller.isStudentNameLoading?
                          Column(
                            children: [
                              const SizedBox(height: 10,),
                              Container(
                                height: Get.height * 0.06,
                                width: Get.width * 0.8,
                                decoration:  BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),

                                    color: const Color(0xFFDFDDDF)

                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      height: Get.height * 0.05,
                                      width: Get.width * 0.8,
                                      decoration:   BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),

                                        color:  const Color(0xFFDFDDDF),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: kGrayColor,
                                            blurRadius: 2,
                                            offset:
                                            Offset(1, 1), // Shadow position
                                          ),
                                        ],

                                      ),
                                    ),
                                  ),
                                ).animate(onPlay: (controller) => controller.repeat())
                                    .shimmer(duration: 1200.ms, color:  kBlueColor.withAlpha(55))
                                    .animate() // this wraps the previous Animate in another Animate
                                    .fadeIn(duration: 700.ms, curve: Curves.easeOutQuad)
                                    .slide(),
                              ),
                            ],
                          ).animate(onPlay: (controller) => controller.repeat())
                              .shimmer(duration: 1200.ms, color:  kBlueColor.withAlpha(55))
                              .animate() // this wraps the previous Animate in another Animate
                              .fadeIn(duration: 700.ms, curve: Curves.easeOutQuad)
                              .slide():PopupMenuButton<PersonModel>(
                            constraints: BoxConstraints(
                              maxWidth: Get.width * 0.8,
                              minWidth: Get.width * 0.8,
                            ),
                            itemBuilder: (context) =>
                                controller.studentName!.map((e) {
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
                                      controller.selectingStudentName(e);
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
                                          e == controller.studentName?.last
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
                                height: Get.height * 0.06,
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
                                            SizedBox(
                                              width: Get.width * 0.6,
                                              child: CustomText(
                                                textAlign: TextAlign.center,
                                                maxLines: 3,
                                                controller.chosenStudentName?.name==""?Get.find<StorageService>()
                                                    .activeLocale ==
                                                    SupportedLocales.english
                                                    ?"choose student name":"أختر أسم الطالب":controller.chosenStudentName?.name??"",
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
                        ],
                      ),
                      controller.chosenStudentName==null?const SizedBox():Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10,),
                          CustomText(
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            "${
                                Get.find<StorageService>().activeLocale ==
                                    SupportedLocales.english
                                    ? "reason"
                                    : "السبب"
                            } : ",
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
                              color: kDarkBlueColor,
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Container(
                            width: Get.width * 0.9,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: const DecorationImage(
                                  image: AssetImage(
                                      "assets/images/backgroundImage.png"),
                                  fit: BoxFit.cover),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SizedBox(
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
                                    hintText: Get.find<StorageService>().activeLocale == SupportedLocales.english?"reason for recommendation":"أدخال سبب التوصيه",
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
                            ),
                          ),
                        ],
                      ),
                      controller.chosenStudentName==null?const SizedBox():Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10,),

                          InkWell(
                            onTap: () {
                              if(controller.isSendingRecommendation){
                                showDialog(context: context,
                                    builder: (context) {
                                      return const LoadingAlertDialogue();
                                    });
                              }else{
                                controller.sendRecommendation( context);
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
                                        Get.find<StorageService>()
                                            .activeLocale ==
                                            SupportedLocales.english
                                            ? "send recommendation"
                                            : "أرسال التوصيه",
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
                      const SizedBox(height: 10,),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }
}
