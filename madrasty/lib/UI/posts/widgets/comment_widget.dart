import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madrasty/Models/comment_model.dart';
import 'package:madrasty/UI/posts/widgets/read_more_widget.dart';

import '../../../Utils/Colors_File.dart';
import '../../../Utils/constant.dart';
import '../../../Utils/localization_services.dart';
import '../../../Utils/memory.dart';
import '../../../Utils/translation_key.dart';
import '../../../Widgets/custom_text_widget.dart';

class CommentWidget extends StatelessWidget {
  const CommentWidget({super.key, required this.commentData});
  final CommentModel? commentData;
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 5,),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: InkWell(
            onTap: () {},
            child: Container(
              constraints: BoxConstraints(
                minHeight: Get.height * 0.07,
                maxWidth: Get.width*0.8,


              ),
              decoration:  BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: kLightBlueColor
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: Get.height * 0.1,
                      width: Get.width * 0.1,
                      decoration:  const BoxDecoration(
                        shape: BoxShape.circle,
                        color: kDarkBlueColor,
                        boxShadow: [
                          BoxShadow(
                            color: kGrayColor,
                            blurRadius: 2,
                            offset:
                            Offset(1, 1), // Shadow position
                          ),
                        ],
                        image: DecorationImage(
                            image: AssetImage(
                                "assets/images/27002.jpg"),
                            fit: BoxFit.cover),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                          constraints: BoxConstraints(
                            maxWidth: Get.width*0.7
                          ),


                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 2.0,right: 2.0,top: 20.0),
                                child: CustomText(
                                  textAlign: TextAlign.left,
                                  maxLines: 3,
                                  commentData?.user?.name??"",
                                  style: TextStyle(
                                    shadows: <Shadow>[
                                      Shadow(
                                          offset:  const Offset(0.5, 0.5),
                                          blurRadius: 0.5,
                                          color: Colors.black
                                              .withValues(alpha:0.5)),
                                    ],
                                    fontSize: 12,
                                    letterSpacing: 0,
                                    fontFamily: Get.find<StorageService>()
                                        .activeLocale ==
                                        SupportedLocales.english
                                        ? fontFamilyEnglishName
                                        : fontFamilyArabicName,
                                    color: kDarkBlueColor,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 2.0,right: 2.0,top: 0.0),
                                child: CustomText(
                                  textAlign: TextAlign.left,
                                  maxLines: 3,
                                  detectUserTypeTranslated(commentData?.user?.type??""),
                                  style: TextStyle(
                                    shadows: <Shadow>[
                                      Shadow(
                                          offset:  const Offset(0.5, 0.5),
                                          blurRadius: 0.5,
                                          color: Colors.black
                                              .withValues(alpha:0.5)),
                                    ],
                                    fontSize: 12,
                                    letterSpacing: 0,
                                    fontFamily: Get.find<StorageService>()
                                        .activeLocale ==
                                        SupportedLocales.english
                                        ? fontFamilyEnglishName
                                        : fontFamilyArabicName,
                                    color: kDarkBlueColor,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 2.0,right: 2.0,top: 5.0,bottom: 20),
                                child: ReadMoreText(
                                    commentData?.text??"",
                                    trimLength: 150,
                                    colorClickableText: kDarkBlueColor,
                                    style: TextStyle(
                                      shadows: <Shadow>[
                                        Shadow(
                                            offset:  const Offset(0.5, 0.5),
                                            blurRadius: 0.5,
                                            color: Colors.black
                                                .withValues(alpha:0.5)),
                                      ],
                                      fontSize: 12,
                                      letterSpacing: 0,
                                      fontFamily: Get.find<StorageService>()
                                          .activeLocale ==
                                          SupportedLocales.english
                                          ? fontFamilyEnglishName
                                          : fontFamilyArabicName,
                                      color: kDarkBlueColor,),
                                    textAlign: TextAlign.right,
                                    semanticsLabel: "gjeirsdogio"),
                              )

                            ],
                          )
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5,),
      ],
    );
  }
}
