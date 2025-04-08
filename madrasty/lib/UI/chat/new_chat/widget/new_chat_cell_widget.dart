import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Models/history_message_list_model.dart';
import '../../../../Utils/Colors_File.dart';
import '../../../../Utils/constant.dart';
import '../../../../Utils/localization_services.dart';
import '../../../../Utils/memory.dart';
import '../../../../Utils/translation_key.dart';
import '../../../../Widgets/custom_text_widget.dart';

class NewChatCellWidget extends StatelessWidget {
  const NewChatCellWidget({    super.key,
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
                        ],
                      ),

                    ],
                  ),

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

