// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madrasty/Utils/Colors_File.dart';
import '../Utils/constant.dart';
import '../Utils/localization_services.dart';
import '../Utils/memory.dart';
import 'custom_text_widget.dart';

class DrawerTapWidget extends StatelessWidget {
  final String title;
  final String iconPath;

  const DrawerTapWidget({super.key, required this.title, required this.iconPath});
  @override
  Widget build(BuildContext context) {
    return   Column(children: [
      ListTile(
          title: CustomText(
          title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              fontFamily: Get.find<StorageService>()
                  .activeLocale ==
                  SupportedLocales.english
                  ? fontFamilyEnglishName
                  : fontFamilyArabicName,
              color: kDarkBlueColor,
            ),
          ),
          leading:   SizedBox(
          height: Get.height*0.04,
    width: Get.width*0.05,
    child: Image.asset(iconPath,fit: BoxFit.fitWidth,),
    ),
          ),
      const Divider(
        color: kYellowColor,
        height: 1,
        thickness: 2,
        endIndent: 30,
        indent: 30,
      ),
    ],);
  }
}