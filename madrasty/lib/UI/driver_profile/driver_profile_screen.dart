import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madrasty/UI/driver_profile/widgets/driver_screen_widdget.dart';

import '../../Utils/Colors_File.dart';
import '../../Utils/translation_key.dart';
import '../chat/chat_history/message_screens.dart';
import '../perent_profile_screen/widget/custom_tap_widget.dart';
import 'controller/driver_profile_controller.dart';

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: DriverProfileController(),
      builder: (DriverProfileController controller) => Scaffold(

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
                    const SizedBox(height: 10,),
                    SizedBox(
                      height: Get.height * 0.14,
                      width: Get.width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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



                        ],
                      ),
                    ),


                    controller.chosenUserTap == parentTap7.tr?const MessageScreens():controller.chosenUserTap == parentTap4.tr?const DriverScreenWidget(): const SizedBox()
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
