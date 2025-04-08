import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:madrasty/UI/auth/sign_in/sign_in_screen.dart';
import 'package:madrasty/UI/auth/sign_up/sign_up_screen.dart';
import 'package:madrasty/UI/home_screen/home_screen.dart';

import '../../../../Utils/memory.dart';
import '../../../../Utils/translation_key.dart';
import '../../../../Widgets/alert_dialogue.dart';
import '../../edit_password/edit_password_screen.dart';
import '../../sign_up/detect_phone_number_screen.dart';

class OTPController extends GetxController{
  final formKey = GlobalKey<FormState>();
  final  bool comingFromSignUp;
  final  bool comingFromForgetPassword;
  OTPController(this.comingFromSignUp, this.comingFromForgetPassword, );
  late TextEditingController textController1;

  late FocusNode text1FocusNode ;



  @override
  void onInit() {
    super.onInit();
    textController1 = TextEditingController();

    text1FocusNode = FocusNode();

    checkForUpgrades();
  }

  @override
  void onClose() {
    textController1.dispose();

    text1FocusNode.dispose();

    super.onClose();
  }

  void clear() {
    textController1.clear();

  }
  checkForUpgrades() {
    InAppUpdate.checkForUpdate().then((updateInfo) {
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        if (updateInfo.immediateUpdateAllowed) {
          // Perform immediate update
          InAppUpdate.performImmediateUpdate().then((appUpdateResult) {
            if (appUpdateResult == AppUpdateResult.success) {
              //App Update successful
            }
          });
        } else if (updateInfo.flexibleUpdateAllowed) {
          //Perform flexible update
          InAppUpdate.startFlexibleUpdate().then((appUpdateResult) {
            if (appUpdateResult == AppUpdateResult.success) {
              //App Update successful
              InAppUpdate.completeFlexibleUpdate();
            }
          });
        }
      }
    });
  }
  getBackToAnotherScreen(BuildContext context) async {
    bool checker = await Navigator.maybePop(context);
    if(!checker){
      if(comingFromSignUp) {
        Get.to(()=>const DetectPhoneNumberScreen());
      }else{
        Get.to(()=>const SignInScreen());
      }
    }
  }
  checkOtp(BuildContext context) async {
    if(textController1.text ==  Get.find<StorageService>().getUserOtp){
      textController1.clear();
      if(comingFromForgetPassword){
        await Get.find<StorageService>().removeOtpCode();
        await Get.find<StorageService>().saveCheckerForgettingPassword(false);

        await Get.to(()=> const EditPasswordScreen(comingFromForgetPassword: true,));


      }else if(comingFromSignUp){
        await Get.find<StorageService>().removeOtpCode();

      await Get.find<StorageService>().saveCheckerCompletingUserData(true);
        await Get.to(()=> const SignUpScreen());

      }else{
        await Get.find<StorageService>().removeOtpCode();
        await Get.to(()=> const HomeScreen());
      }
    }else{
      showDialog(context: context,
          builder: (context) {
            return AlertDialogue(alertTitle: errorKey.tr, alertText: otpAlert.tr,alertIcon: "assets/icons/warningIcon.png",containerHeight:  Get.height*0.4);
          }
      );
    }
  }
}