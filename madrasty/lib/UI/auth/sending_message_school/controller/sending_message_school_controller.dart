// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:madrasty/Services/auth_services.dart';
import 'package:madrasty/UI/welcome_screen/welcome_screen.dart';

import '../../../../Models/auth_model.dart';
import '../../../../Models/school_model.dart';
import '../../../../Services/school_services.dart';
import '../../../../Utils/localization_services.dart';
import '../../../../Utils/memory.dart';
import '../../../../Utils/translation_key.dart';
import '../../../../Widgets/alert_dialogue.dart';

class SendingMessageSchoolController extends GetxController{
  late TextEditingController textController1;
  final formKey = GlobalKey<FormState>();
  late List<SchoolModel>? schoolsListData;
  bool isLoading = false;
  final String phoneNumber;
  SchoolModel? selectedSchool;
  late FocusNode text1FocusNode;

  SendingMessageSchoolController(this.phoneNumber, );

  @override
  void onInit() {
    super.onInit();
    textController1 = TextEditingController();
    text1FocusNode = FocusNode();
    getData();
    checkForUpgrades();
  }
  getData() async {
    schoolsListData = await SchoolServices.getSchoolsList();
    isLoading = false;
    update();
  }
  selectingSchool(SchoolModel chosenSchool){
    selectedSchool = chosenSchool;
    update();
  }
  sendingMessage(BuildContext context) async {
isLoading = true;
update();
      if (selectedSchool != null) {
        if(textController1.text != "") {
          AuthModel? data = await AuthServices.sendingMessageToSchool(
              "${selectedSchool?.id ?? 0}", textController1.text, phoneNumber);
          if (data?.status == "true") {
            final snackBar = SnackBar(content:
            Row(children: [
              const Icon(Icons.check, color: Colors.white,),
              const SizedBox(width: 10,),
              Text(Get
                  .find<StorageService>()
                  .activeLocale ==
                  SupportedLocales.english
                  ? 'The message has been sent to the school'
                  : 'تم أرسال الرساله للمدرسه بنجاح', style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              ),
              ),
            ],),
                backgroundColor: Colors.green
            );
            isLoading = false;
            update();
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Get.to(() => const WelcomeScreen());
          }
          else {
            isLoading = false;
            update();
            final snackBar = SnackBar(content:
            Row(children: [
              const Icon(Icons.close, color: Colors.white,),
              const SizedBox(width: 10,),
              Text(Get
                  .find<StorageService>()
                  .activeLocale ==
                  SupportedLocales.english
                  ? 'An error occurred while sending the message'
                  : 'حدث خطاء أثناء أرسال الرساله', style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              ),
              ),
            ],),
                backgroundColor: Colors.red
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        }else{
          isLoading = false;
          update();
          showDialog(context: context,
              builder: (context) {
                return AlertDialogue(alertTitle: errorKey.tr,
                    alertText: "يجب أدخال الرساله التى تريد أرساله",
                    alertIcon: "assets/icons/warningIcon.png",
                    containerHeight: Get.height * 0.4);
              }
          );
        }
      } else {
        isLoading = false;
        update();
        showDialog(context: context,
            builder: (context) {
              return AlertDialogue(alertTitle: errorKey.tr,
                  alertText: "يجب عليك أختيار المدرسه",
                  alertIcon: "assets/icons/warningIcon.png",
                  containerHeight: Get.height * 0.4);
            }
        );
      }
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

}