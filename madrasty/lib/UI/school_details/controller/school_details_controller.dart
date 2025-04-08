// ignore_for_file: unused_local_variable, library_prefixes, prefer_adjacent_string_concatenation

import 'dart:io';
import 'package:map_launcher/map_launcher.dart' as  mapLanch;

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:madrasty/Services/school_services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Models/school_categories_model.dart';
import '../../../Models/school_details_model.dart';
import '../../../Utils/Colors_File.dart';
import '../../../Utils/translation_key.dart';

class SchoolDetailsController extends GetxController{
  bool isLoading = true;
  final String schoolId;
  int current = 0;
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  List<SchoolCategoriesModel>? userTaps = [

  ];


  final CarouselSliderController controller = CarouselSliderController();

  SchoolCategoriesModel? chosenUserTap = SchoolCategoriesModel(id: 1,type: "hiiii",title: schoolDetailsTap1.tr,titleEn: schoolDetailsTap1.tr);
  int chosenUserTapIndicator = 0;
  List<Widget> dotsList = [];
  List? child;
  LatLng positionFromMap = const LatLng(0.0, 0.0);

  bool mapIsLoading = true;
  late GoogleMapController mapController;

  String googleApikey = "AIzaSyBr4gzBhTiKovqTAgfV0e0Ygh5SY6DWB2k";
  late LatLng position;
  int _markerIdCounter = 1;
  String previousMarkerId = "";
  late SchoolDetailModel? schoolData;
  String messageTextWhatsApp = "";

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  List<String> schoolImages = [
    "https://fastly.picsum.photos/id/1/5000/3333.jpg?hmac=Asv2DU3rA_5D1xSe22xZK47WEAN0wjWeFOhzd13ujW4",
    "https://fastly.picsum.photos/id/1/5000/3333.jpg?hmac=Asv2DU3rA_5D1xSe22xZK47WEAN0wjWeFOhzd13ujW4",
    "https://fastly.picsum.photos/id/1/5000/3333.jpg?hmac=Asv2DU3rA_5D1xSe22xZK47WEAN0wjWeFOhzd13ujW4",
    "https://fastly.picsum.photos/id/1/5000/3333.jpg?hmac=Asv2DU3rA_5D1xSe22xZK47WEAN0wjWeFOhzd13ujW4",
    "https://fastly.picsum.photos/id/1/5000/3333.jpg?hmac=Asv2DU3rA_5D1xSe22xZK47WEAN0wjWeFOhzd13ujW4",
  ];
  int chosenTap = 0;

  SchoolDetailsController({required this.schoolId});

  @override
  onInit() {
    super.onInit();
    makingDotsForCarouselSlider(0);

    getSchoolData();
  }
  getSchoolData() async {
  schoolData = await SchoolServices.getSchoolsDetails(schoolId);
  userTaps = await SchoolServices.getSchoolsTaps(schoolId);
  userTaps?.add(
    SchoolCategoriesModel(id: 1,type: "hiiii",title: schoolDetailsTap1.tr,titleEn: schoolDetailsTap1.tr),
  );
  userTaps?.add(
    SchoolCategoriesModel(id: 2,type: "hiiii",title: schoolDetailsTap2.tr,titleEn: schoolDetailsTap2.tr),
  );

  messageTextWhatsApp = ' رأيت هذا ال ${schoolData?.name??""} في تطبيق مدراستى و وأريد الاستفسار عنه ' + '\n I saw this ${schoolData?.name??""} In the MySchool app and I want to make an order ' ;

  _getCurrentLocation();
  isLoading = false;
  update();
  }
  choosingTap(int index) {
    chosenTap = index;
    update();
  }

  changeImage(int index) {
    current = index;
    makingDotsForCarouselSlider(index);
    update();
  }

  makingDotsForCarouselSlider(int activeIndex) {
    int productLength = schoolImages.length;
    dotsList = [];
    for (int i = 0; i < productLength; i++) {
      dotsList.add(Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: activeIndex == i ? kYellowColor : const Color(0xFFD8D8D8)),
          )));
    }
    update();
  }
  getNextTap() {
    if (userTaps!.length - 3 > chosenUserTapIndicator) {
      chosenUserTapIndicator = chosenUserTapIndicator + 1;
      update();
    }
  }

  choosingUserTap(SchoolCategoriesModel? tapName) {
    chosenUserTap = tapName;
    update();
  }

  getPreviousTap() {
    if (chosenUserTapIndicator > 0) {
      chosenUserTapIndicator = chosenUserTapIndicator - 1;
      update();
    }
  }
  void _getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    Position res = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    position = LatLng(double.parse(schoolData?.locationLat??"0.0"), double.parse(schoolData?.locationLon??"0.0"));
    _createMarker();
  }

  _createMarker() {
    add(position.latitude, position.longitude);
  }

  add(double lat, double lang) {
    final String markerIdVal = 'marker_id_$_markerIdCounter';
    previousMarkerId = markerIdVal;
    _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(lat, lang),
    );
    position = LatLng(lat, lang);

    markers[markerId] = marker;
    mapIsLoading = false;
    update();
  }
  Future<void> makePhoneCall(String phoneNumber,context) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);

    }
  showSchoolLocation() async {
    await mapLanch.MapLauncher.showMarker(
      mapType: Platform.isAndroid
          ?mapLanch.MapType.google:mapLanch.MapType.apple,
      coords: mapLanch.Coords(double.parse(schoolData?.locationLat??"0.0"), double.parse(schoolData?.locationLon??"0.0")),
      title: " ${schoolLocationKey.tr} ${schoolData?.name}",
      description: " ${schoolLocationKey.tr} ${schoolData?.name}",
    );
  }


  whatsapp(String contact,context) async{
    if (Platform.isIOS) {
      var iosUrl = "https://wa.me/$contact?text=${Uri.parse(
          messageTextWhatsApp)} " ;
      await launchUrl(Uri.parse(iosUrl));
    }
    else {
      var androidUrl = "whatsapp://send?phone=$contact&text=$messageTextWhatsApp";
      await launchUrl(Uri.parse(androidUrl));
    }

  }
  showSchoolWebsite() async {
    var uri = Uri.parse("https://flutter.io");
    if (await canLaunchUrl(uri)){
    await launchUrl(uri,mode:LaunchMode.inAppBrowserView);
    } else {
    // can't launch url
    }
  }
}