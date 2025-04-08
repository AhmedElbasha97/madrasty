import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madrasty/Widgets/loader.dart';


import '../../../Utils/Colors_File.dart';
import '../../../Utils/constant.dart';
import '../../../Utils/localization_services.dart';
import '../../../Utils/memory.dart';
import '../../../Widgets/academic_and_bahevior_recommendation_widget.dart';
import '../../../Widgets/custom_text_widget.dart';
import '../add_academic_and_behavior_recommendation/add_academic_and_behavior_recommendation_screen.dart';
import 'controller/academic_and_behavior_recommendation_list_controller.dart';

class AcademicAndBehaviorRecommendationListScreen extends StatelessWidget {
  const AcademicAndBehaviorRecommendationListScreen({super.key, required this.kidId});
  final String kidId;
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: AcademicAndBehaviorRecommendationListController(kidId),
        builder: (AcademicAndBehaviorRecommendationListController controller) => SizedBox(
          height: Get.height*0.72,
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: controller.scrollController,
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        const SizedBox(height: 10,),
                        CustomText(
                          textAlign: TextAlign.left,
                          maxLines: 3,
                          "${
                              Get.find<StorageService>().activeLocale ==
                                  SupportedLocales.english
                                  ? "type for recommendation"
                                  : "نوع التوصيه"
                          } : ",
                          style: TextStyle(
                            shadows: <Shadow>[
                              Shadow(
                                  offset:
                                  const Offset(0.5, 0.5),
                                  blurRadius: 0.5,
                                  color: Colors.black
                                      .withValues(alpha: 0.5)),
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
                        PopupMenuButton<String>(
                          constraints: BoxConstraints(
                            maxWidth: Get.width * 0.8,
                            minWidth: Get.width * 0.8,
                          ),
                          itemBuilder: (context) =>
                              controller.typeOfRecommendation.map((e) {
                                return PopupMenuItem(
                                  value: e,
                                  textStyle: TextStyle(
                                      color: kDarkBlueColor,
                                      fontFamily:
                                      Get.find<StorageService>().activeLocale ==
                                          SupportedLocales.english
                                          ? fontFamilyEnglishName
                                          : fontFamilyArabicName,
                                      fontWeight: FontWeight.w700),
                                  onTap: () {
                                    controller.selectingTypeForRecommendation(e);
                                  },
                                  child: SizedBox(
                                    width: Get.width * 0.8,
                                    child: Column(
                                      children: [
                                        CustomText(
                                          e,
                                          style: TextStyle(
                                              color: kWhiteColor,
                                              fontFamily: Get.find<StorageService>()
                                                  .activeLocale ==
                                                  SupportedLocales.english
                                                  ? fontFamilyEnglishName
                                                  : fontFamilyArabicName,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        e == controller.typeOfRecommendation.last
                                            ? const SizedBox()
                                            :  Divider(
                                          color: kDarkBlueColor.withValues(alpha:0.5),
                                          height: 1,
                                          thickness: 1,
                                          endIndent: 0,
                                          indent: 0,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                          color: kDarkBlueColor,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 0),
                            child:Container(
                              height: Get.height * 0.06,
                              width: Get.width * 0.8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                image: const DecorationImage(
                                    image: AssetImage(
                                        "assets/images/backgroundImage.png"),
                                    fit: BoxFit.cover),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  constraints: BoxConstraints(
                                    minHeight: Get.height * 0.06,
                                  ),
                                  width: Get.width * 0.8,
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
                                  child: Center(
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: Get.width * 0.6,
                                            child: CustomText(
                                              textAlign: TextAlign.center,
                                              maxLines: 3,
                                              controller.chosenTypeOfRecommendation==""?controller.typeOfRecommendation[0]:controller.chosenTypeOfRecommendation,
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
                                                color: kWhiteColor,
                                              ),
                                            ),
                                          ),
                                          const Icon(Icons.arrow_downward_sharp,
                                              color: kWhiteColor, size: 20),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    controller.isLoading?Loader(height: Get.height*0.59,):
                    controller.academicAndBehaviorRecommendationList?.isEmpty??true?Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/no_search_data.png",height: Get.width*0.65,),
                        CustomText(Get.find<StorageService>()
                            .activeLocale ==
                            SupportedLocales.english
                            ?"no data in academic and behavior recommendation":"لا يوجد توصيات أكدمييه أو سولكيه",style:   TextStyle(color: kDarkBlueColor, fontFamily: Get.find<StorageService>()
                            .activeLocale ==
                            SupportedLocales.english
                            ? fontFamilyEnglishName
                            : fontFamilyArabicName,fontWeight: FontWeight.bold,fontSize: 30),textAlign: TextAlign.center,),
                        const SizedBox(height: 30,),


                      ],
                    ):SingleChildScrollView(
                      child: Column(
                        children: controller.academicAndBehaviorRecommendationList!.map((
                            e) {
                          return AcademicAndBaheviorRecommendationWidget(data: e);
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Visibility(
                      visible: controller.isVisible,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: (){
                            controller.goUpToTopOfSScreen();
                          },
                          child: Container(
                            width: Get.width*0.17,
                            height: Get.height*0.08,
                            decoration: BoxDecoration(
                              border: Border.all( color:kLightBlueColor,width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha:0.1),
                                  offset: const Offset(
                                    0.0,
                                    0.0,
                                  ),
                                  blurRadius: 13.0,
                                  spreadRadius: 2.0,
                                ), //BoxShadow
                                BoxShadow(
                                  color: Colors.white.withValues(alpha:0.2),
                                  offset: const Offset(0.0, 0.0),
                                  blurRadius: 0.0,
                                  spreadRadius: 0.0,
                                ), //BoxShadow
                              ],
                              color: kDarkBlueColor
                              ,shape: BoxShape.circle,
                            ),
                            child:  const Center(
                              child:  Icon(
                                Icons.arrow_upward_sharp,
                                weight: 30,
                                color: kLightBlueColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),const SizedBox(height: 10,),
                    Visibility(
                      visible: Get.find<StorageService>().getUserType == "TEACHER",
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: (){
                            Get.to(
                                ()=> const AddAcademicAndBehaviorRecommendationScreen(),
                            );
                          },
                          child: Container(
                            width: Get.width*0.32,
                            height: Get.height*0.09,
                            decoration: BoxDecoration(
                                border: Border.all( color:kLightBlueColor,width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha:0.1),
                                    offset: const Offset(
                                      0.0,
                                      0.0,
                                    ),
                                    blurRadius: 13.0,
                                    spreadRadius: 2.0,
                                  ), //BoxShadow
                                  BoxShadow(
                                    color: Colors.white.withValues(alpha:0.2),
                                    offset: const Offset(0.0, 0.0),
                                    blurRadius: 0.0,
                                    spreadRadius: 0.0,
                                  ), //BoxShadow
                                ],
                                borderRadius: BorderRadius.circular(30),

                                color: kDarkBlueColor
                            ),
                            child:  Center(
                              child:  Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.chat,
                                    weight: 30,
                                    color: kLightBlueColor,
                                  ),
                                  const SizedBox(width: 10,),
                                  CustomText(
                                    textAlign: TextAlign.center,
                                    maxLines: 3,
                                    Get.find<StorageService>()
                                        .activeLocale ==
                                        SupportedLocales.english
                                        ?"new recommendation":"توصييه جديدة",
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
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),


                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
}
