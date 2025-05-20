import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:madrasty/UI/auth/sign_in/sign_in_screen.dart';
import 'package:madrasty/UI/auth/sign_up/sign_up_screen.dart';
import 'package:madrasty/UI/home_screen/home_screen.dart';

import '../../../../Models/response_model.dart';
import '../../../../Services/auth_services.dart';
import '../../../../Utils/localization_services.dart';
import '../../../../Utils/memory.dart';
import '../../../../Utils/translation_key.dart';
import '../../../../Widgets/alert_dialogue.dart';
import '../../../../Widgets/loading_alert_dialogue.dart';
import '../../edit_password/edit_password_screen.dart';
import '../../sign_up/detect_phone_number_screen.dart';

class OTPController extends GetxController{
  final formKey = GlobalKey<FormState>();
  final  bool comingFromSignUp;
  final  bool comingFromForgetPassword;
  OTPController(this.comingFromSignUp, this.comingFromForgetPassword, );
  late TextEditingController textController1;
  Timer? _timer;
  bool isResendingOTPCode = false;
  late FocusNode text1FocusNode ;
  RxInt remainingSeconds = 60.obs;


  @override
  void onInit() {
    super.onInit();
    textController1 = TextEditingController();

    text1FocusNode = FocusNode();
    checkForUpgrades();
    startTimer();
  }

  @override
  void onClose() {
    textController1.dispose();

    text1FocusNode.dispose();
    _timer?.cancel();
    super.onClose();
  }

  void clear() {
    textController1.clear();

  }
  void resetTimer() {
    startTimer();
  }

  checkForUpgrades() async {

    try {
      final updateInfo = await InAppUpdate.checkForUpdate();

      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        // يوجد تحديث متاح، تقدر تختار:
        // 1. Immediate (تحديث إجباري)
        // 2. Flexible (تحديث اختياري)

        // مثال على التحديث الفوري:
        InAppUpdate.performImmediateUpdate();

        // أو لو تفضل تحديث مرن:
        // InAppUpdate.startFlexibleUpdate().then((_) {
        //   InAppUpdate.completeFlexibleUpdate();
        // });
      }
    } catch (e) {
      print("Error checking for update: $e");
    }
  }
  void startTimer() {
    remainingSeconds.value = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        timer.cancel();
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
  resendingCode(BuildContext context) async {

    if(isResendingOTPCode){
      showDialog(context: context,
          builder: (context) {
            return const LoadingAlertDialogue();
          });
    }else {

      ResponseModel? data = await AuthServices.resendNewOTP();
      isResendingOTPCode = true;
      update();
      print(data?.msg);
      if (data?.msg == "succeeded") {
        final snackBar = SnackBar(content:
        Row(children: [
          const Icon(Icons.check, color: Colors.white,),
          const SizedBox(width: 10,),
          Text(Get
              .find<StorageService>()
              .activeLocale ==
              SupportedLocales.english
              ? 'The OTP Code has been sent successfully'
              : 'تم إرسال رمز التحقق بنجاح', style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),
          ),
        ],),
            backgroundColor: Colors.green
        );
        update();
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        isResendingOTPCode = false;
        resetTimer();
        update();
      }
      else {
        update();
        final snackBar = SnackBar(content:
        Row(children: [
          const Icon(Icons.close, color: Colors.white,),
          const SizedBox(width: 10,),
          Text(Get
              .find<StorageService>()
              .activeLocale ==
              SupportedLocales.english
              ? 'An error occurred while Resending the otp code'
              : 'حدث خطأ أثناء إعادة إرسال رمز التحقق', style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),
          ),
        ],),
            backgroundColor: Colors.red
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        isResendingOTPCode = false;
        resetTimer();
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