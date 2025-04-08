// ignore_for_file: avoid_print, unused_local_variable

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:madrasty/Utils/Colors_File.dart';

class HomeController extends GetxController {
  int current = 0;
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();

  List<Widget> dotsList = [];
  List? child;
  final CarouselSliderController controller = CarouselSliderController();
  LatLng positionFromMap = const LatLng(0.0, 0.0);

  bool mapIsLoading = true;
  late GoogleMapController mapController;

  String googleApikey = "AIzaSyBr4gzBhTiKovqTAgfV0e0Ygh5SY6DWB2k";
  late LatLng position;
  int _markerIdCounter = 1;
  String previousMarkerId = "";
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  List<String> schoolImages = [
    "https://fastly.picsum.photos/id/1/5000/3333.jpg?hmac=Asv2DU3rA_5D1xSe22xZK47WEAN0wjWeFOhzd13ujW4",
    "https://fastly.picsum.photos/id/1/5000/3333.jpg?hmac=Asv2DU3rA_5D1xSe22xZK47WEAN0wjWeFOhzd13ujW4",
    "https://fastly.picsum.photos/id/1/5000/3333.jpg?hmac=Asv2DU3rA_5D1xSe22xZK47WEAN0wjWeFOhzd13ujW4",
    "https://fastly.picsum.photos/id/1/5000/3333.jpg?hmac=Asv2DU3rA_5D1xSe22xZK47WEAN0wjWeFOhzd13ujW4",
    "https://fastly.picsum.photos/id/1/5000/3333.jpg?hmac=Asv2DU3rA_5D1xSe22xZK47WEAN0wjWeFOhzd13ujW4",
  ];
  int chosenTap = 0;

  @override
  onInit() {
    super.onInit();
    makingDotsForCarouselSlider(0);
    _getCurrentLocation();
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

  void _getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    Position res = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    position = LatLng(res.latitude, res.longitude);
    _createMarker();
  }

  _createMarker() {
    print("create Marker$position");
    add(position.latitude, position.longitude);
  }

  add(double lat, double lang) {
    print("_add$lang$lat");
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
//get employees data
}
