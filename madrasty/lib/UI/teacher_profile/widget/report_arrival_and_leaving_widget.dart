// ignore_for_file: sized_box_for_whitespace, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:madrasty/Widgets/loader.dart';
import '../../../Models/class_teacher_model.dart';
import '../../../Utils/Colors_File.dart';
import '../../../Utils/constant.dart';
import '../../../Utils/localization_services.dart';
import '../../../Utils/memory.dart';
import '../../../Widgets/custom_text_widget.dart';
import '../../../Widgets/no_data_widget.dart';
import '../controller/teacher_profile_controller.dart';

class ReportArrivalAndLeavingWidget extends StatelessWidget {
  const ReportArrivalAndLeavingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: TeacherProfileController(),
      builder: (TeacherProfileController controller) =>
      controller.isTeacherProfileDataIsLoading?
      Loader(height: Get.height*0.8,):
      SingleChildScrollView(
        child: Column(
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
                            Container(
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
                            Container(
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
                            Container(
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
            controller.chosenClass == null?const SizedBox():
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
                          ? "Attendance and absence schedule day"
                          : "يوم جدول الجضور و الغياب"
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

                InkWell(
                  onTap: (){
                    controller.selectingDate( context);
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
                          child: Container(
                            width: Get.width * 0.7,
                            child: CustomText(
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              "${controller.getFormatedDate(controller.selectedDateVal)}",

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
                const SizedBox(height: 10,),
            ],
          ),
            controller.chosenClass == null?const SizedBox():
            InkWell(
              onTap: (){
                controller.getSchedulesTable();
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
                      child: Container(
                        width: Get.width * 0.7,
                        child: CustomText(
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          Get.find<StorageService>().activeLocale ==
                                  SupportedLocales.english
                                  ?controller.attendanceTable?.isEmpty??true?"Download attendance and absence schedule": "Reload schedule"
                                  :controller.attendanceTable?.isEmpty??true?"تحميل جدول الغياب والحضور": "أعاده تحميل الجدول",

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

            (controller.attendanceTable?.isEmpty??true)||controller.chosenClass == null?const SizedBox():controller.schedulesIsLoadingTable?Center(child: Loader(width: Get.width*0.9,height: Get.height*0.4,)):controller.attendanceSchedulesIsEmpty?NoDataWidget(
              refreshedFunc: (){}, text: 'لا يوجد طلاب حتى الأن',
              imgPath: "assets/images/Confirmed attendance is empty.png", hasRefreshButtonOrNot: false,):


            SingleChildScrollView(
              scrollDirection:Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:    RepaintBoundary(
                  key: controller.previewAttendanceContainer,
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

                        label: Center(
                          child: CustomText(
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            'م',
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
                      ),
                      DataColumn(
                        label: CustomText(
                          textAlign: TextAlign.start,
                          maxLines: 3,
                          "الطالب",
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
                      DataColumn(
                        label: Image.asset(
                          "assets/icons/wrightIcon.png",
                          fit: BoxFit.contain,
                          height: MediaQuery.of(context).size.height * 0.04,
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                      ),
                      DataColumn(
                        label: CustomText(
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          'الحضور',
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
                      DataColumn(
                        label: CustomText(
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          'الأنصراف',
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
                      DataColumn(
                        label: CustomText(
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          'ملاحظات',
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
                    rows: [
                      for (int index =0; index < (controller.attendanceTable?.length??0); index++)
                        DataRow(cells: [
                          DataCell(
                            Center(
                              child: CustomText(
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                "${controller.attendanceTable?[index].id??0}",
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
                          DataCell(
                            CustomText(
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              "${controller.attendanceTable?[index].name??0}",
                              style: TextStyle(
                                shadows: <Shadow>[
                                  Shadow(
                                      offset: const Offset(0.5, 0.5),
                                      blurRadius: 0.5,
                                      color: Colors.black.withOpacity(0.5)),
                                ],
                                fontSize: 10,
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
                          DataCell(
                            InkWell(
                              onTap: (){
                                controller.selectingData(index, context);
                              },
                              child: Center(
                                child: Image.asset(
                                  (controller.attendanceTable?[index].check??0)==1?"assets/icons/wrightIcon.png":"assets/icons/wrongIcon.png",
                                  fit: BoxFit.contain,
                                  height: MediaQuery.of(context).size.height * 0.04,
                                  width: MediaQuery.of(context).size.width * 0.05,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            InkWell(
                              onTap: (){
                                if((controller.attendanceTable?[index].check??0)==1){
                                  controller.selectingArrivalTime( context, index,controller.attendanceTable?[index].timeIn??"");
                                }
                              },

                              child: Container(
                                width: double.infinity,
                                height:  double.infinity,
                                child: Center(
                                  child: CustomText(
                                    textAlign: TextAlign.center,
                                    maxLines: 3,
                                    (controller.attendanceTable?[index].check??0)==1?"${controller.formattingTimmeToAmAndPmFormat(controller.attendanceTable?[index].timeIn??"")}":"",
                                    style: TextStyle(
                                      shadows: <Shadow>[
                                        Shadow(
                                            offset: const Offset(0.5, 0.5),
                                            blurRadius: 0.5,
                                            color: Colors.black.withOpacity(0.5)),
                                      ],
                                      fontSize: 10,
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
                          DataCell(
                            InkWell(
                              onTap: (){
                                if((controller.attendanceTable?[index].check??0)==1){
                                  controller.selectingLeaveTime( context,index,controller.attendanceTable?[index].timeOut??"");
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                height:  double.infinity,
                                child: Center(
                                  child: CustomText(
                                    textAlign: TextAlign.center,
                                    maxLines: 3,
                                    (controller.attendanceTable?[index].check??0)==1?"${controller.formattingTimmeToAmAndPmFormat(controller.attendanceTable?[index].timeOut??"")}":"",                            style: TextStyle(
                                      shadows: <Shadow>[
                                        Shadow(
                                            offset: const Offset(0.5, 0.5),
                                            blurRadius: 0.5,
                                            color: Colors.black.withOpacity(0.5)),
                                      ],
                                      fontSize: 10,
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
                          DataCell(
                            InkWell(
                              onTap: (){
                                if((controller.attendanceTable?[index].check??0)==1){
                                  controller.showEditingNotes ( context,index);
                                }
                              },
                              child:Container(
                                width: double.infinity,
                                height:  double.infinity,
                                child: Center(
                                  child: CustomText(
                                    textAlign: TextAlign.center,
                                    maxLines: 3,
                                    "${controller.attendanceTable?[index].notes}",
                                    style: TextStyle(
                                      shadows: <Shadow>[
                                        Shadow(
                                            offset: const Offset(0.5, 0.5),
                                            blurRadius: 0.5,
                                            color: Colors.black.withOpacity(0.5)),
                                      ],
                                      fontSize: 10,
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
                        ]),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            (controller.attendanceTable?.isEmpty??true)||(controller.chosenClass == null)?
            const SizedBox():
            InkWell(
              onTap: (){
                controller.saveTheAttendanceAndLeavingSheet(context);
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
                            Container(
                              width: Get.width * 0.6,
                              child: CustomText(
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                Get.find<StorageService>()
                                    .activeLocale ==
                                    SupportedLocales.english
                                    ?"save the  attendance and absence sheet":"حفظ الجدول الحضور و الغيياب",
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
            const SizedBox(
              height: 20,
            ),
            (controller.attendanceTable?.isEmpty??true)||(controller.chosenClass == null)?
            const SizedBox():InkWell(
              onTap: (){
                controller.generateAttendanceStyledPdf(context);
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
                            Container(
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
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
