// ignore_for_file: sized_box_for_whitespace, prefer_is_empty, deprecated_member_use

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:madrasty/UI/posts/widgets/post_loading_widget.dart';

import '../../../Models/student_share_model.dart';
import '../../../Utils/Colors_File.dart';
import '../../../Utils/constant.dart';
import '../../../Utils/localization_services.dart';
import '../../../Utils/memory.dart';
import '../../../Widgets/custom_text_widget.dart';
import '../../../Widgets/no_data_widget.dart';
import '../../../Widgets/pull_to_refresh_widget.dart';
import '../../posts/add_post/add_post_screen.dart';
import '../../posts/widgets/post_widget.dart';
import '../controller/student_profile_controller.dart';

class StudentPostsScreen extends StatelessWidget {
  const StudentPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: StudentProfileController(),
      builder: (StudentProfileController controller) => Platform.isIOS
          ? Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              await controller.getPostData();},
            child: Container(
              height: Get.height*0.7,
              child: SingleChildScrollView(
                controller: controller.scrollController,

                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: (){
                              Get.to(()=> AddPostScreen(schoolId: "${controller.schoolId?.school??0}",classId: "${controller.schoolId?.schoolIdModelClass??0}",));
                            },
                            child: Container(
                              width: Get.width*0.65,
                              height: Get.height*0.07,
                              decoration: BoxDecoration(
                                  border: Border.all( color:kLightBlueColor,width: 2),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      offset: const Offset(
                                        0.0,
                                        0.0,
                                      ),
                                      blurRadius: 13.0,
                                      spreadRadius: 2.0,
                                    ), //BoxShadow
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.2),
                                      offset: const Offset(0.0, 0.0),
                                      blurRadius: 0.0,
                                      spreadRadius: 0.0,
                                    ), //BoxShadow
                                  ],
                                  color: kDarkBlueColor
                              ),
                              child:  Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText( Get.find<StorageService>().activeLocale ==
                                      SupportedLocales.english
                                      ? "add post"
                                      : "اضف منشور ",style:  TextStyle(
                                      fontFamily:  Get.find<StorageService>().activeLocale ==
                                          SupportedLocales.english
                                          ? fontFamilyEnglishName
                                          : fontFamilyArabicName,
                                      color: kWhiteColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15),
                                  ),
                                  const Icon(
                                    Icons.add,
                                    weight: 30,
                                    color: kLightBlueColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: (){
                              controller.showFilteringScreen(context);
                            },
                            child: Container(
                              width: Get.width*0.19,
                              height: Get.height*0.07,
                              decoration: BoxDecoration(
                                  border: Border.all( color:kLightBlueColor,width: 2),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      offset: const Offset(
                                        0.0,
                                        0.0,
                                      ),
                                      blurRadius: 13.0,
                                      spreadRadius: 2.0,
                                    ), //BoxShadow
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.2),
                                      offset: const Offset(0.0, 0.0),
                                      blurRadius: 0.0,
                                      spreadRadius: 0.0,
                                    ), //BoxShadow
                                  ],
                                  color: kDarkBlueColor
                              ),
                              child:  const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.filter_alt_outlined,
                                    weight: 30,
                                    color: kLightBlueColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                    const SizedBox(height: 5,),
                    controller.isLoadingPostsTypes?Column(
                      children: [
                        const SizedBox(height: 10,),
                        Container(
                          height: Get.height * 0.07,
                          width: Get.width * 0.8,
                          decoration:  BoxDecoration(
                              borderRadius: BorderRadius.circular(50),

                              color: const Color(0xFFDFDDDF)

                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                height: Get.height * 0.07,
                                width: Get.width * 0.75,
                                decoration:   BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),

                                  color:  const Color(0xFFDFDDDF),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: kGrayColor,
                                      blurRadius: 2,
                                      offset:
                                      Offset(1, 1), // Shadow position
                                    ),
                                  ],

                                ),
                              ),
                            ),
                          ).animate(onPlay: (controller) => controller.repeat())
                              .shimmer(duration: 1200.ms, color:  kBlueColor.withAlpha(55))
                              .animate() // this wraps the previous Animate in another Animate
                              .fadeIn(duration: 700.ms, curve: Curves.easeOutQuad)
                              .slide(),
                        ),
                      ],
                    ).animate(onPlay: (controller) => controller.repeat())
                        .shimmer(duration: 1200.ms, color:  kBlueColor.withAlpha(55))
                        .animate() // this wraps the previous Animate in another Animate
                        .fadeIn(duration: 700.ms, curve: Curves.easeOutQuad)
                        .slide():
                    PopupMenuButton<StudentShareModel>(
                      constraints: BoxConstraints(
                        maxWidth: Get.width * 0.8,
                        minWidth: Get.width * 0.8,
                      ),
                      itemBuilder: (context) =>
                          controller.listPostTypes!.map((e) {
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
                                controller. choosingPostType(e);
                              },
                              child: SizedBox(
                                width: Get.width * 0.8,
                                child: Column(
                                  children: [
                                    CustomText(
                                      e.name??"",
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
                                    e == controller.listPostTypes?.last
                                        ? const SizedBox()
                                        :  Divider(
                                      color: kDarkBlueColor.withOpacity(0.5),
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
                      child: Container(
                        height: Get.height * 0.07,
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
                              minHeight: Get.height * 0.04,
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
                                    Container(
                                      width: Get.width * 0.6,
                                      child: CustomText(
                                        textAlign: TextAlign.center,
                                        maxLines: 3,
                                        controller.chosenPostType?.name??"",
                                        style: TextStyle(
                                          shadows: <Shadow>[
                                            Shadow(
                                                offset:
                                                const Offset(0.5, 0.5),
                                                blurRadius: 0.5,
                                                color: Colors.black
                                                    .withOpacity(0.5)),
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
                    const SizedBox(height: 5,),

                    controller.postIsLoading?
                    const SingleChildScrollView(
                      child: PostLoadingWidget(),
                    ):(controller.postsListData?.length??0)==0?controller.selectedPostType!=""?NoDataWidget(refreshedFunc: (){}, text:
                    Get.find<StorageService>().activeLocale ==
                        SupportedLocales.english
                        ? 'There are no posts available in this category ${controller.chosenPostType?.name??""}'
                        : 'لا يوجد منشورات متاحه هذا التصنيف ${controller.chosenPostType?.name??""}', imgPath: "assets/images/No data-cuate.png", hasRefreshButtonOrNot: false,):NoDataWidget(refreshedFunc: (){}, text: Get.find<StorageService>().activeLocale ==
                        SupportedLocales.english
                        ? 'No posts available'
                        : 'لا يوجد منشورات متاحه', imgPath: "assets/images/No data-cuate.png", hasRefreshButtonOrNot: false,)
                        :
                    Container(
                        color: Colors.white,
                        child:
                        Column(
                          children: [
                            ...List.generate(
                              controller.postsListData?.length??0,
                                  (index) => PostWidget(
                                postDataFromScreen: controller.postsListData?[index],
                                schoolId: "${controller.schoolId?.school ?? 0}",
                                classId: "${controller.schoolId?.schoolIdModelClass ?? 0}",
                                peopleSareList: controller.peopleShareList,
                              ),
                            ),
                            if (controller.isLoadingMoreDataForPosts)
                              const PostLoadingWidget(),
                          ],
                        )
                    ),
                  ],
                ),
              ),
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
                              color: Colors.black.withOpacity(0.1),
                              offset: const Offset(
                                0.0,
                                0.0,
                              ),
                              blurRadius: 13.0,
                              spreadRadius: 2.0,
                            ), //BoxShadow
                            BoxShadow(
                              color: Colors.white.withOpacity(0.2),
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
                ),



              ],
            ),
          ),

        ],
      )
          : Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              await controller.getPostData();},
            child: Container(
              height: Get.height*0.7,
              child: SingleChildScrollView(
                controller: controller.scrollController,

                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: (){
                              Get.to(()=> AddPostScreen(schoolId: "${controller.schoolId?.school??0}",classId: "${controller.schoolId?.schoolIdModelClass??0}",));
                            },
                            child: Container(
                              width: Get.width*0.65,
                              height: Get.height*0.07,
                              decoration: BoxDecoration(
                                  border: Border.all( color:kLightBlueColor,width: 2),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      offset: const Offset(
                                        0.0,
                                        0.0,
                                      ),
                                      blurRadius: 13.0,
                                      spreadRadius: 2.0,
                                    ), //BoxShadow
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.2),
                                      offset: const Offset(0.0, 0.0),
                                      blurRadius: 0.0,
                                      spreadRadius: 0.0,
                                    ), //BoxShadow
                                  ],
                                  color: kDarkBlueColor
                              ),
                              child:  Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText( Get.find<StorageService>().activeLocale ==
                                      SupportedLocales.english
                                      ? "add post"
                                      : "اضف منشور ",style:  TextStyle(
                                      fontFamily:  Get.find<StorageService>().activeLocale ==
                                          SupportedLocales.english
                                          ? fontFamilyEnglishName
                                          : fontFamilyArabicName,
                                      color: kWhiteColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15),
                                  ),
                                  const Icon(
                                    Icons.add,
                                    weight: 30,
                                    color: kLightBlueColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: (){
                              controller.showFilteringScreen(context);
                            },
                            child: Container(
                              width: Get.width*0.19,
                              height: Get.height*0.07,
                              decoration: BoxDecoration(
                                  border: Border.all( color:kLightBlueColor,width: 2),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      offset: const Offset(
                                        0.0,
                                        0.0,
                                      ),
                                      blurRadius: 13.0,
                                      spreadRadius: 2.0,
                                    ), //BoxShadow
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.2),
                                      offset: const Offset(0.0, 0.0),
                                      blurRadius: 0.0,
                                      spreadRadius: 0.0,
                                    ), //BoxShadow
                                  ],
                                  color: kDarkBlueColor
                              ),
                              child:  const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                   Icon(
                                    Icons.filter_alt_outlined,
                                    weight: 30,
                                    color: kLightBlueColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                    const SizedBox(height: 5,),
                    controller.isLoadingPostsTypes?Column(
                      children: [
                        const SizedBox(height: 10,),
                        Container(
                          height: Get.height * 0.07,
                          width: Get.width * 0.8,
                          decoration:  BoxDecoration(
                              borderRadius: BorderRadius.circular(50),

                              color: const Color(0xFFDFDDDF)

                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                height: Get.height * 0.07,
                                width: Get.width * 0.75,
                                decoration:   BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),

                                  color:  const Color(0xFFDFDDDF),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: kGrayColor,
                                      blurRadius: 2,
                                      offset:
                                      Offset(1, 1), // Shadow position
                                    ),
                                  ],

                                ),
                              ),
                            ),
                          ).animate(onPlay: (controller) => controller.repeat())
                              .shimmer(duration: 1200.ms, color:  kBlueColor.withAlpha(55))
                              .animate() // this wraps the previous Animate in another Animate
                              .fadeIn(duration: 700.ms, curve: Curves.easeOutQuad)
                              .slide(),
                        ),
                      ],
                    ).animate(onPlay: (controller) => controller.repeat())
                        .shimmer(duration: 1200.ms, color:  kBlueColor.withAlpha(55))
                        .animate() // this wraps the previous Animate in another Animate
                        .fadeIn(duration: 700.ms, curve: Curves.easeOutQuad)
                        .slide():
                    PopupMenuButton<StudentShareModel>(
                      constraints: BoxConstraints(
                        maxWidth: Get.width * 0.8,
                        minWidth: Get.width * 0.8,
                      ),
                      itemBuilder: (context) =>
                          controller.listPostTypes!.map((e) {
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
                                controller. choosingPostType(e);
                              },
                              child: SizedBox(
                                width: Get.width * 0.8,
                                child: Column(
                                  children: [
                                    CustomText(
                                      e.name??"",
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
                                    e == controller.listPostTypes?.last
                                        ? const SizedBox()
                                        :  Divider(
                                      color: kDarkBlueColor.withOpacity(0.5),
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
                      child: Container(
                        height: Get.height * 0.07,
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
                              minHeight: Get.height * 0.04,
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
                                    Container(
                                      width: Get.width * 0.6,
                                      child: CustomText(
                                        textAlign: TextAlign.center,
                                        maxLines: 3,
                                        controller.chosenPostType?.name??"",
                                        style: TextStyle(
                                          shadows: <Shadow>[
                                            Shadow(
                                                offset:
                                                const Offset(0.5, 0.5),
                                                blurRadius: 0.5,
                                                color: Colors.black
                                                    .withOpacity(0.5)),
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
                    const SizedBox(height: 5,),

                    controller.postIsLoading?
                    const SingleChildScrollView(
                      child: PostLoadingWidget(),
                    ):(controller.postsListData?.length??0)==0?controller.selectedPostType!=""?NoDataWidget(refreshedFunc: (){}, text:
                    Get.find<StorageService>().activeLocale ==
                        SupportedLocales.english
                        ? 'There are no posts available in this category ${controller.chosenPostType?.name??""}'
                        : 'لا يوجد منشورات متاحه هذا التصنيف ${controller.chosenPostType?.name??""}', imgPath: "assets/images/No data-cuate.png", hasRefreshButtonOrNot: false,):NoDataWidget(refreshedFunc: (){}, text: Get.find<StorageService>().activeLocale ==
                        SupportedLocales.english
                        ? 'No posts available'
                        : 'لا يوجد منشورات متاحه', imgPath: "assets/images/No data-cuate.png", hasRefreshButtonOrNot: false,)
                        :
                    Container(
                        color: Colors.white,
                        child:
                        Column(
                          children: [
                            ...List.generate(
                              controller.postsListData?.length??0,
                                  (index) => PostWidget(
                                postDataFromScreen: controller.postsListData?[index],
                                schoolId: "${controller.schoolId?.school ?? 0}",
                                classId: "${controller.schoolId?.schoolIdModelClass ?? 0}",
                                peopleSareList: controller.peopleShareList,
                              ),
                            ),
                            if (controller.isLoadingMoreDataForPosts)
                              const PostLoadingWidget(),
                          ],
                        )
                    ),
                  ],
                ),
              ),
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
                              color: Colors.black.withOpacity(0.1),
                              offset: const Offset(
                                0.0,
                                0.0,
                              ),
                              blurRadius: 13.0,
                              spreadRadius: 2.0,
                            ), //BoxShadow
                            BoxShadow(
                              color: Colors.white.withOpacity(0.2),
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
                ),



              ],
            ),
          ),

        ],
      ),
    );
  }
}
