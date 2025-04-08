// ignore_for_file: sized_box_for_whitespace, prefer_is_empty

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madrasty/Widgets/loader.dart';
import '../../Models/school_filter_model.dart';
import '../../Utils/Colors_File.dart';
import '../../Utils/constant.dart';
import '../../Utils/localization_services.dart';
import '../../Utils/memory.dart';
import '../../Widgets/DrawerWidget.dart';
import '../../Widgets/custom_text_widget.dart';
import '../../Widgets/no_data_widget.dart';
import 'controller/school_list_controller.dart';

class SchoolListScreen extends StatelessWidget {
  const SchoolListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: SchoolListController(),
      builder: (SchoolListController controller) => Scaffold(
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
          leading:Get.find<StorageService>().getId!="0"? InkWell(
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
          ):Container(),
          backgroundColor: kYellowColor,
          title: Image.asset(
            "assets/images/appMultiColorLogoWithoutbackground.png",
            fit: BoxFit.fitHeight,
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.3,
          ),
          centerTitle: true,
        ),
        body: Container(
          width: Get.width,
          height: Get.height,
          decoration: const BoxDecoration(
            color: kYellowColor,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                controller.isLoading?Container():Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    PopupMenuButton<SchoolFilterModel>(
                      constraints: BoxConstraints(
                        maxWidth: Get.width * 0.45,
                        minWidth: Get.width * 0.45,
                      ),
                      itemBuilder: (context) =>
                          controller.userType!.map((e) {
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
                                controller.choosingFilterType(e,context);
                              },
                              child: SizedBox(
                                width: Get.width * 0.45,
                                child: Column(
                                  children: [
                                    CustomText(
                                      Get.find<StorageService>()
                                          .activeLocale ==
                                          SupportedLocales.english
                                          ?e.titleEn??"":e.title??"",
                                      style: TextStyle(
                                          color: kDarkBlueColor,
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
                                    e == controller.userType?.last
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
                      color: kWhiteColor,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 0),
                        child: Container(
                          constraints: BoxConstraints(
                            minHeight: Get.height * 0.06,
                          ),
                          width: Get.width * 0.3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: kWhiteColor,
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
                                    width: Get.width * 0.2,
                                    child: CustomText(
                                      textAlign: TextAlign.center,
                                      maxLines: 3,
                                      controller.chosenFilterType==null?Get.find<StorageService>()
                                          .activeLocale ==
                                          SupportedLocales.english
                                          ?"Choose the type of school":"أختر نوع المدرسه":Get.find<StorageService>()
                                          .activeLocale ==
                                          SupportedLocales.english
                                          ?controller.chosenFilterType?.titleEn??"":controller.chosenFilterType?.title??"",
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
                                  ),
                                  const Icon(Icons.arrow_downward_sharp,
                                      color: kDarkBlueColor, size: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    PopupMenuButton<SchoolFilterModel>(
                      constraints: BoxConstraints(
                        maxWidth: Get.width * 0.45,
                        minWidth: Get.width * 0.45,
                      ),
                      itemBuilder: (context) =>
                          controller.userType1!.map((e) {
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
                                controller.choosingFilterStage(e,context);
                              },
                              child: SizedBox(
                                width: Get.width * 0.45,
                                child: Column(
                                  children: [
                                    CustomText(
                                      Get.find<StorageService>()
                                          .activeLocale ==
                                          SupportedLocales.english
                                          ?e.titleEn??"":e.title??"",
                                      style: TextStyle(
                                          color: kDarkBlueColor,
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
                                    e == controller.userType1?.last
                                        ? const SizedBox()
                                        : Divider(
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
                      color: kWhiteColor,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 0),
                        child: Container(
                          constraints: BoxConstraints(
                            minHeight: Get.height * 0.06,
                          ),
                          width: Get.width * 0.3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: kWhiteColor,
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
                                    width: Get.width * 0.2,
                                    child: CustomText(
                                      textAlign: TextAlign.center,
                                      maxLines: 3,
                                        controller.chosenFilterStage==null?Get.find<StorageService>()
                                            .activeLocale ==
                                            SupportedLocales.english
                                            ?"Choose the academic stage":"أختر المرحله الدراسيه":Get.find<StorageService>()
                                            .activeLocale ==
                                            SupportedLocales.english
                                            ?controller.chosenFilterStage?.titleEn??"":controller.chosenFilterStage?.title??"",
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
                                  ),
                                  const Icon(Icons.arrow_downward_sharp,
                                      color: kDarkBlueColor, size: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    PopupMenuButton<SchoolFilterModel>(
                      constraints: BoxConstraints(
                        maxWidth: Get.width * 0.45,
                        minWidth: Get.width * 0.45,
                      ),
                      itemBuilder: (context) =>
                          controller.userType2!.map((e) {
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
                                controller.choosingFilterZone(e,context);
                              },
                              child: SizedBox(
                                width: Get.width * 0.45,
                                child: Column(
                                  children: [
                                    CustomText(
                                      Get.find<StorageService>()
                                          .activeLocale ==
                                          SupportedLocales.english
                                          ?e.titleEn??"":e.title??"",
                                      style: TextStyle(
                                          color: kDarkBlueColor,
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
                                    e == controller.userType2?.last
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
                      color: kWhiteColor,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 0),
                        child: Container(
                          constraints: BoxConstraints(
                            minHeight: Get.height * 0.06,
                          ),
                          width: Get.width * 0.3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: kWhiteColor,
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
                                    width: Get.width * 0.2,
                                    child: CustomText(
                                      textAlign: TextAlign.center,
                                      maxLines: 3,
                                        controller.chosenFilterZone==null?Get.find<StorageService>()
                                            .activeLocale ==
                                            SupportedLocales.english
                                            ?"Select region":"أختر المنطقه":Get.find<StorageService>()
                                            .activeLocale ==
                                            SupportedLocales.english
                                            ?controller.chosenFilterZone?.titleEn??"":controller.chosenFilterZone?.title??"",
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
                                  ),
                                  const Icon(Icons.arrow_downward_sharp,
                                      color: kDarkBlueColor, size: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: Get.height * 0.06,
                    ),
                    width: Get.width ,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: kWhiteColor,
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
                          Image.asset(
                          "assets/icons/search_textfield_icon.png",
                          fit: BoxFit.contain,
                          height: MediaQuery.of(context).size.height *
                              0.04,
                          width: MediaQuery.of(context).size.width *
                              0.05,
                        ),


                            Container(
                              width: Get.width * 0.8,
                              child: TextField (
                                controller: controller.searchController,
                                onEditingComplete: (){
                                  controller.startSearching(context);
                                },
                                decoration: InputDecoration(

                                    border: InputBorder.none,
                                    labelText:Get.find<StorageService>()
                                        .activeLocale ==
                                        SupportedLocales.english
                                        ? "schools": 'المدارس',

                                  labelStyle: TextStyle(
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
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    width: Get.width,
                    height: Get.height * 0.71,
                    decoration: const BoxDecoration(
                      color: kLightBlueColor,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30.0),
                          topLeft: Radius.circular(30.0)),
                    ),
                    child:controller.isLoading?Loader(width: Get.width*0.9,
                      height: Get.height * 0.7,): controller.schools.length == 0?controller.isSearchActive&&controller.searchController.text!=""?NoDataWidget(refreshedFunc: (){}, text: 'لا يوجد مدارس مسجله بهزا الأسم حتى الأن', imgPath: "assets/images/no_search_data.png", hasRefreshButtonOrNot: false,):
                    NoDataWidget(refreshedFunc: (){}, text: 'لا يوجد مدارس مسجله حتى الأن', imgPath: "assets/images/No data-cuate.png", hasRefreshButtonOrNot: false,):SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:
                          controller.schools
                        ,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
