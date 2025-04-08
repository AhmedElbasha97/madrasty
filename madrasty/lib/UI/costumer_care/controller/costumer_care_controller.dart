
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madrasty/Services/posting_services.dart';
import 'package:madrasty/Services/teacher_services.dart';
import 'package:madrasty/UI/welcome_screen/welcome_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Models/person_info_model.dart';
import '../../../Models/response_model.dart';
import '../../../Models/teacher_info_model.dart';
import '../../../Services/auth_services.dart';
import '../../../Services/biomatrics_auth_services.dart';
import '../../../Utils/localization_services.dart';
import '../../../Utils/memory.dart';
import '../../../Utils/translation_key.dart';
import '../../../Widgets/alert_dialogue.dart';
import '../../../Widgets/yes_or_no_alert_dialogue.dart';
import '../../auth/edit_password/edit_password_screen.dart';

class CostumerCareController extends GetxController{
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  PersonInfoModel? userData;
  TeacherInfoModel? userData2;
  bool isLoading = true;
  @override
  onInit(){
    super.onInit();
    gettingUserData();
  }
  launchURLToWeb(String link,context) async {
    final Uri url = Uri.parse(link);
    if (!await launchUrl(url,mode:LaunchMode.externalNonBrowserApplication)) {
      showDialog(context: context,
          builder: (context) {
            return AlertDialogue(alertTitle: errorKey.tr, alertText:'Could not launch $url',alertIcon: "assets/icons/warningIcon.png",containerHeight:  Get.height*0.4);
          });
    }
  }
  gettingUserData() async {
    if(Get.find<StorageService>().getUserType == "TEACHER"||Get.find<StorageService>().getUserType == "SUPERVISOR"){
      userData2 = await TeacherServices.getTeacherInfoData();
    }else{
      userData = await PostingServices.getPersonInfoData();
    }
    isLoading = false;
    update();
  }
  String detectUserTypeTranslated(String userType){
    String userTypeTranslated = "";
    switch(userType){
      case "TEACHER":{
        userTypeTranslated =userType2.tr;
        update();
      }
      break;
      case "PARENT":{
        userTypeTranslated =userType1.tr;
        update();
      }
      break;
      case "STUDENT":{
        userTypeTranslated = userType3.tr;
        update();
      }
      break;
      case "DRIVER":{
        userTypeTranslated = userType5.tr;
        update();
      }
      break;
      case "SUPERVISOR":{
        userTypeTranslated = userType4.tr;
        update();
      }
      break;
    }

    return userTypeTranslated;

  }

}