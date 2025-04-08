// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Utils/Colors_File.dart';
import '../../../Utils/constant.dart';
import '../../../Utils/localization_services.dart';
import '../../../Utils/memory.dart';
import '../../../Widgets/custom_text_widget.dart';
import 'custom_indecator_widget.dart';

class CustomTapWidget extends StatelessWidget {
  final bool chosenOrNot;
  final String title;

  const CustomTapWidget(
      {super.key, required this.chosenOrNot, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Container(
            constraints: BoxConstraints(
              minHeight: Get.height * 0.06,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: chosenOrNot ? kBlueColor : kDarkBlueColor,
            ),
            child: Center(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                  child: Container(
                    constraints: const BoxConstraints(
                    ),
                    child: CustomText(
                      textAlign: TextAlign.center,
                      title,
                      maxLines: 1,
                      style: TextStyle(
                        shadows: <Shadow>[
                          Shadow(
                              offset: const Offset(0.5, 0.5),
                              blurRadius: 0.5,
                              color: Colors.black.withValues(alpha:0.5)),
                        ],
                        fontSize: 15,
                        letterSpacing: 0,
                        fontFamily: Get.find<StorageService>().activeLocale ==
                                SupportedLocales.english
                            ? fontFamilyEnglishName
                            : fontFamilyArabicName,
                        color: Colors.white,
                      ),
                    ),
                  )),
            ),
          ),
        ),
        CustomPaint(
          painter: InvertedTrianglePainter(
              chosenOrNot ? kBlueColor : kLightBlueColor),
          child: Container(
            height: 35,
            width: 20,
          ),
        ),
      ],
    );
  }
}
