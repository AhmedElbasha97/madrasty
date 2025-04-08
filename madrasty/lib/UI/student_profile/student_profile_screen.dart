// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madrasty/UI/academic_and_behavior_recommendation/academic_and_behavior_recommendation_list/academic_and_behavior_recommendation_list_screen.dart';
import 'package:madrasty/UI/perent_profile_screen/widget/custom_tap_widget.dart';
import 'package:madrasty/UI/student_profile/widget/student_attendance_sheet.dart';
import 'package:madrasty/UI/student_profile/widget/student_posts_screen.dart';
import 'package:madrasty/UI/student_profile/widget/student_teaching_schadules_screen.dart';

import '../../Utils/Colors_File.dart';
import '../../Utils/memory.dart';
import '../../Utils/translation_key.dart';
import '../chat/chat_history/message_screens.dart';
import 'controller/student_profile_controller.dart';

class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: StudentProfileController(),
      builder: (StudentProfileController controller) => Scaffold(
        body:  Container(
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
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                            child:  const Padding(
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
                    controller.chosenUserTap == parentTap1.tr?const StudentAttendanceSheet():controller.chosenUserTap == parentTap7.tr?const MessageScreens():controller.chosenUserTap == parentTap6.tr? const StudentPostsScreen():controller.chosenUserTap == parentTap3.tr?const StudentTeachingSchadulesScreen():controller.chosenUserTap == parentTap2.tr? AcademicAndBehaviorRecommendationListScreen(kidId: Get
                        .find<StorageService>()
                        .getId,): const SizedBox(),

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
