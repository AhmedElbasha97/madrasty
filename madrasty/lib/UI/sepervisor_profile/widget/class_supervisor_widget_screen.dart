// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../../Models/class_teacher_model.dart';
import '../../../Utils/Colors_File.dart';
import '../../../Utils/constant.dart';
import '../../../Utils/localization_services.dart';
import '../../../Utils/memory.dart';
import '../../../Widgets/custom_text_widget.dart';
import '../../../Widgets/loader.dart';
import '../../../Widgets/no_data_widget.dart';
import '../controller/supervisor_profile_controller.dart';

class ClassSupervisorWidgetScreen extends StatelessWidget {
  const ClassSupervisorWidgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: SupervisorProfileController(),
      builder: (SupervisorProfileController controller) => SingleChildScrollView(

        child:Column(
          children: [
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
                          : "المرحله الدراسي"
                  } : ",
                  style: TextStyle(
                    shadows: <Shadow>[
                      Shadow(
                          offset:
                          const Offset(0.5, 0.5),
                          blurRadius: 0.5,
                          color: Colors.black
                              .withOpacity(0.5)),
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
                      controller.teacherStages!.map((e) {
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
                            controller.choosingStage(e);
                          },
                          child: SizedBox(
                            width: Get.width * 0.7,
                            child: Column(
                              children: [
                                CustomText(
                                  Get.find<StorageService>()
                                      .activeLocale ==
                                      SupportedLocales.english
                                      ?e.titleEn??"":e.title??"",
                                  style: TextStyle(
                                      color: kLightBlueColor,
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
                                e == controller.teacherStages?.last
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
                    padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 0),
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: Get.height * 0.06,
                      ),
                      width: Get.width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
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
                                width: Get.width * 0.7,
                                child: CustomText(
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  controller.teacherStages?.isEmpty
                                      ??true?Get.find<StorageService>().activeLocale ==
                                      SupportedLocales.english
                                      ?"There is no academic stage registered for you"
                                      : "لا يوجد مرحله الدراسيه مسجل لك":controller.chosenStage.isNull? Get.find<StorageService>().activeLocale ==
                                      SupportedLocales.english
                                      ? "choose education stage"
                                      : "أختر المرحله الدراسي":Get.find<StorageService>()
                                      .activeLocale ==
                                      SupportedLocales.english
                                      ? controller.chosenStage?.titleEn??"": controller.chosenStage?.title??"",
                                  style: TextStyle(
                                    shadows: <Shadow>[
                                      Shadow(
                                          offset:
                                          const Offset(0.5, 0.5),
                                          blurRadius: 0.5,
                                          color: Colors.black
                                              .withOpacity(0.5)),
                                    ],
                                    fontSize: 13,
                                    letterSpacing: 0,
                                    fontFamily:
                                    Get.find<StorageService>()
                                        .activeLocale ==
                                        SupportedLocales.english
                                        ? fontFamilyEnglishName
                                        : fontFamilyArabicName,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const Icon(Icons.arrow_downward_sharp,
                                  color: Colors.white, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            controller.chosenStage == null?const SizedBox():

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
                          ? "education year"
                          : "السنه الدراسيه"
                  } : ",
                  style: TextStyle(
                    shadows: <Shadow>[
                      Shadow(
                          offset:
                          const Offset(0.5, 0.5),
                          blurRadius: 0.5,
                          color: Colors.black
                              .withOpacity(0.5)),
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

                controller.subStageIsLoading?Column(
                  children: [
                    const SizedBox(height: 10,),
                    Container(
                      height: Get.height * 0.06,
                      width: Get.width * 0.8,
                      decoration:  BoxDecoration(
                          borderRadius: BorderRadius.circular(10),

                          color: const Color(0xFFDFDDDF)

                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            height: Get.height * 0.05,
                            width: Get.width * 0.8,
                            decoration:   BoxDecoration(
                              borderRadius: BorderRadius.circular(10),

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
                    .slide():
                PopupMenuButton<ClassTeacherModel>(
                  constraints: BoxConstraints(
                    maxWidth: Get.width * 0.8,
                    minWidth: Get.width * 0.8,
                  ),
                  itemBuilder: (context) =>
                      controller.teacherSubStage!.map((e) {
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
                            controller.choosingSubStage(e);
                          },
                          child: SizedBox(
                            width: Get.width * 0.7,
                            child: Column(
                              children: [
                                CustomText(
                                  Get.find<StorageService>()
                                      .activeLocale ==
                                      SupportedLocales.english
                                      ?e.titleEn??"":e.title??"",
                                  style: TextStyle(
                                      color: kLightBlueColor,
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
                                e == controller.teacherStages?.last
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
                    padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 0),
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: Get.height * 0.06,
                      ),
                      width: Get.width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
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
                                width: Get.width * 0.7,
                                child: CustomText(
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  controller.teacherSubStage?.isEmpty
                                      ??true?Get.find<StorageService>().activeLocale ==
                                      SupportedLocales.english
                                      ? "There is no academic year registered for you"
                                      : "لا يوجد السنه الدراسيه مسجل لك":controller.chosenSubStage.isNull? Get.find<StorageService>().activeLocale ==
                                      SupportedLocales.english
                                      ? "choose education year"
                                      : "أختر السنه الدراسيه":Get.find<StorageService>()
                                      .activeLocale ==
                                      SupportedLocales.english
                                      ? controller.chosenSubStage?.titleEn??"": controller.chosenSubStage?.title??"",
                                  style: TextStyle(
                                    shadows: <Shadow>[
                                      Shadow(
                                          offset:
                                          const Offset(0.5, 0.5),
                                          blurRadius: 0.5,
                                          color: Colors.black
                                              .withOpacity(0.5)),
                                    ],
                                    fontSize: 13,
                                    letterSpacing: 0,
                                    fontFamily:
                                    Get.find<StorageService>()
                                        .activeLocale ==
                                        SupportedLocales.english
                                        ? fontFamilyEnglishName
                                        : fontFamilyArabicName,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const Icon(Icons.arrow_downward_sharp,
                                  color: Colors.white, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            controller.chosenSubStage == null?const SizedBox():
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
                          ? "education class"
                          : "الفصل الدراسي"
                  } : ",
                  style: TextStyle(
                    shadows: <Shadow>[
                      Shadow(
                          offset:
                          const Offset(0.5, 0.5),
                          blurRadius: 0.5,
                          color: Colors.black
                              .withOpacity(0.5)),
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

                controller.classIsLoading?Column(
                  children: [
                    const SizedBox(height: 10,),
                    Container(
                      height: Get.height * 0.06,
                      width: Get.width * 0.8,
                      decoration:  BoxDecoration(
                          borderRadius: BorderRadius.circular(10),

                          color: const Color(0xFFDFDDDF)

                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            height: Get.height * 0.05,
                            width: Get.width * 0.8,
                            decoration:   BoxDecoration(
                              borderRadius: BorderRadius.circular(10),

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
                            controller.choosingClass(e);
                          },
                          child: SizedBox(
                            width: Get.width * 0.7,
                            child: Column(
                              children: [
                                CustomText(
                                  Get.find<StorageService>()
                                      .activeLocale ==
                                      SupportedLocales.english
                                      ?e.titleEn??"":e.title??"",
                                  style: TextStyle(
                                      color: kLightBlueColor,
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
                    padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 0),
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: Get.height * 0.06,
                      ),
                      width: Get.width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
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
                                width: Get.width * 0.7,
                                child: CustomText(
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  controller.teacherClass?.isEmpty
                                      ??true?Get.find<StorageService>().activeLocale ==
                                      SupportedLocales.english
                                      ? "There is no class registered for you"
                                      : "لا يوجد فصل مسجل لك":controller.chosenClass.isNull? Get.find<StorageService>().activeLocale ==
                                      SupportedLocales.english
                                      ? "choose education class"
                                      : "أختر الفصل الدراسي":Get.find<StorageService>()
                                      .activeLocale ==
                                      SupportedLocales.english
                                      ? controller.chosenClass?.titleEn??"": controller.chosenClass?.title??"",
                                  style: TextStyle(
                                    shadows: <Shadow>[
                                      Shadow(
                                          offset:
                                          const Offset(0.5, 0.5),
                                          blurRadius: 0.5,
                                          color: Colors.black
                                              .withOpacity(0.5)),
                                    ],
                                    fontSize: 13,
                                    letterSpacing: 0,
                                    fontFamily:
                                    Get.find<StorageService>()
                                        .activeLocale ==
                                        SupportedLocales.english
                                        ? fontFamilyEnglishName
                                        : fontFamilyArabicName,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const Icon(Icons.arrow_downward_sharp,
                                  color: Colors.white, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15,),
            controller.chosenClass == null?const SizedBox():
            InkWell(
              onTap: (){
                controller.getClassScheduleData();
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 0),
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: Get.height * 0.06,
                  ),
                  width: Get.width * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
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
                      child: SizedBox(
                        width: Get.width * 0.7,
                        child: CustomText(
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          Get.find<StorageService>().activeLocale ==
                              SupportedLocales.english
                              ?controller.classScheduleData == null?"Download class schedule": "Reload schedule"
                              :controller.classScheduleData == null?"تحميل جدول الدراسى": "أعاده تحميل الجدول",

                          style: TextStyle(
                            shadows: <Shadow>[
                              Shadow(
                                  offset: const Offset(0.5, 0.5),
                                  blurRadius: 0.5,
                                  color:
                                  Colors.black.withOpacity(0.5)),
                            ],
                            fontSize: 13,
                            letterSpacing: 0,
                            fontFamily: Get.find<StorageService>()
                                .activeLocale ==
                                SupportedLocales.english
                                ? fontFamilyEnglishName
                                : fontFamilyArabicName,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),


            (controller.classScheduleData == null)||controller.chosenClass == null?const SizedBox():controller.classSchedulesIsLoading?Center(child: Loader(width: Get.width*0.9,height: Get.height*0.4,)):controller.classSchedulesIsEmpty?NoDataWidget(
              refreshedFunc: (){}, text: 'لا يوجد مواعيد مسجله حتى الأن',
              imgPath: "assets/images/class_schedule_has_no_data.png", hasRefreshButtonOrNot: false,)
                :Container(
              color: kLightBlueColor,
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection:Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:  RepaintBoundary(
                        key: controller.previewContainer,
                        child: DataTable(

                          columnSpacing: 20,
                          decoration: BoxDecoration(
                              color: kDarkBlueColor,
                              borderRadius: BorderRadius.circular(25)),
                          border: TableBorder(
                            horizontalInside:
                            const BorderSide(color: kYellowColor, width: 0.7),
                            verticalInside:
                            const BorderSide(color: kYellowColor, width: 0.7),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          columns: [
                            DataColumn(
                              label: SizedBox(
                                width:Get.width*0.15,
                                height:Get.height*0.3,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 3.0),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment:  Alignment.topLeft,
                                        child: CustomText(
                                          textAlign: TextAlign.end,
                                          maxLines: 3,
                                          Get.find<StorageService>().activeLocale ==
                                              SupportedLocales.english
                                              ?"class":'الحصص',
                                          style: TextStyle(
                                            shadows: <Shadow>[
                                              Shadow(
                                                  offset: const Offset(0.5, 0.5),
                                                  blurRadius: 0.5,
                                                  color: Colors.black.withOpacity(0.5)),
                                            ],
                                            fontSize: 13,
                                            letterSpacing: 0,
                                            fontFamily:
                                            Get.find<StorageService>().activeLocale ==
                                                SupportedLocales.english
                                                ? fontFamilyEnglishName
                                                : fontFamilyArabicName,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          width:Get.width*0.17,
                                          height:Get.height*0.015,
                                          child: CustomPaint(painter: LinePainter())),
                                      Align(
                                        alignment:  Alignment.bottomRight,

                                        child: CustomText(
                                          textAlign: TextAlign.start,
                                          maxLines: 3,
                                          Get.find<StorageService>().activeLocale ==
                                              SupportedLocales.english
                                              ?"day":'اليوم',
                                          style: TextStyle(
                                            shadows: <Shadow>[
                                              Shadow(
                                                  offset: const Offset(0.5, 0.5),
                                                  blurRadius: 0.5,
                                                  color: Colors.black.withOpacity(0.5)),
                                            ],
                                            fontSize: 13,
                                            letterSpacing: 0,
                                            fontFamily:
                                            Get.find<StorageService>().activeLocale ==
                                                SupportedLocales.english
                                                ? fontFamilyEnglishName
                                                : fontFamilyArabicName,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            ...?controller.classScheduleData?.header?.map((e){
                              return DataColumn(
                                label: Center(
                                  child: CustomText(
                                    textAlign: TextAlign.center,
                                    maxLines: 3,
                                    e,
                                    style: TextStyle(
                                      shadows: <Shadow>[
                                        Shadow(
                                            offset: const Offset(0.5, 0.5),
                                            blurRadius: 0.5,
                                            color: Colors.black.withOpacity(0.5)),
                                      ],
                                      fontSize: 13,
                                      letterSpacing: 0,
                                      fontFamily:
                                      Get.find<StorageService>().activeLocale ==
                                          SupportedLocales.english
                                          ? fontFamilyEnglishName
                                          : fontFamilyArabicName,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            }),

                          ],
                          rows: [
                            ...controller.listOfRowsSchedules
                          ],
                        ),
                      ),
                    ),
                  ),
                  CustomText(
                    textAlign: TextAlign.center,
                    controller.noteOfVacation,
                    maxLines: 5,
                    style: TextStyle(
                      shadows: <Shadow>[
                        Shadow(
                            offset: const Offset(0.5, 0.5),
                            blurRadius: 0.5,
                            color: Colors.black.withOpacity(0.5)),
                      ],
                      fontSize: 15,
                      letterSpacing: 0,
                      fontFamily: Get.find<StorageService>().activeLocale ==
                          SupportedLocales.english
                          ? fontFamilyEnglishName
                          : fontFamilyArabicName,
                      color: kDarkBlueColor,
                    ),
                  ),
                  const SizedBox(height: 15,),
                ],
              ),
            ),
            const SizedBox(height: 15,),
            (controller.classScheduleData == null)||controller.chosenClass == null?const SizedBox():
            InkWell(
              onTap: (){
                controller.saveTheClassSchedules(context);
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
                                Get.find<StorageService>()
                                    .activeLocale ==
                                    SupportedLocales.english
                                    ?"save the schedules":"حفظ الجدول الدراسى",
                                style: TextStyle(
                                  shadows: <Shadow>[
                                    Shadow(
                                        offset:
                                        const Offset(0.5, 0.5),
                                        blurRadius: 0.5,
                                        color: Colors.black
                                            .withOpacity(0.5)),
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
                            const Icon(Icons.download,
                                color: kWhiteColor, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15,),
            (controller.classScheduleData == null)||controller.chosenClass == null?const SizedBox():
            InkWell(
              onTap: (){
                controller.generateStyledPdf(context);
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
                                Get.find<StorageService>()
                                    .activeLocale ==
                                    SupportedLocales.english
                                    ?"save the schedules as pdf":"حفظ الجداول بصيغة pdf",
                                style: TextStyle(
                                  shadows: <Shadow>[
                                    Shadow(
                                        offset:
                                        const Offset(0.5, 0.5),
                                        blurRadius: 0.5,
                                        color: Colors.black
                                            .withOpacity(0.5)),
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
                            const Icon(Icons.download,
                                color: kWhiteColor, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15,),
            (controller.classScheduleData == null)||controller.chosenClass == null?const SizedBox():
            InkWell(
              onTap: (){
                controller.editClassSchadulesTable();
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
                                Get.find<StorageService>()
                                    .activeLocale ==
                                    SupportedLocales.english
                                    ?"Modify the class schedule":"تعديل الجدول الدراسىى",
                                style: TextStyle(
                                  shadows: <Shadow>[
                                    Shadow(
                                        offset:
                                        const Offset(0.5, 0.5),
                                        blurRadius: 0.5,
                                        color: Colors.black
                                            .withOpacity(0.5)),
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
                            const Icon(Icons.edit,
                                color: kWhiteColor, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15,),

          ],
        ),
      ),
    );
  }
}
class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    final p1 = Offset(size.width, 0);
    final p2 = Offset(0, size.height);
    final paint = Paint()
      ..color = kYellowColor
      ..strokeWidth = 1;
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(LinePainter oldDelegate) => false;
}
