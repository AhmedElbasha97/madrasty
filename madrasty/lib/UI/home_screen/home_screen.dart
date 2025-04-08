
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madrasty/UI/perent_profile_screen/perent_profile_screen.dart';
import 'package:madrasty/UI/school_list/school_list_screen.dart';
import 'package:madrasty/Utils/Colors_File.dart';

import '../../Utils/memory.dart';
import '../../Widgets/DrawerWidget.dart';

import '../driver_profile/driver_profile_screen.dart';
import '../profile_screen/profile_screen.dart';
import '../sepervisor_profile/supervisor_profile_screen.dart';
import '../student_profile/student_profile_screen.dart';
import '../teacher_profile/teacher_profile_screen.dart';
import 'controller/home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: HomeController(),
      builder: (HomeController controller) => Scaffold(
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
                Get.to(() => const ProfileScreen(),
                    transition: Transition.rightToLeftWithFade);              },
              child: Image.asset(
                "assets/icons/profile_icon.png",
                fit: BoxFit.contain,
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 0.07,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            InkWell(
              onTap: () {
                Get.to(() => const SchoolListScreen(),
                    transition: Transition.rightToLeftWithFade);              },
              child: Image.asset(
                "assets/icons/search_icon.png",
                fit: BoxFit.contain,
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 0.07,
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
        body: Get.find<StorageService>().getUserType == "TEACHER"?const TeacherProfileScreen():Get.find<StorageService>().getUserType == "PARENT"?const PerentProfileScreen():Get.find<StorageService>().getUserType == "STUDENT"?const StudentProfileScreen():Get.find<StorageService>().getUserType == "SUPERVISOR"?const SupervisorProfileScreen():Get.find<StorageService>().getUserType == "DRIVER"?const DriverProfileScreen():const SchoolListScreen(),

      ),
    );
  }
}
