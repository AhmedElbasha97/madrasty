import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madrasty/UI/sepervisor_profile/widget/attendance_table_widget_screen.dart';
import 'package:madrasty/UI/sepervisor_profile/widget/class_supervisor_widget_screen.dart';

import '../../Utils/Colors_File.dart';
import '../../Utils/translation_key.dart';
import '../chat/chat_history/message_screens.dart';
import '../perent_profile_screen/widget/custom_tap_widget.dart';
import 'controller/supervisor_profile_controller.dart';

class SupervisorProfileScreen extends StatelessWidget {
  const SupervisorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: SupervisorProfileController(),
      builder: (SupervisorProfileController controller) => Scaffold(

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
                      height: 10,
                    ),
                    SizedBox(
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
                          SizedBox(
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


                    controller.chosenUserTap == parentTap7.tr?const MessageScreens():controller.chosenUserTap == parentTap3.tr?const ClassSupervisorWidgetScreen():controller.chosenUserTap == parentTap1.tr?const AttendanceTableWidgetScreen(): const SizedBox()
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
