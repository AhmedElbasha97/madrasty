import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../Utils/Colors_File.dart';
import '../../../Utils/constant.dart';
import '../../../Utils/localization_services.dart';
import '../../../Utils/memory.dart';
import '../../../Widgets/custom_text_widget.dart';
import '../../../Widgets/loader.dart';
import '../controller/perent_profile_controller.dart';
import 'kids_widget_list.dart';

class DriverWidget extends StatelessWidget {
  const DriverWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: PerentProfileController(),
      builder: (PerentProfileController controller) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: Get.height * 0.06,
                  width: Get.width * 0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: kBlueColor,
                    boxShadow: const [
                      BoxShadow(
                        color: kGrayColor,
                        blurRadius: 2,
                        offset: Offset(1, 1), // Shadow position
                      ),
                    ],
                  ),
                  child: Center(
                    child: CustomText(
                      "مكانك الحالى",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: Get.find<StorageService>()
                              .activeLocale ==
                              SupportedLocales.english
                              ? fontFamilyEnglishName
                              : fontFamilyArabicName,
                          color: kLightBlueColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 17),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: Get.height * 0.06,
                  width: Get.width * 0.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          "${controller.getFormatedDate(DateTime.now())}",
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: TextStyle(
                              fontFamily: Get.find<StorageService>()
                                  .activeLocale ==
                                  SupportedLocales.english
                                  ? fontFamilyEnglishName
                                  : fontFamilyArabicName,
                              color: kLightBlueColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 15),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          Icons.calendar_month,
                          color: kLightBlueColor,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
                  borderRadius: BorderRadius.all(Radius.circular(20)),
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
                  child: CircularProgressIndicator(),
                )
                    : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: Get.width * 0.9,
                    decoration: const BoxDecoration(
                      borderRadius:
                      BorderRadius.all(Radius.circular(20)),
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
                      scrollGesturesEnabled: false,
                      compassEnabled: false,
                      mapToolbarEnabled: false,
                      rotateGesturesEnabled: false,
                      tiltGesturesEnabled: false,
                      zoomGesturesEnabled: false,
                      myLocationButtonEnabled: false,
                      mapType: MapType.normal,
                      markers: Set<Marker>.of(
                          controller.markers.values),
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                            controller.position.latitude,
                            controller.position.longitude),
                        zoom: 17.0,
                      ),
                      onMapCreated:
                          (GoogleMapController mcontroller) {
                        controller.mapController = mcontroller;
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          controller.isLoading?Loader(width: Get.width * 0.9,):Container(
            width: Get.width * 0.9,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: kGrayColor,
                    blurRadius: 2,
                    offset: Offset(1, 1), // Shadow position
                  ),
                ],
                border: Border.all(color: kDarkBlueColor, width: 1)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          "اسماء الطلاب:",
                          textAlign: TextAlign.center,
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
                      ],
                    ),
                    Column(
                      children: controller.kidsData!.map((kid){
                        return KidsWidgetList(kidData: kid, receivePress: () {controller.receivingKidFromSchool(double.parse(kid.school?.locationLon??"0.0"), double.parse(kid.school?.locationLat??"0.0"), context,"${kid.id??0}");}, sendPress: () {controller.sendingKidToSchool(double.parse(kid.school?.locationLon??"0.0"), double.parse(kid.school?.locationLat??"0.0"), context,"${kid.id??0}");}, showOnMap: () {controller.launchMap(double.parse(kid.school?.locationLat??"0.0"), double.parse(kid.school?.locationLon??"0.0"));  },);
                      }).toList(),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
