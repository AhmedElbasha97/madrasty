
// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages, unused_local_variable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as color;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:madrasty/Models/response_model.dart';
import 'package:madrasty/Services/attendance_services.dart';
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:madrasty/Services/perents_services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:math' show sin, cos, sqrt, atan2;
import 'package:vector_math/vector_math.dart';

import '../../../Models/kids_model.dart';
import '../../../Models/person_info_model.dart';
import '../../../Services/posting_services.dart';
import '../../../Utils/localization_services.dart';
import '../../../Utils/memory.dart';
import '../../../Utils/translation_key.dart';
import '../../../Widgets/alert_dialogue.dart';


class DriverProfileController extends GetxController{
  //taps variable
  List<String> userTaps = [
    parentTap4.tr,
    parentTap7.tr,
  ];
  int chosenUserTapIndicator = 0;
  String chosenUserTap = parentTap4.tr;
  //google map variables

  bool mapIsLoading = true;
  late GoogleMapController mapController;

  late LatLng position;
  int _markerIdCounter = 1;
  String previousMarkerId = "";
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

//kids variable
  List<KidsModel>? kidsData = [];
  bool isLoading = true;
  double earthRadius = 6371000;

  @override
  onInit() {
    super.onInit();
    getKidsData();
    _getCurrentLocation();
  }
  Future<void> launchMap(double latitude, double longitude) async {
    Uri uri;

    if (Platform.isAndroid) {
      uri = Uri.parse('geo:$latitude,$longitude?q=$latitude,$longitude');
    } else {
      uri = Uri.parse('comgooglemaps://?q=$latitude,$longitude');
    }

    final fallbackUri = Uri(
      scheme: "https",
      host: "maps.google.com",
      queryParameters: {'q': '$latitude, $longitude'},
    );

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        await launchUrl(fallbackUri);
      }
    } catch (e) {
      await launchUrl(fallbackUri);
      debugPrint(e.toString());
    }
  }
  sendingOrReceivingKid(String type,String kidId,BuildContext context,) async {
    ResponseModel? data = await AttendanceServices.sendingOrReceivingKidFromSchool(kidId, type);
    if (data?.status == "true") {
      final snackBar = SnackBar(content:
      Row(children: [
        const Icon(Icons.check, color: color.Colors.white,),
        const SizedBox(width: 10,),
        Text(Get
            .find<StorageService>()
            .activeLocale ==
            SupportedLocales.english
            ? type == "0"?'The student was successfully delivered to the school':'The student was successfully received from the school'
            : type == "0"?'تم تسليم الطالب للمدرسه بنجاح':'تم أستلام الطالب من المدرسه بنجاح', style: const TextStyle(
            color: color.Colors.white,
            fontWeight: FontWeight.bold
        ),
        ),
      ],),
          backgroundColor: color.Colors.green
      );
      isLoading = false;
      update();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    else {
      isLoading = false;
      update();
      final snackBar = SnackBar(content:
      Row(children: [
        const Icon(Icons.close, color: color.Colors.white,),
        const SizedBox(width: 10,),
        Text(Get
            .find<StorageService>()
            .activeLocale ==
            SupportedLocales.english
            ? data?.msg??""
            : data?.msgAr??"", style: const TextStyle(
            color: color.Colors.white,
            fontWeight: FontWeight.bold
        ),
        ),
      ],),
          backgroundColor: color.Colors.red
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
//Using pLat and pLng as dummy location
  sendingKidToSchool(double pLng,double pLat,BuildContext context,String kidId){
    if( getDistance( pLng,pLat) <= 1000){
      sendingOrReceivingKid("1",kidId,context);
    }else{
      showDialog(context: context,
          builder: (context) {
            return AlertDialogue(alertTitle: errorKey.tr, alertText: sendingKidErrorKey.tr,alertIcon: "assets/icons/warningIcon.png",containerHeight:  Get.height*0.4);
          });
    }
  }
  receivingKidFromSchool(double pLng,double pLat,BuildContext context,String kidId){
    if( getDistance( pLng,pLat) <= 1000){
      sendingOrReceivingKid("0",kidId,context);
    }else{
      showDialog(context: context,
          builder: (context) {
            return AlertDialogue(alertTitle: errorKey.tr, alertText:receivingKidErrorKey.tr,alertIcon: "assets/icons/warningIcon.png",containerHeight:  Get.height*0.4);
          });
    }
  }
//Calculating the distance between two points
  getDistance(double pLng,double pLat){
    var dLat = radians(pLat - position.latitude);
    var dLng = radians(pLng - position.longitude);
    var a = sin(dLat/2) * sin(dLat/2) + cos(radians(position.latitude))
        * cos(radians(pLat)) * sin(dLng/2) * sin(dLng/2);
    var c = 2 * atan2(sqrt(a), sqrt(1-a));
    var d = earthRadius * c;
    return d;//d is the distance in meters
  }
  getNextTap() {
    if (userTaps.length - 3 > chosenUserTapIndicator) {
      chosenUserTapIndicator = chosenUserTapIndicator + 1;
      update();
    }
  }
  choosingUserTap(String tapName) {
    chosenUserTap = tapName;

    update();
  }
  getPreviousTap() {
    if (chosenUserTapIndicator > 0) {
      chosenUserTapIndicator = chosenUserTapIndicator - 1;
      update();
    }
  }
  getKidsData() async {
    kidsData = await ParentServices.getKidsList();
    PersonInfoModel?  userData = await PostingServices.getPersonInfoData();
    await Get.find<StorageService>().saveSchoolId("${userData?.school??0}");
    isLoading = false;
    update();
  }

  void _getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    Position res = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    position = LatLng(res.latitude, res.longitude);
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
}