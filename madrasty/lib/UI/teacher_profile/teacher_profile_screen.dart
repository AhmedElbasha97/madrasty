// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madrasty/UI/teacher_profile/widget/report_arrival_and_leaving_widget.dart';
import 'package:madrasty/UI/teacher_profile/widget/teacher_class_schedules_screen.dart';
import 'package:madrasty/UI/teacher_profile/widget/teacher_posts_screen.dart';
import '../../Utils/Colors_File.dart';
import '../../Utils/localization_services.dart';
import '../../Utils/memory.dart';
import '../../Utils/translation_key.dart';
import '../academic_and_behavior_recommendation/academic_and_behavior_recommendation_list/academic_and_behavior_recommendation_list_screen.dart';
import '../chat/chat_history/message_screens.dart';
import '../perent_profile_screen/widget/custom_tap_widget.dart';
import 'controller/teacher_profile_controller.dart';

class TeacherProfileScreen extends StatelessWidget {
  const TeacherProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: TeacherProfileController(),
      builder: (TeacherProfileController controller) => Scaffold(

        body:   Container(
            width: Get.width,
            decoration: const BoxDecoration(
              color: kYellowColor,
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                width: Get.width,
                height: Get.height * 0.97,
                decoration: const BoxDecoration(
                  color: Colors.white,
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
                      Container(
                        height: Get.height * 0.12,
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

                      Container(

                        width: Get.width * 0.8,
                        child:  Row(

                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            controller.chosenUserTap1 =='الرسائل الوارده'?Container(
                              width: Get.width*0.2,
                              height: 2,
                              color: kBlueColor,
                            ): SizedBox(width: Get.width*0.2,),
                            controller.chosenUserTap1 =='الرسائل المرسله'?Container(
                              width: Get.width*0.2,
                              height: 2,
                              color: kBlueColor,
                            ): SizedBox(width: Get.width*0.2,),
                            controller.chosenUserTap1 =='ارسال رساله'? Container(
                              width: Get.width*0.2,
                              height: 2,
                              color: kBlueColor,
                            ): SizedBox(width: Get.width*0.2,),
                          ],
                        ),
                      ),
                      controller.chosenUserTap ==   parentTap7.tr
                          ?const MessageScreens():const SizedBox(),
                      controller.chosenUserTap == ( Get.find<StorageService>()
                          .activeLocale ==
                          SupportedLocales.english
                          ? 'Attendance Report'
                          :'تقرير الحضور والغياب')
                          ?const ReportArrivalAndLeavingWidget():
                      controller.chosenUserTap == parentTap6.tr ? const TeacherPostsScreen():
                      controller.chosenUserTap == parentTap3.tr?const TeacherClassSchedulesScreen():controller.chosenUserTap == parentTap2.tr? AcademicAndBehaviorRecommendationListScreen(kidId: Get
                          .find<StorageService>()
                          .getId,):
                      const SizedBox(),
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
