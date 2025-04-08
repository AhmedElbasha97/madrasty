// ignore_for_file: sized_box_for_whitespace

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:madrasty/Utils/services.dart';

import '../../Utils/Colors_File.dart';
import '../../Utils/constant.dart';
import '../../Utils/localization_services.dart';
import '../../Utils/memory.dart';
import '../../Utils/translation_key.dart';
import '../../Widgets/DrawerWidget.dart';
import '../../Widgets/custom_text_widget.dart';
import '../../Widgets/loader.dart';
import '../home_screen/widget/review_and_question_screen.dart';
import '../perent_profile_screen/widget/custom_tap_widget.dart';
import 'controller/school_details_controller.dart';

class SchoolDetailsScreen extends StatelessWidget {
  final String schoolId;
  const SchoolDetailsScreen({super.key, required this.schoolId});

  @override
  Widget build(BuildContext context) {
    return  GetBuilder(
      init: SchoolDetailsController(schoolId: schoolId),
      builder: (SchoolDetailsController controller) => Scaffold(
        appBar: AppBar(
          actions: [
            const SizedBox(
              width: 8,
            ),
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: Get.height * 0.07,
                  width: Get.width * 0.11,
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
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      )),
                ),
              ),
            ),
          ],
          leading: InkWell(
            onTap: () {
              controller.scaffoldState.currentState!.openDrawer();
            },
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Image.asset(
                "assets/icons/menu_icon.png",
                fit: BoxFit.contain,
                height: MediaQuery.of(context).size.height * 0.04,
                width: MediaQuery.of(context).size.width * 0.05,
              ),
            ),
          ),
          backgroundColor: kYellowColor,
          title: Image.asset(
            "assets/images/appMultiColorLogoWithoutbackground.png",
            fit: BoxFit.fitHeight,
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.3,
          ),
          centerTitle: true,
        ),
        key: controller.scaffoldState,
        drawer: AppDrawers(
          scaffoldKey: controller.scaffoldState,
        ),
        body: Container(
          width: Get.width,
          height: Get.height,
          decoration: const BoxDecoration(
            color: kYellowColor,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                width: Get.width,
                height: Get.height * 0.9,
                decoration: const BoxDecoration(
                  color: kLightBlueColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30.0),
                      topLeft: Radius.circular(30.0)),
                ),
                child: controller.isLoading?Loader(width: Get.width*0.9,
                  height: Get.height * 0.89,):SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 30.0, left: 15.0, right: 15.0),
                            child: CustomText(
                              controller.schoolData?.name??"",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily:
                                  Get.find<StorageService>().activeLocale ==
                                      SupportedLocales.english
                                      ? fontFamilyEnglishName
                                      : fontFamilyArabicName,
                                  color: kDarkBlueColor,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18),
                            ),
                          ),
                          CachedNetworkImage(
                            imageUrl:"${Services.baseUrl}${controller.schoolData?.logo}",
                            imageBuilder: ((context, image) {

                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 30.0, left: 15.0, right: 15.0),
                                child: InkWell(
                                  onTap: () {},
                                  child: Container(
                                    height: Get.height * 0.1,
                                    width: Get.width * 0.2,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: AssetImage(
                                              "assets/images/backgroundImage.png"),
                                          fit: BoxFit.cover),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: Get.height * 0.1,
                                          width: Get.width * 0.2,
                                          decoration:  BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: kDarkBlueColor,
                                            boxShadow: const [
                                              BoxShadow(
                                                color: kGrayColor,
                                                blurRadius: 2,
                                                offset:
                                                Offset(1, 1), // Shadow position
                                              ),
                                            ],
                                            image: DecorationImage(
                                              image: image,
                                              fit: BoxFit.cover,),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                            placeholder: (context, image) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 30.0, left: 15.0, right: 15.0),
                                child: InkWell(
                                  onTap: () {},
                                  child: Container(
                                    height: Get.height * 0.1,
                                    width: Get.width * 0.2,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: AssetImage(
                                              "assets/images/backgroundImage.png"),
                                          fit: BoxFit.cover),
                                    ),
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        color: kYellowColor,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            errorWidget: (context, url, error) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 30.0, left: 15.0, right: 15.0),
                                child: InkWell(
                                  onTap: () {},
                                  child: Container(
                                    height: Get.height * 0.1,
                                    width: Get.width * 0.2,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: AssetImage(
                                              "assets/images/backgroundImage.png"),
                                          fit: BoxFit.cover),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: Get.height * 0.1,
                                          width: Get.width * 0.2,
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
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),

                      Center(
                        child: SizedBox(
                          width: Get.width * 0.95,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      controller.showSchoolLocation();
                                    },
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: Get.height * 0.06,
                                          width: Get.width * 0.12,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(50),
                                            color: kDarkBlueColor,
                                            boxShadow: const [
                                              BoxShadow(
                                                color: kGrayColor,
                                                blurRadius: 2,
                                                offset: Offset(
                                                    1, 1), // Shadow position
                                              ),
                                            ],
                                          ),
                                          child: const Center(
                                              child: Icon(
                                                Icons.pin_drop_outlined,
                                                color: Colors.white,
                                                size: 25,
                                              )),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      controller.whatsapp(controller.schoolData?.whatsapp??"", context);
                                    },
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: Get.height * 0.06,
                                          width: Get.width * 0.12,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(50),
                                            color: kDarkBlueColor,
                                            boxShadow: const [
                                              BoxShadow(
                                                color: kGrayColor,
                                                blurRadius: 2,
                                                offset: Offset(
                                                    1, 1), // Shadow position
                                              ),
                                            ],
                                          ),
                                          child: const Center(
                                              child: Icon(
                                                Icons.message_outlined,
                                                color: Colors.white,
                                                size: 25,
                                              )),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  InkWell(
                                    onTap: () {},
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: Get.height * 0.06,
                                          width: Get.width * 0.12,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(50),
                                            color: kDarkBlueColor,
                                            boxShadow: const [
                                              BoxShadow(
                                                color: kGrayColor,
                                                blurRadius: 2,
                                                offset: Offset(
                                                    1, 1), // Shadow position
                                              ),
                                            ],
                                          ),
                                          child: const Center(
                                              child: Icon(
                                                Icons.rate_review_outlined,
                                                color: Colors.white,
                                                size: 25,
                                              )),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      controller.makePhoneCall(controller.schoolData?.phone??"", context);
                                    },
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: Get.height * 0.06,
                                          width: Get.width * 0.12,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(50),
                                            color: kDarkBlueColor,
                                            boxShadow: const [
                                              BoxShadow(
                                                color: kGrayColor,
                                                blurRadius: 2,
                                                offset: Offset(
                                                    1, 1), // Shadow position
                                              ),
                                            ],
                                          ),
                                          child: const Center(
                                              child: Icon(
                                                Icons.call,
                                                color: Colors.white,
                                                size: 25,
                                              )),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      controller.isLoading?Container():Container(
                        height: Get.height * 0.14,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                controller.getPreviousTap();
                              },
                              child: const Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: kDarkBlueColor,
                                  size: 35,
                                ),
                              ),
                            ),
                            Container(
                              width: Get.width*0.8,
                              child: SingleChildScrollView(
                                scrollDirection:Axis.horizontal,
                                child: Row(
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          controller.choosingUserTap((controller.userTaps?[
                                          controller.chosenUserTapIndicator]) );
                                        },
                                        child: CustomTapWidget(
                                          chosenOrNot: controller.userTaps?[
                                          controller.chosenUserTapIndicator] ==
                                              controller.chosenUserTap,
                                          title: Get.find<StorageService>()
                                              .activeLocale ==
                                              SupportedLocales.english
                                              ? (controller.userTaps?[
                                          controller.chosenUserTapIndicator].titleEn??""):controller.userTaps?[
                                          controller.chosenUserTapIndicator].title??""),),
                                    InkWell(
                                      onTap: () {
                                        controller.choosingUserTap((controller.userTaps?[
                                        controller.chosenUserTapIndicator+1]) );
                                      },
                                      child: CustomTapWidget(
                                          chosenOrNot: controller.userTaps?[
                                          controller.chosenUserTapIndicator+1] ==
                                              controller.chosenUserTap,
                                          title:  Get.find<StorageService>()
                                              .activeLocale ==
                                              SupportedLocales.english
                                              ? (controller.userTaps?[
                                          controller.chosenUserTapIndicator+1].titleEn??""):controller.userTaps?[
                                          controller.chosenUserTapIndicator+1].title??""),),
                                    InkWell(
                                      onTap: () {
                                        controller.choosingUserTap((controller.userTaps?[
                                        controller.chosenUserTapIndicator+2]) );
                                      },
                                      child: CustomTapWidget(
                                          chosenOrNot: controller.userTaps?[
                                          controller.chosenUserTapIndicator+2] ==
                                              controller.chosenUserTap,
                                          title:  Get.find<StorageService>()
                                              .activeLocale ==
                                              SupportedLocales.english
                                              ? (controller.userTaps?[
                                          controller.chosenUserTapIndicator+2].titleEn??""):controller.userTaps?[
                                          controller.chosenUserTapIndicator+2].title??""),),

                                  ],
                                ),
                              ),
                            ),

                            InkWell(
                              onTap: () {
                                controller.getNextTap();
                              },
                              child: const Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: kDarkBlueColor,
                                  size: 35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      (controller.chosenUserTap?.title??"") == schoolDetailsTap1.tr
                          ? Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          CarouselSlider.builder(
                            carouselController: controller.controller,
                            itemCount: controller.schoolImages.length,
                            itemBuilder: (BuildContext context,
                                int index, int realIndex) {
                              return CachedNetworkImage(
                                imageUrl:
                                controller.schoolImages[index],
                                imageBuilder: ((context, image) {
                                  return Container(
                                      width: MediaQuery.of(context)
                                          .size
                                          .width,
                                      height: MediaQuery.of(context)
                                          .size
                                          .height *
                                          0.3,
                                      margin:
                                      const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: image,
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius:
                                          const BorderRadius.all(
                                              Radius.circular(
                                                  15))));
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
                                            width:
                                            MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 150.0)),
                                  );
                                },
                                errorWidget: (context, url, error) {
                                  return Container(
                                      width: MediaQuery.of(context)
                                          .size
                                          .width,
                                      margin:
                                      const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      decoration: const BoxDecoration(
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
                              );
                            },
                            options: CarouselOptions(
                              autoPlay: true,
                              enlargeCenterPage: true,
                              aspectRatio: 2.0,
                              onPageChanged: (index, reason) {
                                controller.changeImage(index);
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: controller.dotsList,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: Get.width,
                              child: CustomText(
                                schoolDetailsText1.tr,
                                textAlign: Get.find<StorageService>()
                                    .activeLocale ==
                                    SupportedLocales.english
                                    ? TextAlign.left
                                    : TextAlign.right,
                                style: TextStyle(
                                    fontFamily: Get.find<StorageService>()
                                        .activeLocale ==
                                        SupportedLocales.english
                                        ? fontFamilyEnglishName
                                        : fontFamilyArabicName,
                                    color: kDarkBlueColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: CustomText(

                              controller.schoolData?.brief??"",
                            textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: Get.find<StorageService>()
                                      .activeLocale ==
                                      SupportedLocales.english
                                      ? fontFamilyEnglishName
                                      : fontFamilyArabicName,
                                  color: kDarkBlueColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: Get.width,
                              child: CustomText(
                                schoolDetailsText2.tr,
                                textAlign: Get.find<StorageService>()
                                    .activeLocale ==
                                    SupportedLocales.english
                                    ? TextAlign.left
                                    : TextAlign.right,
                                style: TextStyle(
                                    fontFamily: Get.find<StorageService>()
                                        .activeLocale ==
                                        SupportedLocales.english
                                        ? fontFamilyEnglishName
                                        : fontFamilyArabicName,
                                    color: kDarkBlueColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: SizedBox(
                              height: 150,
                              child: DecoratedBox(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(20)),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0, 2),
                                      blurRadius: 6,
                                      color: Colors.black12,
                                    ),
                                  ],
                                ),
                                child: controller.mapIsLoading
                                    ? const Center(
                                  child:
                                  CircularProgressIndicator(),
                                )
                                    : Padding(
                                  padding:
                                  const EdgeInsets.all(10.0),
                                  child: Container(
                                    width: Get.width * 0.9,
                                    decoration:
                                    const BoxDecoration(
                                      borderRadius:
                                      BorderRadius.all(
                                          Radius.circular(
                                              20)),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0, 2),
                                          blurRadius: 6,
                                          color: Colors.black12,
                                        ),
                                      ],
                                    ),
                                    child: GoogleMap(
                                      zoomControlsEnabled: false,
                                      scrollGesturesEnabled:
                                      false,
                                      compassEnabled: false,
                                      mapToolbarEnabled: false,
                                      rotateGesturesEnabled:
                                      false,
                                      tiltGesturesEnabled: false,
                                      zoomGesturesEnabled: false,
                                      myLocationButtonEnabled:
                                      false,
                                      mapType: MapType.normal,
                                      markers: Set<Marker>.of(
                                          controller
                                              .markers.values),
                                      initialCameraPosition:
                                      CameraPosition(
                                        target: LatLng(
                                            controller.position
                                                .latitude,
                                            controller.position
                                                .longitude),
                                        zoom: 17.0,
                                      ),
                                      onMapCreated:
                                          (GoogleMapController
                                      mcontroller) {
                                        controller.mapController =
                                            mcontroller;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      controller.showSchoolWebsite();
                                    },
                                    child: Container(
                                      height: Get.height * 0.1,
                                      width: Get.width * 0.7,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(10),
                                        image: const DecorationImage(
                                            image: AssetImage(
                                                "assets/images/backgroundImage.png"),
                                            fit: BoxFit.cover),
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.all(8.0),
                                          child: Container(
                                            height: Get.height * 0.1,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  10),
                                              color: kDarkBlueColor,
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
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                                children: [
                                                  CustomText(
                                                    schoolDetailsText3.tr,
                                                    textAlign: TextAlign
                                                        .center,
                                                    style: TextStyle(
                                                        fontFamily: Get.find<StorageService>()
                                                            .activeLocale ==
                                                            SupportedLocales
                                                                .english
                                                            ? fontFamilyEnglishName
                                                            : fontFamilyArabicName,
                                                        color:
                                                        kLightBlueColor,
                                                        fontWeight:
                                                        FontWeight
                                                            .w700,
                                                        fontSize: 15),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  const Icon(
                                                    Icons
                                                        .explore_outlined,
                                                    color:
                                                    kLightBlueColor,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                    onTap: () {},
                                    child: Container(
                                      height: Get.height * 0.1,
                                      width: Get.width * 0.9,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(10),
                                        image: const DecorationImage(
                                            image: AssetImage(
                                                "assets/images/backgroundImage.png"),
                                            fit: BoxFit.cover),
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.all(8.0),
                                          child: Container(
                                            height: Get.height * 0.1,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  10),
                                              color: kDarkBlueColor,
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
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                                children: [
                                                  CustomText(
                                                    schoolDetailsText4.tr,
                                                    textAlign: TextAlign
                                                        .center,
                                                    style: TextStyle(
                                                        fontFamily: Get.find<StorageService>()
                                                            .activeLocale ==
                                                            SupportedLocales
                                                                .english
                                                            ? fontFamilyEnglishName
                                                            : fontFamilyArabicName,
                                                        color:
                                                        kLightBlueColor,
                                                        fontWeight:
                                                        FontWeight
                                                            .w700,
                                                        fontSize: 15),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  const Icon(
                                                    Icons.message,
                                                    color:
                                                    kLightBlueColor,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                          : const ReviewAndQuestionScreen(),
                      const SizedBox(height: 30,),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
