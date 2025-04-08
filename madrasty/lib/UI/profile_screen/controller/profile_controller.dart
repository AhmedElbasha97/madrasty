// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madrasty/Services/posting_services.dart';
import 'package:madrasty/Services/teacher_services.dart';
import 'package:madrasty/UI/welcome_screen/welcome_screen.dart';

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

class ProfileController extends GetxController{
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  PersonInfoModel? userData;
  TeacherInfoModel? userData2;
  bool isLoading = true;
  @override
  onInit(){
    super.onInit();
    gettingUserData();
  }
  showingActionForLogOut(BuildContext context){
    showDialog(context: context,
        builder: (context) {
          return YesOrNoAlertDialogue(alertTitle: Get.find<StorageService>().activeLocale ==
              SupportedLocales.english
              ? "Alert"
              :"تنبيه", alertText: Get.find<StorageService>().activeLocale ==
              SupportedLocales.english
              ? "do you want to log out?"
              :"هل تريد تسجيل الخروج؟",alertIcon: "assets/icons/warningIcon.png",containerHeight:  Get.height*0.4, yesAlertText: Get.find<StorageService>().activeLocale ==
              SupportedLocales.english
              ? "log out"
              :'تسجيل خروج', noAlertText: Get.find<StorageService>().activeLocale ==
              SupportedLocales.english
              ? "cancel"
              :"إلغاء", yesSendPress: () {loggingOut();}, noSendPress: () { Get.back(); },);         }
    );
  }
  showingActionForDeletingTheAccount(BuildContext context){
    showDialog(context: context,
        builder: (context) {
          return YesOrNoAlertDialogue(alertTitle: Get.find<StorageService>().activeLocale ==
              SupportedLocales.english
              ? "Alert"
              :"تنبيه", alertText: Get.find<StorageService>().activeLocale ==
              SupportedLocales.english
              ? "do you want to delete your account?"
              :"هل تريد حذف حسابك؟",alertIcon: "assets/icons/warningIcon.png",containerHeight:  Get.height*0.4, yesAlertText: Get.find<StorageService>().activeLocale ==
              SupportedLocales.english
              ? "yes"
              :'نعم', noAlertText: Get.find<StorageService>().activeLocale ==
              SupportedLocales.english
              ? "no"
              :"لا", yesSendPress: () {

            deleteYourAccount( context);
            }, noSendPress: () { Get.back(); },);         }
    );
  }
  deleteYourAccount(BuildContext context) async {
    if(await BiomatricsAuthService.authenticateUser(Get.find<StorageService>()
    .activeLocale ==
    SupportedLocales.english
    ?"delete the account":"حذف حسابك")) {
      ResponseModel? data = await AuthServices.deleteAccount();

        if(data?.status == "true"){
          loggingOut();
          final snackBar = SnackBar(content:
          Row(children: [
            const Icon(Icons.check, color: Colors.white,),
            const SizedBox(width: 10,),
            Text(Get
                .find<StorageService>()
                .activeLocale ==
                SupportedLocales.english
                ? 'account has been deleted successfully'
                : 'تم حذف الحساب بنجاح ', style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold
            ),
            ),
          ],),
              backgroundColor: Colors.green
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);

        }else{


          showDialog(context: context,
              builder: (context) {
                return AlertDialogue(alertTitle: errorKey.tr, alertText: data?.msg??"",alertIcon: "assets/icons/warningIcon.png",containerHeight:  Get.height*0.4);
              }
          );}



    }
  }
  goToChangePass() async {
    if(await BiomatricsAuthService.authenticateUser(Get.find<StorageService>()
        .activeLocale ==
        SupportedLocales.english
        ?"Change password":"تغير كلمه السر")) {
      Get.to(()=>const EditPasswordScreen(comingFromForgetPassword: false,));
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
  loggingOut(){
    Get.find<StorageService>().loggingOut();
    Get.offAll(()=>const WelcomeScreen());
  }
}