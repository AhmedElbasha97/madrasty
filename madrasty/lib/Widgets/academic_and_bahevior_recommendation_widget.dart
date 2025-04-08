import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madrasty/Utils/Colors_File.dart';
import 'package:madrasty/Utils/constant.dart';
import 'package:madrasty/Utils/localization_services.dart';
import 'package:madrasty/Utils/memory.dart';
import 'package:madrasty/Widgets/custom_text_widget.dart';

import '../Models/academic_and_behavior_recommendation_model.dart';
import '../UI/posts/widgets/read_more_widget.dart';

class AcademicAndBaheviorRecommendationWidget extends StatelessWidget {
   const AcademicAndBaheviorRecommendationWidget({super.key, required this.data});
 final AcademicAndBehaviorRecommendationModel? data;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: Get.width * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
              image: AssetImage(
                  "assets/images/backgroundImage.png"),
              fit: BoxFit.cover),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xffd9d9d9),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10,),
                CustomText(
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  "${
                      Get.find<StorageService>().activeLocale ==
                          SupportedLocales.english
                          ? "type for recommendation"
                          : "نوع التوصيه"
                  } : ${data?.title??""}",
                  style: TextStyle(
                    shadows: <Shadow>[
                      Shadow(
                          offset:
                          const Offset(0.5, 0.5),
                          blurRadius: 0.5,
                          color: Colors.black
                              .withValues(alpha:0.5)),
                    ],
                    fontSize: 13,
                    letterSpacing: 0,
                    fontFamily:
                    Get.find<StorageService>()
                        .activeLocale ==
                        SupportedLocales.english
                        ? fontFamilyEnglishName
                        : fontFamilyArabicName,
                    color: kDarkBlueColor,
                  ),
                ),
                const SizedBox(height: 10,),
                Row(
                  children: [
                    CustomText(
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      "${
                          Get.find<StorageService>().activeLocale ==
                              SupportedLocales.english
                              ? "reason for recommendation"
                              : "سبب التوصيه"
                      } : ",
                      style: TextStyle(
                        shadows: <Shadow>[
                          Shadow(
                              offset:
                              const Offset(0.5, 0.5),
                              blurRadius: 0.5,
                              color: Colors.black
                                  .withValues(alpha:0.5)),
                        ],
                        fontSize: 13,
                        letterSpacing: 0,
                        fontFamily:
                        Get.find<StorageService>()
                            .activeLocale ==
                            SupportedLocales.english
                            ? fontFamilyEnglishName
                            : fontFamilyArabicName,
                        color: kDarkBlueColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: Get.width * 0.4,
                        child: ReadMoreText(
                            data?.msg??"",

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
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10,),
                CustomText(
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  "${
                      Get.find<StorageService>().activeLocale ==
                          SupportedLocales.english
                          ? "student name"
                          : "أسم الطالب"
                  } : ${data?.student??""}",
                  style: TextStyle(
                    shadows: <Shadow>[
                      Shadow(
                          offset:
                          const Offset(0.5, 0.5),
                          blurRadius: 0.5,
                          color: Colors.black
                              .withValues(alpha:0.5)),
                    ],
                    fontSize: 13,
                    letterSpacing: 0,
                    fontFamily:
                    Get.find<StorageService>()
                        .activeLocale ==
                        SupportedLocales.english
                        ? fontFamilyEnglishName
                        : fontFamilyArabicName,
                    color: kDarkBlueColor,
                  ),
                ),
                const SizedBox(height: 10,),
                CustomText(
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  "${
                      Get.find<StorageService>().activeLocale ==
                          SupportedLocales.english
                          ? "teacher name"
                          : "أسم المدرس"
                  } : ${data?.teacher??""}",
                  style: TextStyle(
                    shadows: <Shadow>[
                      Shadow(
                          offset:
                          const Offset(0.5, 0.5),
                          blurRadius: 0.5,
                          color: Colors.black
                              .withValues(alpha:0.5)),
                    ],
                    fontSize: 13,
                    letterSpacing: 0,
                    fontFamily:
                    Get.find<StorageService>()
                        .activeLocale ==
                        SupportedLocales.english
                        ? fontFamilyEnglishName
                        : fontFamilyArabicName,
                    color: kDarkBlueColor,
                  ),
                ),
                const SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(
                    color: kYellowColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: CustomText(
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      data?.datetime??"",
                      style: TextStyle(
                        shadows: <Shadow>[
                          Shadow(
                              offset:
                              const Offset(0.5, 0.5),
                              blurRadius: 0.5,
                              color: Colors.black
                                  .withValues(alpha:0.5)),
                        ],
                        fontSize: 13,
                        letterSpacing: 0,
                        fontFamily:
                        Get.find<StorageService>()
                            .activeLocale ==
                            SupportedLocales.english
                            ? fontFamilyEnglishName
                            : fontFamilyArabicName,
                        color: kDarkBlueColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
