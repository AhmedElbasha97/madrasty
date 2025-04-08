// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madrasty/Widgets/custom_text_widget.dart';
import 'package:madrasty/Widgets/loader.dart';

import '../../Utils/Colors_File.dart';
import '../../Utils/constant.dart';
import '../../Utils/localization_services.dart';
import '../../Utils/memory.dart';
import '../../Widgets/DrawerWidget.dart';
import 'controller/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ProfileController(),
      builder: (ProfileController controller) => Scaffold(
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
        key: controller.scaffoldState,
        drawer: AppDrawers(
          scaffoldKey: controller.scaffoldState,
        ),
        body:controller.isLoading?const Loader(): Container(
          width: Get.width,
          height: Get.height,
          decoration: const BoxDecoration(
            color: kYellowColor,
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              width: Get.width,
              height: Get.height * 0.97,
              decoration: const BoxDecoration(
                color: kLightBlueColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    topLeft: Radius.circular(30.0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: Get.width,
                    child: Column(
                      children: [
                        Row(

                          children: [
                            const SizedBox(width: 10,),
                            InkWell(
                              onTap: () {},
                              child: Container(
                                height: Get.height * 0.3,
                                width: Get.width * 0.3,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/backgroundImage.png"),
                                      fit: BoxFit.cover),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: Get.height * 0.15,
                                      width: Get.width * 0.25,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: kDarkBlueColor,
                                        boxShadow: [
                                          BoxShadow(
                                            color: kGrayColor,
                                            blurRadius: 2,
                                            offset:
                                            Offset(1, 1), // Shadow position
                                          ),
                                        ],
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/27002.jpg"),
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(Get.find<StorageService>().getUserType == "TEACHER"||Get.find<StorageService>().getUserType == "SUPERVISOR"?
                                  controller.userData2?.name??"":controller.userData?.name??""
                                  ,style:  TextStyle(
                                    fontFamily:  Get.find<StorageService>().activeLocale ==
                                        SupportedLocales.english
                                        ? fontFamilyEnglishName
                                        : fontFamilyArabicName,
                                    color: kDarkBlueColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17),
                                ),
                                const SizedBox(height: 5,),
                                CustomText(controller.detectUserTypeTranslated(Get.find<StorageService>().getUserType),style:  TextStyle(
                                    fontFamily:  Get.find<StorageService>().activeLocale ==
                                        SupportedLocales.english
                                        ? fontFamilyEnglishName
                                        : fontFamilyArabicName,
                                    color: kDarkBlueColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17),
                                ),

                                const SizedBox(height: 5,),
                              ],
                            )
                          ],
                        ),

                        const Divider(
                          color: kYellowColor,
                          height: 1,
                          thickness: 2,
                          endIndent: 0,
                          indent: 0,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [


                      InkWell(
                        onTap: (){
                          controller.goToChangePass();
                        },
                        child: Container(
                          width: Get.width,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.password,color: kDarkBlueColor,),
                                  const SizedBox(width: 5,),
                                  CustomText(Get.find<StorageService>()
                                      .activeLocale ==
                                      SupportedLocales.english
                                      ?"Change Password":"تعديل كلمه السر"
                                    ,style:  TextStyle(
                                      fontFamily:  Get.find<StorageService>().activeLocale ==
                                          SupportedLocales.english
                                          ? fontFamilyEnglishName
                                          : fontFamilyArabicName,
                                      color: kDarkBlueColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 17),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10,),
                              const Divider(
                                color: kYellowColor,
                                height: 1,
                                thickness: 2,
                                endIndent: 0,
                                indent: 0,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 5,),
                      InkWell(
                        onTap: (){
                          controller.showingActionForLogOut( context);
                        },
                        child: Container(
                          width: double.infinity,
                          height: 35,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.logout,color: kDarkBlueColor,),
                                  const SizedBox(width: 5,),
                                  CustomText(Get.find<StorageService>()
                                      .activeLocale ==
                                      SupportedLocales.english
                                      ?"Log out":"تسجيل خروج"
                                    ,style:  TextStyle(
                                        fontFamily:  Get.find<StorageService>().activeLocale ==
                                            SupportedLocales.english
                                            ? fontFamilyEnglishName
                                            : fontFamilyArabicName,
                                        color: kDarkBlueColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 17),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10,),
                              const Divider(
                                color: kYellowColor,
                                height: 1,
                                thickness: 2,
                                endIndent: 0,
                                indent: 0,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 5,),
                      InkWell(
                        onTap: (){
                          controller. showingActionForDeletingTheAccount( context);
                        },
                        child: Container(
                          width: double.infinity,
                          height: 35,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.delete,color: kDarkBlueColor,),
                                  const SizedBox(width: 5,),
                                  CustomText(Get.find<StorageService>()
                                      .activeLocale ==
                                      SupportedLocales.english
                                      ?"deleting the account":"حذف الحساب"
                                    ,style:  TextStyle(
                                        fontFamily:  Get.find<StorageService>().activeLocale ==
                                            SupportedLocales.english
                                            ? fontFamilyEnglishName
                                            : fontFamilyArabicName,
                                        color: kDarkBlueColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 17),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10,),
                              const Divider(
                                color: kYellowColor,
                                height: 1,
                                thickness: 2,
                                endIndent: 0,
                                indent: 0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
