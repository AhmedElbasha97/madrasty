
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Models/response_model.dart';
import '../../../../Services/posting_services.dart';
import '../../../../Utils/localization_services.dart';
import '../../../../Utils/memory.dart';
import '../../../../Utils/translation_key.dart';
import '../../../../Widgets/alert_dialogue.dart';


class ReportPostController extends GetxController {
  late TextEditingController reportTextController;
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final String postId;

  ReportPostController({required this.postId});

  late FocusNode text1FocusNode;


  @override
  void onInit() {
    super.onInit();
    reportTextController = TextEditingController();
    text1FocusNode = FocusNode();
  }


  sendingReportForThePost(BuildContext context) async {
    isLoading = true;
    update();
    if(reportTextController.text.trim().isNotEmpty&&reportTextController.text != (Get
        .find<StorageService>()
        .activeLocale ==
        SupportedLocales.english
        ? "Enter what you want to report in this post."
        : "أدخال ما تريد الأبلاغ عنه فى هزا المنشور")){
      ResponseModel? data = await PostingServices.reportingPost(
          postId, reportTextController.text);
      if (data?.msg == "succeeded") {
        final snackBar = SnackBar(content:
        Row(children: [
          const Icon(Icons.check, color: Colors.white,),
          const SizedBox(width: 10,),
          Text(Get
              .find<StorageService>()
              .activeLocale ==
              SupportedLocales.english
              ? 'The report has been sent'
              : 'تم الأبلاغ عن المنشور ', style: const TextStyle(
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
        Navigator.pop(context);
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
              ? 'An error occurred while reporting the Post'
              : 'حدث خطاء أثناء الأبلاغ عن المنشور', style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),
          ),
        ],),
            backgroundColor: Colors.red
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    else {
      showDialog(context: context,
          builder: (context) {
            return AlertDialogue(
                alertTitle: errorKey.tr,
                alertText: Localizations
                    .localeOf(context)
                    .languageCode == "en"
                    ? 'enter valid report'
                    : 'اكتب سبب التقرير الذى تريد اضافته',
                alertIcon: "assets/icons/warningIcon.png",
                containerHeight: Get.height * 0.4);
          });

      isLoading = false;
    }
  }
}