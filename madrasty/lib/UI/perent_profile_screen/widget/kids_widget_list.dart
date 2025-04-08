// ignore_for_file: sized_box_for_whitespace

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madrasty/Models/kids_model.dart';
import 'package:madrasty/Utils/localization_services.dart';

import '../../../Utils/Colors_File.dart';
import '../../../Utils/constant.dart';
import '../../../Utils/memory.dart';
import '../../../Utils/services.dart';
import '../../../Utils/translation_key.dart';
import '../../../Widgets/custom_text_widget.dart';

class KidsWidgetList extends StatelessWidget {
  const KidsWidgetList({super.key, required this.kidData, required this.receivePress, required this.sendPress, required this.showOnMap});
  final KidsModel kidData;
  final VoidCallback receivePress;
  final VoidCallback sendPress;
  final VoidCallback showOnMap;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 10),
                    CachedNetworkImage(
                      imageUrl:"${Services.baseUrl}${kidData.school?.logo}",
                      imageBuilder: ((context, image) {
                        return   Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: kGrayColor,
                                blurRadius: 2,
                                offset: Offset(
                                    1, 1), // Shadow position
                              ),
                            ],
                            borderRadius:
                            BorderRadius.circular(15),
                            image: DecorationImage(
                              image: image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }),
                      placeholder: (context, image) {
                        return Padding(
                          padding: const EdgeInsets.all(5),
                          child: Container(
                              decoration: const BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(
                                      Radius.circular(
                                          15))),
                              child: const CircularProgressIndicator()),
                        );
                      },
                      errorWidget: (context, url, error) {
                        return   Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: kGrayColor,
                                blurRadius: 2,
                                offset: Offset(
                                    1, 1), // Shadow position
                              ),
                            ],
                            borderRadius:
                            BorderRadius.circular(15),
                            image: const DecorationImage(
                                image: AssetImage(
                                    "assets/images/27002.jpg"),
                                fit: BoxFit.cover),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          kidData.name??"",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily:
                              Get.find<StorageService>()
                                  .activeLocale ==
                                  SupportedLocales
                                      .english
                                  ? fontFamilyEnglishName
                                  : fontFamilyArabicName,
                              color: kDarkBlueColor,
                              fontWeight: FontWeight.w800,
                              fontSize: 15),
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          width: Get.width*0.25,
                          child: CustomText(
                            kidData.school?.name??"",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily:
                                Get.find<StorageService>()
                                    .activeLocale ==
                                    SupportedLocales
                                        .english
                                    ? fontFamilyEnglishName
                                    : fontFamilyArabicName,
                                color: kDarkBlueColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 10),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        InkWell(
                          onTap: showOnMap,
                          child: Row(
                            children: [
                              const Icon(Icons.pin_drop_outlined,color: kDarkBlueColor,),
                              const SizedBox(width: 2,),
                              CustomText(
                                showLocSchoolKey.tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily:
                                    Get.find<StorageService>()
                                        .activeLocale ==
                                        SupportedLocales
                                            .english
                                        ? fontFamilyEnglishName
                                        : fontFamilyArabicName,
                                    color: kDarkBlueColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    InkWell(
                      onTap: sendPress,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: Get.height * 0.03,
                          width: Get.width * 0.25,
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(5),
                            color: kErrorColor,
                            boxShadow: const [
                              BoxShadow(
                                color: kGrayColor,
                                blurRadius: 2,
                                offset: Offset(1,
                                    1), // Shadow position
                              ),
                            ],
                          ),
                          child: Center(
                            child: CustomText(
                              senderKey.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: Get.find<
                                      StorageService>()
                                      .activeLocale ==
                                      SupportedLocales
                                          .english
                                      ? fontFamilyEnglishName
                                      : fontFamilyArabicName,
                                  color: kLightBlueColor,
                                  fontWeight:
                                  FontWeight.w700,
                                  fontSize: 13),
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: receivePress,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: Get.height * 0.03,
                          width: Get.width * 0.25,
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(5),
                            color: kSuccessColor,
                            boxShadow: const [
                              BoxShadow(
                                color: kGrayColor,
                                blurRadius: 2,
                                offset: Offset(1,
                                    1), // Shadow position
                              ),
                            ],
                          ),
                          child: Center(
                            child: CustomText(
                              receivedKey.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: Get.find<
                                      StorageService>()
                                      .activeLocale ==
                                      SupportedLocales
                                          .english
                                      ? fontFamilyEnglishName
                                      : fontFamilyArabicName,
                                  color: kLightBlueColor,
                                  fontWeight:
                                  FontWeight.w700,
                                  fontSize: 13),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(
              height: 1,
              thickness: 2,
              endIndent: 10,
              indent: 10,
              color: kGrayColor,
            ),
          ],
        ),

      ],
    );
  }
}
