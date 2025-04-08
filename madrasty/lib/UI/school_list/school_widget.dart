// ignore_for_file: sized_box_for_whitespace

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madrasty/Utils/services.dart';
import '../../Models/school_model.dart';
import '../../Utils/Colors_File.dart';
import '../../Utils/constant.dart';
import '../../Utils/localization_services.dart';
import '../../Utils/memory.dart';
import '../../Widgets/custom_text_widget.dart';
import '../../Widgets/loader.dart';
import '../school_details/school_details_screen.dart';

class SchoolWidget extends StatelessWidget {
  const SchoolWidget({super.key, required this.schoolData});
 final SchoolModel? schoolData;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width*0.45,
      height: Get.height * 0.3,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: kGrayColor,
            blurRadius: 2,
            offset: Offset(1, 1), // Shadow position
          ),
        ],
        color: const Color(0xFFd9d9d9),

      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CachedNetworkImage(
              imageUrl:"${Services.baseUrl}${schoolData?.logo}",
              imageBuilder: ((context, image) {
                return Container(
                    height: Get.height * 0.1,
                    width: Get.width * 0.2,

                    decoration: BoxDecoration(
                        shape: BoxShape.circle,

                        image: DecorationImage(
                          image: image,
                          fit: BoxFit.cover,
                        ),
                        ));
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
                      child: Loader(
                        height: Get.height * 0.1,
                        width: Get.width * 0.2,)),
                );
              },
              errorWidget: (context, url, error) {
                return Container(
                    height: Get.height * 0.1,
                    width: Get.width * 0.2,
                    margin:
                    const EdgeInsets.symmetric(
                        horizontal: 5.0),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,

                        image: DecorationImage(
                          image: AssetImage(
                              "assets/images/no_data_slideShow.png"),
                          fit: BoxFit.fill,
                        ),
                        borderRadius:
                        BorderRadius.all(
                            Radius.circular(
                                15))));
              },
            ),

            Container(
              width: Get.width * 0.35,
              child: CustomText(
                textAlign: TextAlign.center,
                maxLines: 3,
                schoolData?.brief??"",
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
            InkWell(
              onTap: (){
                Get.to(() =>  SchoolDetailsScreen(schoolId: "${schoolData?.id ??0}",),
                    transition: Transition.rightToLeftWithFade);
              },
              child: Container(
                width: Get.width * 0.35,
                child: CustomText(
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  "عرض تفاصيل",
                  style: TextStyle(
                    shadows: <Shadow>[
                      Shadow(
                          offset:
                          const Offset(0.5, 0.5),
                          blurRadius: 0.5,
                          color: Colors.black
                              .withValues(alpha:0.5)),
                    ],
                    fontSize: 15,
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
          ],
        ),
      ),
    );
  }
}
