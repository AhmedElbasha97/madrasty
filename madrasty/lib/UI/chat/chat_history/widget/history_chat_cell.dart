import 'package:easy_localization/easy_localization.dart' hide StringTranslateExtension;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madrasty/Utils/Colors_File.dart';
import 'package:madrasty/Widgets/custom_text_widget.dart';

import '../../../../Models/history_message_list_model.dart';
import '../../../../Utils/constant.dart';
import '../../../../Utils/localization_services.dart';
import '../../../../Utils/memory.dart';
import '../../../../Utils/translation_key.dart';


class HistoryChatUserCard extends StatelessWidget {
  const HistoryChatUserCard({
    super.key,
     required this.chat,
    required this.press,
  });
  String detectUserTypeTranslated(String userType){
    String userTypeTranslated = "";
    switch(userType){
      case "TEACHER":{
        userTypeTranslated =userType2.tr;

      }
      break;
      case "PARENT":{
        userTypeTranslated =userType1.tr;
      }
      break;
      case "STUDENT":{
        userTypeTranslated = userType3.tr;
      }
      break;
      case "DRIVER":{
        userTypeTranslated = userType5.tr;
      }
      break;
      case "SUPERVISOR":{
        userTypeTranslated = userType4.tr;
      }
      break;
    }

    return userTypeTranslated;

  }
  bool checkMessageSeenOrNot(String seenOrNot){
    bool checker = false;
    if(seenOrNot == "1"){
      checker = true;
    }else{
      checker = false;

    }
    return checker;
  }
  String returnDateAndTime(String? date){
    String dateOrTime = "" ;
    final format = DateFormat('HH:mm a');
    DateFormat formatDate = DateFormat("MMM dd");
    final dateTime = DateTime.parse(date??'2024-10-01 12:49:18');
    if(dateTime.day == DateTime.now().day){
      dateOrTime = format.format(dateTime);
    }else{
      dateOrTime = formatDate.format(dateTime);
    }
    return dateOrTime;
  }

  final HistoryMessagesListModel? chat;
  final VoidCallback press;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: press,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical:10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap:(){

                        },
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10),
                          height: 64,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: Image.network(
                              'https://img.freepik.com/premium-vector/vector-flat-illustration-grayscale-avatar-user-profile-person-icon-profile-picture-business-profile-woman-suitable-social-media-profiles-icons-screensavers-as-templatex9_719432-1310.jpg?w=740',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:   [
                          const SizedBox(height: 10,),
                          CustomText(chat?.name??"",style:  TextStyle(
                              fontFamily:  Get.find<StorageService>().activeLocale ==
                                  SupportedLocales.english
                                  ? fontFamilyEnglishName
                                  : fontFamilyArabicName,
                              color: kDarkBlueColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 17),
                          ),
                          const SizedBox(height: 10,),
                          CustomText(detectUserTypeTranslated(chat?.type??""),style:  TextStyle(
                              fontFamily:  Get.find<StorageService>().activeLocale ==
                                  SupportedLocales.english
                                  ? fontFamilyEnglishName
                                  : fontFamilyArabicName,
                              color: kDarkBlueColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 17),
                          ),
                          const SizedBox(height: 10,),
                          (chat?.lastMsg?.type??"")=="POST"?CustomText(Get.find<StorageService>().activeLocale ==
                              SupportedLocales.english
                              ? "there's post has been sent"
                              :"لقد تم إرسال منشور",style:  TextStyle(
                              height: 1,
                              fontFamily:  Get.find<StorageService>().activeLocale ==
                                  SupportedLocales.english
                                  ? fontFamilyEnglishName
                                  : fontFamilyArabicName,
                              color:kDarkBlueColor,
                              fontWeight: checkMessageSeenOrNot(chat?.lastMsg?.view??"")?FontWeight.w600:FontWeight.w800,
                              fontSize: 14),):
                          (chat?.lastMsg?.type??"")=="IMG"?CustomText(Get.find<StorageService>().activeLocale ==
                              SupportedLocales.english
                              ? "there's image has been sent"
                              :"لقد تم إرسال صوره",style:  TextStyle(
                              height: 1,
                              fontFamily:  Get.find<StorageService>().activeLocale ==
                                  SupportedLocales.english
                                  ? fontFamilyEnglishName
                                  : fontFamilyArabicName,
                              color:kDarkBlueColor,
                              fontWeight: checkMessageSeenOrNot(chat?.lastMsg?.view??"")?FontWeight.w600:FontWeight.w800,
                              fontSize: 14),) :
                          (chat?.lastMsg?.type??"")=="VID"?CustomText(Get.find<StorageService>().activeLocale ==
                              SupportedLocales.english
                              ? "there's video has been sent"
                              :"لقد تم إرسال فيديو",style:  TextStyle(
                              height: 1,
                              fontFamily:  Get.find<StorageService>().activeLocale ==
                                  SupportedLocales.english
                                  ? fontFamilyEnglishName
                                  : fontFamilyArabicName,
                              color:kDarkBlueColor,
                              fontWeight: checkMessageSeenOrNot(chat?.lastMsg?.view??"")?FontWeight.w600:FontWeight.w800,
                              fontSize: 14),):
                          (chat?.lastMsg?.type??"")=="FIL"?CustomText(Get.find<StorageService>().activeLocale ==
                              SupportedLocales.english
                              ? "there's file has been sent"
                              :"لقد تم إرسال ملف",style:  TextStyle(
                              height: 1,
                              fontFamily:  Get.find<StorageService>().activeLocale ==
                                  SupportedLocales.english
                                  ? fontFamilyEnglishName
                                  : fontFamilyArabicName,
                              color:kDarkBlueColor,
                              fontWeight: checkMessageSeenOrNot(chat?.lastMsg?.view??"")?FontWeight.w600:FontWeight.w800,
                              fontSize: 14),):CustomText(chat?.lastMsg?.text??"",style:  TextStyle(
                              height: 1,
                              fontFamily:  Get.find<StorageService>().activeLocale ==
                                  SupportedLocales.english
                                  ? fontFamilyEnglishName
                                  : fontFamilyArabicName,
                              color:kDarkBlueColor,
                               fontWeight: checkMessageSeenOrNot(chat?.lastMsg?.view??"")?FontWeight.w600:FontWeight.w800,
                              fontSize: 14),),
                        ],
                      ),

                    ],
                  ),
                  CustomText(returnDateAndTime(chat?.lastMsg?.date ?? '2024-10-01 12:49:18'),style:  TextStyle(
                      height: 1,
                      fontFamily:  Get.find<StorageService>().activeLocale ==
                          SupportedLocales.english
                          ? fontFamilyEnglishName
                          : fontFamilyArabicName,
                      color: kDarkBlueColor,
                       fontWeight: checkMessageSeenOrNot(chat?.lastMsg?.view??"")?FontWeight.w600:FontWeight.w800,
                      fontSize: 14),),
                ],
              ),
            ),
            const Divider(
              color: kDarkBlueColor,
              height: 1,
              thickness: 2,

            ),
          ],
        ),
      ),
    );
  }
}