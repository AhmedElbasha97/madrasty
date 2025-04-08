import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madrasty/Utils/Colors_File.dart';

import '../../../Models/parent_share_model.dart';
import '../../../Models/student_share_model.dart';
import '../../../Utils/constant.dart';
import '../../../Utils/localization_services.dart';
import '../../../Utils/memory.dart';
import '../../../Utils/translation_key.dart';
import '../../../Widgets/custom_text_widget.dart';
import '../controller/student_profile_controller.dart';
class StudentSlidingFilterScreen extends StatelessWidget {
  const StudentSlidingFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: StudentProfileController(),
      builder: (StudentProfileController controller) =>  Scaffold(
        backgroundColor: Colors.black.withValues(alpha:0.5), // Dim background
        body: SizedBox(
          width: Get.width , // 70% of the screen width

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(color: Colors.transparent),
                ),
              ),
              Container(
                width: Get.width * 0.7, // 70% of the screen width
                color: kLightBlueColor,
                child: Column(
                  children: [
                    AppBar(
                      title:   CustomText( Get.find<StorageService>().activeLocale ==
                          SupportedLocales.english
                          ? "Filtering"
                          : "تصفيه ",style:  TextStyle(
                          fontFamily:  Get.find<StorageService>().activeLocale ==
                              SupportedLocales.english
                              ? fontFamilyEnglishName
                              : fontFamilyArabicName,
                          color: kBlueColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 18),
                      ),
                      backgroundColor:kYellowColor,
                      automaticallyImplyLeading: false,
                    ),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                            color:kYellowColor
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: kLightBlueColor,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30.0),
                                  bottomLeft: Radius.circular(30.0)),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
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
                                                    ? "user type"
                                                    : "نوع المستخدم"
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
                                              maxWidth: Get.width * 0.5,
                                              minWidth: Get.width * 0.5,
                                            ),
                                            itemBuilder: (context) =>
                                                controller.userType.map((e) {
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
                                                      controller.chooseUserType(e);
                                                    },
                                                    child: SizedBox(
                                                      width: Get.width * 0.4,
                                                      child: Column(
                                                        children: [
                                                          CustomText(
                                                            e,
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
                                              padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 0),
                                              child: Container(
                                                constraints: BoxConstraints(
                                                  minHeight: Get.height * 0.06,
                                                ),
                                                width: Get.width * 0.6,
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
                                                        CustomText(
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
                                                            color: Colors.white,
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
                                      controller.chosenUserType == userType2.tr?
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
                                                    ? "choose teacher"
                                                    : "اختر المعلم"
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

                                          PopupMenuButton<StudentShareModel>(
                                            constraints: BoxConstraints(
                                              maxWidth: Get.width * 0.5,
                                              minWidth: Get.width * 0.5,
                                            ),
                                            itemBuilder: (context) =>
                                                controller.teacherList!.map((e) {
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
                                                      controller.choosedTeacher(e);
                                                    },
                                                    child: SizedBox(
                                                      width: Get.width * 0.4,
                                                      child: Column(
                                                        children: [
                                                          CustomText(
                                                            e.name??"",
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
                                                          e == controller.teacherList?.last
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
                                                width: Get.width * 0.6,
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
                                                        CustomText(
                                                          textAlign: TextAlign.center,
                                                          maxLines: 3,
                                                          controller.chosenTeacher==null?Get.find<StorageService>()
                                                              .activeLocale ==
                                                              SupportedLocales.english
                                                              ?"teacher name":"إسم المعلم":controller.chosenTeacher?.name??"",
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
                                                            color: Colors.white,
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
                                      )
                                          :controller.chosenUserType == userType1.tr?
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
                                                    ? "choose parent"
                                                    : "أختر ولى الأمر"
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

                                          PopupMenuButton<ParentShareModel>(
                                            constraints: BoxConstraints(
                                              maxWidth: Get.width * 0.5,
                                              minWidth: Get.width * 0.5,
                                            ),
                                            itemBuilder: (context) =>
                                                controller.parentList!.map((e) {
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
                                                      controller.choosedParent(e);
                                                    },
                                                    child: SizedBox(
                                                      width: Get.width * 0.4,
                                                      child: Column(
                                                        children: [
                                                          CustomText(
                                                            e.name??"",
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
                                                          e == controller.parentList?.last
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
                                                width: Get.width * 0.6,
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
                                                        CustomText(
                                                          textAlign: TextAlign.center,
                                                          maxLines: 3,
                                                          controller.chosenParent==null?Get.find<StorageService>()
                                                              .activeLocale ==
                                                              SupportedLocales.english
                                                              ?"parent name":"إسم ولى الأمر":controller.chosenParent?.name??"",
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
                                                            color: Colors.white,
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
                                      ):
                                      controller.chosenUserType == userType3.tr?
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
                                                    ? "choose student"
                                                    : "أختر الطالب"
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

                                          PopupMenuButton<StudentShareModel>(
                                            constraints: BoxConstraints(
                                              maxWidth: Get.width * 0.5,
                                              minWidth: Get.width * 0.5,
                                            ),
                                            itemBuilder: (context) =>
                                                controller.studentList!.map((e) {
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
                                                      controller.choosedStudent(e);
                                                    },
                                                    child: SizedBox(
                                                      width: Get.width * 0.4,
                                                      child: Column(
                                                        children: [
                                                          CustomText(
                                                            e.name??"",
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
                                                          e == controller.studentList?.last
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
                                                width: Get.width * 0.6,
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
                                                        CustomText(
                                                          textAlign: TextAlign.center,
                                                          maxLines: 3,
                                                          controller.chosenStudent==null?Get.find<StorageService>()
                                                              .activeLocale ==
                                                              SupportedLocales.english
                                                              ?"studennt name":"إسم الطالب":controller.chosenStudent?.name??"",
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
                                                            color: Colors.white,
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
                                      ):
                                      const SizedBox(),
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
                                                    ? "Post type"
                                                    : "نوع المنشور"
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
                                              maxWidth: Get.width * 0.5,
                                              minWidth: Get.width * 0.5,
                                            ),
                                            itemBuilder: (context) =>
                                                controller.postsTypes.map((e) {
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
                                                      controller.choosedPostType(e);
                                                    },
                                                    child: SizedBox(
                                                      width: Get.width * 0.4,
                                                      child: Column(
                                                        children: [
                                                          CustomText(
                                                            e,
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
                                                          e == controller.postsTypes.last
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
                                                width: Get.width * 0.6,
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
                                                        CustomText(
                                                          textAlign: TextAlign.center,
                                                          maxLines: 3,
                                                          controller.chosenPostsType,
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
                                                            color: Colors.white,
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
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 18.0),
                                    child: Column(
                                      children: [
                                        InkWell(
                                          onTap: (){
                                            if(controller.chosenStudent != null || controller.chosenParent != null || controller.chosenTeacher != null ||controller.chosenPostsType!=choosePostType.tr||controller.chosenUserType!=chooseUserKey.tr) {
                                              controller.filteringPostsData();
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 0),
                                            child: Container(
                                              constraints: BoxConstraints(
                                                minHeight: Get.height * 0.06,
                                              ),
                                              width: Get.width * 0.6,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color:(controller.chosenStudent != null || controller.chosenParent != null || controller.chosenTeacher != null ||controller.chosenPostsType!=choosePostType.tr||controller.chosenUserType!=chooseUserKey.tr)? kDarkBlueColor:Colors.grey,
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
                                                    MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      CustomText(
                                                        textAlign: TextAlign.center,
                                                        maxLines: 3,
                                                        Get.find<StorageService>()
                                                            .activeLocale ==
                                                            SupportedLocales.english
                                                            ?"start filtering":"بدء التصفية",
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
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      const Icon(Icons.filter_alt_outlined,
                                                          color: Colors.white, size: 20),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10,),
                                        controller.filteringData?InkWell(
                                          onTap: (){
                                            controller.clearAllTheFilters();
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 0),
                                            child: Container(
                                              constraints: BoxConstraints(
                                                minHeight: Get.height * 0.06,
                                              ),
                                              width: Get.width * 0.6,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(color: kDarkBlueColor,width: 1),
                                                color:kWhiteColor,
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
                                                    MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      CustomText(
                                                        textAlign: TextAlign.center,
                                                        maxLines: 3,
                                                        Get.find<StorageService>()
                                                            .activeLocale ==
                                                            SupportedLocales.english
                                                            ?"delete filtering":"حذف التصفية",
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
                                                      const Icon(Icons.clear,
                                                          color: kDarkBlueColor, size: 20),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ):const SizedBox(),
                                      ],
                                    ),
                                  )
                                ],
                              ),
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
        ),
      ),
    );
  }
}