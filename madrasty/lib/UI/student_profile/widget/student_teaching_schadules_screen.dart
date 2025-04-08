// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madrasty/UI/student_profile/controller/student_profile_controller.dart';
import 'package:madrasty/Utils/Colors_File.dart';
import 'package:madrasty/Utils/constant.dart';
import 'package:madrasty/Utils/localization_services.dart';
import 'package:madrasty/Utils/memory.dart';
import 'package:madrasty/Widgets/custom_text_widget.dart';

import '../../../Widgets/loader.dart';
import '../../../Widgets/no_data_widget.dart';

class StudentTeachingSchadulesScreen extends StatelessWidget {
  const StudentTeachingSchadulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: StudentProfileController(),
      builder: (StudentProfileController controller) =>  SingleChildScrollView(
        child:Column(
          children: [



           controller.isSchedulesLoading?Center(child: Loader(width: Get.width*0.9,height: Get.height*0.4,)):controller.dataClass==null?NoDataWidget(
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
                              label: Container(
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
                                                  color: Colors.black.withValues(alpha:0.5)),
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
                                      Container(
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
                                                  color: Colors.black.withValues(alpha:0.5)),
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

                            ...?controller.dataClass?.header?.map((e){
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
                                            color: Colors.black.withValues(alpha:0.5)),
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
                            color: Colors.black.withValues(alpha:0.5)),
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
                            Container(
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
