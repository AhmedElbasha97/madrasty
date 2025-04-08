// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:madrasty/UI/perent_profile_screen/widget/custom_tap_widget.dart';
import 'package:madrasty/UI/perent_profile_screen/widget/driver_widget.dart';
import 'package:madrasty/UI/perent_profile_screen/widget/parent_attendance_screen.dart';
import 'package:madrasty/UI/perent_profile_screen/widget/parent_class_schedules_screen.dart';
import 'package:madrasty/UI/perent_profile_screen/widget/parent_posts_widget_screen.dart';
import '../../Models/kids_model.dart';
import '../../Utils/Colors_File.dart';
import '../../Utils/constant.dart';
import '../../Utils/localization_services.dart';
import '../../Utils/memory.dart';
import '../../Utils/translation_key.dart';
import '../../Widgets/custom_text_widget.dart';
import '../academic_and_behavior_recommendation/academic_and_behavior_recommendation_list/academic_and_behavior_recommendation_list_screen.dart';
import '../chat/chat_history/message_screens.dart';
import 'controller/perent_profile_controller.dart';

class PerentProfileScreen extends StatelessWidget {
  const PerentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: PerentProfileController(),
      builder: (PerentProfileController controller) => Scaffold(

        body: Container(
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    controller.isLoading?Column(
                      children: [
                        const SizedBox(height: 10,),
                        Container(
                          height: Get.height * 0.07,
                          width: Get.width * 0.45,
                          decoration:  BoxDecoration(
                              borderRadius: BorderRadius.circular(10),

                              color: const Color(0xFFDFDDDF)

                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                height: Get.height * 0.065,
                                width: Get.width * 0.45,
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
                    PopupMenuButton<KidsModel>(
                      constraints: BoxConstraints(
                        maxWidth: Get.width * 0.45,
                        minWidth: Get.width * 0.45,
                      ),
                      itemBuilder: (context) => controller.kidsData!.map((e) {
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
                            controller.choosingAnotherKid(e);
                          },
                          child: SizedBox(
                            width: Get.width * 0.45,
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
                                e == controller.kidsData?.last
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
                        padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                        child: Container(
                          constraints: BoxConstraints(
                            minHeight: Get.height * 0.06,
                          ),
                          width: Get.width * 0.7,
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
                                    width: Get.width * 0.6,
                                    child: CustomText(
                                      textAlign: TextAlign.center,
                                      maxLines: 3,
                                      Get.find<StorageService>()
                                          .activeLocale ==
                                          SupportedLocales.english
                                          ? "chosen student: ${controller.chosenKids?.name??""}"
                                          : "الطالب المختار: ${controller.chosenKids?.name??""}",
                                      style: TextStyle(
                                        shadows: <Shadow>[
                                          Shadow(
                                              offset: const Offset(0.5, 0.5),
                                              blurRadius: 0.5,
                                              color: Colors.black
                                                  .withValues(alpha:0.5)),
                                        ],
                                        fontSize: 15,
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
                                  const Icon(Icons.arrow_downward_sharp,
                                      color: Colors.white, size: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: Get.height * 0.14,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              controller.getPreviousTap();
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: kDarkBlueColor,
                                size: 35,
                              ),
                            ),
                          ),
                          Container(
                            width: Get.width*0.8,
                            child: SingleChildScrollView(
                              scrollDirection:Axis.horizontal,
                              child: Row(
                                children: [
                                  InkWell(
                                      onTap: () {
                                        controller.choosingUserTap(controller.userTaps[
                                        controller.chosenUserTapIndicator]);
                                      },
                                      child: CustomTapWidget(
                                        chosenOrNot: controller.userTaps[
                                        controller.chosenUserTapIndicator] ==
                                            controller.chosenUserTap,
                                        title: controller.userTaps[
                                        controller.chosenUserTapIndicator],
                                      )),
                                  InkWell(
                                      onTap: () {
                                        controller.choosingUserTap(controller.userTaps[
                                        controller.chosenUserTapIndicator + 1]);
                                      },
                                      child: CustomTapWidget(
                                        chosenOrNot: controller.userTaps[
                                        controller.chosenUserTapIndicator +
                                            1] ==
                                            controller.chosenUserTap,
                                        title: controller.userTaps[
                                        controller.chosenUserTapIndicator + 1],
                                      )),
                                  InkWell(
                                      onTap: () {
                                        controller.choosingUserTap(controller.userTaps[
                                        controller.chosenUserTapIndicator + 2]);
                                      },
                                      child: CustomTapWidget(
                                        chosenOrNot: controller.userTaps[
                                        controller.chosenUserTapIndicator +
                                            2] ==
                                            controller.chosenUserTap,
                                        title: controller.userTaps[
                                        controller.chosenUserTapIndicator + 2],
                                      )),
                                ],
                              ),
                            ),
                          ),

                          InkWell(
                            onTap: () {
                              controller.getNextTap();
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: kDarkBlueColor,
                                size: 35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),


                    controller.chosenUserTap == parentTap1.tr?const ParentAttendanceScreen():controller.chosenUserTap == parentTap7.tr?const MessageScreens():controller.chosenUserTap == parentTap4.tr?const DriverWidget(): controller.chosenUserTap == parentTap2.tr? AcademicAndBehaviorRecommendationListScreen(kidId: "${controller.chosenKids?.id??0}",):controller.chosenUserTap == parentTap6.tr? const ParentPostScreenWidget()

                        :controller.chosenUserTap == parentTap3.tr?const ParentClassSchedulesScreen():const SizedBox()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}
