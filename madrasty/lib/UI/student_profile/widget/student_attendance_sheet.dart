import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Utils/Colors_File.dart';
import '../../../Utils/constant.dart';
import '../../../Utils/localization_services.dart';
import '../../../Utils/memory.dart';
import '../../../Widgets/custom_text_widget.dart';
import '../../../Widgets/loader.dart';
import '../../../Widgets/no_data_widget.dart';
import '../controller/student_profile_controller.dart';

class StudentAttendanceSheet extends StatelessWidget {
  const StudentAttendanceSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: StudentProfileController(),
      builder: (StudentProfileController controller) => Column(
        children: [
          const SizedBox(height: 10,),

          CustomText(
            textAlign: TextAlign.left,
            maxLines: 3,
            "${
                Get.find<StorageService>().activeLocale ==
                    SupportedLocales.english
                    ? "Report start date"
                    : "تاريخ بدايه التقرير"
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

          InkWell(
            onTap: (){
              controller.selectingStartDate( context);
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
                        "${controller.getFormatedDate(controller.selectedStartDateVal)}",

                        style: TextStyle(
                          shadows: <Shadow>[
                            Shadow(
                                offset: const Offset(0.5, 0.5),
                                blurRadius: 0.5,
                                color:
                                Colors.black.withValues(alpha:0.5)),
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
          CustomText(
            textAlign: TextAlign.left,
            maxLines: 3,
            "${
                Get.find<StorageService>().activeLocale ==
                    SupportedLocales.english
                    ? "Report End Date"
                    : "تاريخ نهايه التقرير"
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
          InkWell(
            onTap: (){
              controller.selectingEndDate(context);
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
                        "${controller.getFormatedDate(controller.selectedEndDateVal)}",

                        style: TextStyle(
                          shadows: <Shadow>[
                            Shadow(
                                offset: const Offset(0.5, 0.5),
                                blurRadius: 0.5,
                                color:
                                Colors.black.withValues(alpha:0.5)),
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
          InkWell(
            onTap: (){
              controller.getAttendanceTable();
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
                            ?controller.attendanceTable?.isEmpty??true?"Download attendance table": "Reload attendance table"
                            :controller.attendanceTable?.isEmpty??true?"تحميل جدول الحضور و الغياب": "أعاده تحميل الجدول الحضور و الغياب",

                        style: TextStyle(
                          shadows: <Shadow>[
                            Shadow(
                                offset: const Offset(0.5, 0.5),
                                blurRadius: 0.5,
                                color:
                                Colors.black.withValues(alpha:0.5)),
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
          controller.attendanceTableIsEmpty?NoDataWidget(
            refreshedFunc: (){}, text: 'لا يوجد تاريخ جدول حضور مسجل حتى الأن',
            imgPath: "assets/images/Confirmed attendance is empty.png", hasRefreshButtonOrNot: false,):controller.attendanceTable?.isEmpty??true?const SizedBox():controller.isAttendanceTableLoading?Center(child: Loader(width: Get.width*0.9,height: Get.height*0.4,)):


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
                          Get.find<StorageService>().activeLocale ==
                              SupportedLocales.english
                              ?'Day Date':"تاريخ اليوم",
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
                        Get.find<StorageService>().activeLocale ==
                            SupportedLocales.english
                            ?'attendance':'الحضور',
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
                    DataColumn(
                      label: CustomText(
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        Get.find<StorageService>().activeLocale ==
                            SupportedLocales.english
                            ?'leave':'الأنصراف',
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
                    DataColumn(
                      label: CustomText(
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        Get.find<StorageService>().activeLocale ==
                            SupportedLocales.english
                            ?'notes':'ملاحظات',
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
                  rows: [
                    for (int index =0; index < (controller.attendanceTable?.length??0); index++)
                      DataRow(cells: [
                        DataCell(
                          Center(
                            child: CustomText(
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              "${controller.getFormatedTableDate(controller.attendanceTable?[index].day??0)}",
                              style: TextStyle(
                                shadows: <Shadow>[
                                  Shadow(
                                      offset: const Offset(0.5, 0.5),
                                      blurRadius: 0.5,
                                      color:
                                      Colors.black.withValues(alpha:0.5)),
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
                          Center(
                            child: Image.asset(
                              (controller.attendanceTable?[index].check??0)==1?"assets/icons/wrightIcon.png":"assets/icons/wrongIcon.png",
                              fit: BoxFit.contain,
                              height: MediaQuery.of(context).size.height * 0.04,
                              width: MediaQuery.of(context).size.width * 0.05,
                            ),
                          ),
                        ),
                        DataCell(
                          CustomText(
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            (controller.attendanceTable?[index].check??0)==1?"${controller.formattingTimmeToAmAndPmFormat(controller.attendanceTable?[index].studentAttendanceModelIn??"")}":"",
                            style: TextStyle(
                              shadows: <Shadow>[
                                Shadow(
                                    offset: const Offset(0.5, 0.5),
                                    blurRadius: 0.5,
                                    color: Colors.black.withValues(alpha:0.5)),
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
                          CustomText(
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            (controller.attendanceTable?[index].check??0)==1?"${controller.formattingTimmeToAmAndPmFormat(controller.attendanceTable?[index].out??"")}":"",                            style: TextStyle(
                            shadows: <Shadow>[
                              Shadow(
                                  offset: const Offset(0.5, 0.5),
                                  blurRadius: 0.5,
                                  color: Colors.black.withValues(alpha:0.5)),
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
                          CustomText(
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            "${controller.attendanceTable?[index].notes}",
                            style: TextStyle(
                              shadows: <Shadow>[
                                Shadow(
                                    offset: const Offset(0.5, 0.5),
                                    blurRadius: 0.5,
                                    color: Colors.black.withValues(alpha:0.5)),
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
                      ]),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 15,),
          controller.attendanceTable?.isEmpty??true?const SizedBox():InkWell(
            onTap: (){
              controller.saveTheAttendanceTable(context);
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
                                  ?"save the attendance and leaving table":"حفظ الجدول الغياب و الحضور",
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
          controller.attendanceTable?.isEmpty??true?const SizedBox():InkWell(
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
    );
  }
}
