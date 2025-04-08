import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Utils/Colors_File.dart';
import '../../../Utils/constant.dart';
import '../../../Utils/localization_services.dart';
import '../../../Utils/memory.dart';
import '../../../Utils/translation_key.dart';
import '../../../Widgets/custom_text_widget.dart';

class ReviewAndQuestionScreen extends StatelessWidget {
  const ReviewAndQuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Container(
          height: Get.height * 0.07,
          width: Get.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/backgroundImage.png"),
                fit: BoxFit.cover),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: Get.height * 0.06,
                width: Get.width * 0.12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: kDarkBlueColor,
                  boxShadow: const [
                    BoxShadow(
                      color: kGrayColor,
                      blurRadius: 2,
                      offset: Offset(1, 1), // Shadow position
                    ),
                  ],
                ),
                child: const Center(
                    child: Icon(
                  Icons.favorite_border,
                  color: Colors.white,
                  size: 30,
                )),
              ),
              Container(
                height: Get.height * 0.06,
                width: Get.width * 0.12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: kDarkBlueColor,
                  boxShadow: const [
                    BoxShadow(
                      color: kGrayColor,
                      blurRadius: 2,
                      offset: Offset(1, 1), // Shadow position
                    ),
                  ],
                ),
                child: const Center(
                    child: Icon(
                  Icons.call,
                  color: Colors.white,
                  size: 30,
                )),
              ),
              Container(
                height: Get.height * 0.06,
                width: Get.width * 0.12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: kDarkBlueColor,
                  boxShadow: const [
                    BoxShadow(
                      color: kGrayColor,
                      blurRadius: 2,
                      offset: Offset(1, 1), // Shadow position
                    ),
                  ],
                ),
                child: const Center(
                    child: Icon(
                  Icons.pin_drop_outlined,
                  color: Colors.white,
                  size: 30,
                )),
              ),
              Container(
                height: Get.height * 0.06,
                width: Get.width * 0.12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: kDarkBlueColor,
                  boxShadow: const [
                    BoxShadow(
                      color: kGrayColor,
                      blurRadius: 2,
                      offset: Offset(1, 1), // Shadow position
                    ),
                  ],
                ),
                child: const Center(
                    child: Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.white,
                  size: 30,
                )),
              ),
              Container(
                height: Get.height * 0.06,
                width: Get.width * 0.12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: kDarkBlueColor,
                  boxShadow: const [
                    BoxShadow(
                      color: kGrayColor,
                      blurRadius: 2,
                      offset: Offset(1, 1), // Shadow position
                    ),
                  ],
                ),
                child: const Center(
                    child: Icon(
                  Icons.message_sharp,
                  color: Colors.white,
                  size: 30,
                )),
              ),
              Container(
                height: Get.height * 0.06,
                width: Get.width * 0.12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: kDarkBlueColor,
                  boxShadow: const [
                    BoxShadow(
                      color: kGrayColor,
                      blurRadius: 2,
                      offset: Offset(1, 1), // Shadow position
                    ),
                  ],
                ),
                child: const Center(
                    child: Icon(
                  Icons.share,
                  color: Colors.white,
                  size: 30,
                )),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: Get.height * 0.3,
            width: Get.width,
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: kGrayColor,
                  blurRadius: 2,
                  offset: Offset(1, 1), // Shadow position
                ),
              ],
              borderRadius: BorderRadius.circular(25),
              image: const DecorationImage(
                  image: AssetImage("assets/images/27002.jpg"),
                  fit: BoxFit.cover),
            ),
          ),
        ),
        Center(
          child: Container(
            width: Get.width * 0.97,
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: kGrayColor,
                  blurRadius: 2,
                  offset: Offset(1, 1), // Shadow position
                ),
              ],
              color: kYellowColor,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: kGrayColor,
                          blurRadius: 2,
                          offset: Offset(1, 1), // Shadow position
                        ),
                      ],
                      borderRadius: BorderRadius.circular(25),
                      image: const DecorationImage(
                          image: AssetImage("assets/images/27002.jpg"),
                          fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: Get.width * 0.7,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              "ندى محمد",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily:
                                      Get.find<StorageService>().activeLocale ==
                                              SupportedLocales.english
                                          ? fontFamilyEnglishName
                                          : fontFamilyArabicName,
                                  color: kDarkBlueColor,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15),
                            ),
                            CustomText(
                              "13/4/2024",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily:
                                      Get.find<StorageService>().activeLocale ==
                                              SupportedLocales.english
                                          ? fontFamilyEnglishName
                                          : fontFamilyArabicName,
                                  color: kDarkBlueColor,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                      CustomText(
                        "المدرس الافضل على الاطلاق",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontFamily:
                                Get.find<StorageService>().activeLocale ==
                                        SupportedLocales.english
                                    ? fontFamilyEnglishName
                                    : fontFamilyArabicName,
                            color: kDarkBlueColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 13),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(
                            Icons.reply,
                            color: kDarkBlueColor,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          CustomText(
                            replyKey.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily:
                                    Get.find<StorageService>().activeLocale ==
                                            SupportedLocales.english
                                        ? fontFamilyEnglishName
                                        : fontFamilyArabicName,
                                color: kDarkBlueColor,
                                fontWeight: FontWeight.w800,
                                fontSize: 15),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
