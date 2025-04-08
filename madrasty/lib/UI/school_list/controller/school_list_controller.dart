// ignore_for_file: prefer_is_empty

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:madrasty/Services/school_services.dart';
import 'package:madrasty/Utils/Colors_File.dart';

import '../../../Models/school_filter_model.dart';
import '../../../Models/school_model.dart';
import '../../../Utils/services.dart';
import '../../../Utils/translation_key.dart';
import '../../../Widgets/alert_dialogue.dart';
import '../school_widget.dart';

class SchoolListController extends GetxController{
 late List<SchoolModel>? schoolsListData;

 late TextEditingController searchController;
 bool isSearchActive = false;
 List<Widget> schools = [];
 List<String> advertisementDataList = [];
 bool isLoading = true;
  List<SchoolFilterModel>? userType = [
  ];
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  List<SchoolFilterModel>? userType1 = [
  ];
  List<SchoolFilterModel>? userType2 = [
  ];
 SchoolFilterModel? chosenFilterStage;
 SchoolFilterModel? chosenFilterZone;
 SchoolFilterModel? chosenFilterType;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    searchController = TextEditingController();

    getData();
  }
  getData() async {
    schoolsListData = await SchoolServices.getSchoolsList();
    userType = await SchoolServices.getSchoolsTypeFilter();
    userType1 = await SchoolServices.getSchoolsZoneFilter();
    userType2 = await SchoolServices.getSchoolsStageFilter();
    await fillingData();
    isLoading = false;
    update();
  }
 fillingData()  async {
   schools = [];

   for (int i = 0; i <= schoolsListData!.length-1; i=i+2) {

     if(i<schoolsListData!.length-1){


       schools.add(
           Column(
             children: [
               Padding(
                 padding:const EdgeInsets.fromLTRB(5.0,10.0,5.0,10.0),
                 child: Row(
                     mainAxisAlignment:MainAxisAlignment.spaceAround,
                     children:[
                       SchoolWidget(schoolData: schoolsListData?[i],),
                       SchoolWidget(schoolData: schoolsListData?[i+1],),
                     ]
                 ),
               ),
               advertisementDataList.length !=0?i%5==0&&i!=0||(schoolsListData!.length == i||schoolsListData!.length == i-1)?Padding(
                 padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                 child: Container(
                   height: Get.height * 0.2,
                   width: Get.width,
                   color: Colors.white,
                   child: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: CarouselSlider(
                       options: CarouselOptions(
                           height: Get.height * 0.19,
                           aspectRatio: 2.0,
                           enlargeCenterPage: false,
                           viewportFraction: 1,
                           autoPlay: true),

                       items: advertisementDataList.map(
                               (e) {
                             return InkWell(
                               onTap: () {

                               },
                               child: CachedNetworkImage(
                                 fit: BoxFit.cover,
                                 imageUrl: "${Services.baseUrl}$e",
                                 imageBuilder: ((context, image) {
                                   return ClipRRect(
                                     borderRadius: BorderRadius.circular(15),
                                     child: Container(
                                         width: Get.width,
                                         height: Get.height * 0.16,
                                         decoration: BoxDecoration(
                                           image: DecorationImage(
                                             image: image,
                                             fit: BoxFit.cover,
                                           ),
                                         )
                                     ),
                                   );
                                 }),
                                 placeholder: (context, image) {
                                   return Container(

                                     width: Get.width,
                                     height: Get.height * 0.16,
                                     decoration: BoxDecoration(
                                       color: const Color(0xFFDFDDDF),
                                       borderRadius: BorderRadius.circular(15),

                                     ),
                                   ).animate(onPlay: (controller) =>
                                       controller.repeat())
                                       .shimmer(duration: 1200.ms,
                                       color: kYellowColor.withAlpha(10))
                                       .animate(); // this wraps the previous Animate in another Animate


                                 },
                                 errorWidget: (context, url, error) {
                                   return SizedBox(
                                     width: Get.width,
                                     height: Get.height * 0.16,
                                     child: Image.asset(
                                       "assets/images/logo sprinkles.png",
                                       fit: BoxFit.contain,),
                                   );
                                 },
                               ),
                             );
                           }
                       ).toList(),
                     ),
                   ),
                 ),
               ):const SizedBox():const SizedBox()
             ],
           )
       );



     }
     else{

       schools.add(
           Column(
             children: [
               Row(
                   mainAxisAlignment:MainAxisAlignment.start,
                   children:[
                     Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: SchoolWidget(schoolData: schoolsListData?[i],),
                     ),

                   ]
               ),
               advertisementDataList.isNotEmpty?Padding(
                 padding:const EdgeInsets.fromLTRB(5.0,10.0,5.0,10.0),
                 child: Container(
                   height: Get.height*0.2,
                   width:Get.width,
                   color:Colors.white,
                   child: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: CarouselSlider(
                       options:  CarouselOptions(
                           height: Get.height*0.19,
                           aspectRatio: 2.0,
                           enlargeCenterPage: false,
                           viewportFraction: 1,
                           autoPlay: true),

                       items: advertisementDataList.map(
                               (e){
                             return InkWell(
                               onTap:(){
                               },
                               child:CachedNetworkImage(
                                 fit: BoxFit.cover,
                                 imageUrl: "${Services.baseUrl}$e",
                                 imageBuilder: ((context, image){
                                   return  ClipRRect(
                                     borderRadius: BorderRadius.circular(15),
                                     child: Container(
                                         width:Get.width,
                                         height:Get.height*0.16,
                                         decoration: BoxDecoration(
                                           image: DecorationImage(
                                             image: image,
                                             fit:  BoxFit.cover,
                                           ),
                                         )
                                     ),
                                   );
                                 }),
                                 placeholder: (context, image){
                                   return   Container(

                                     width:Get.width,
                                     height:Get.height*0.16,
                                     decoration:BoxDecoration(
                                       color:  const Color(0xFFDFDDDF),
                                       borderRadius: BorderRadius.circular(15),

                                     ),
                                   ).animate(onPlay: (controller) => controller.repeat())
                                       .shimmer(duration: 1200.ms, color:  kYellowColor.withAlpha(10))
                                       .animate(); // this wraps the previous Animate in another Animate


                                 },
                                 errorWidget: (context, url, error){
                                   return SizedBox(
                                     width:Get.width,
                                     height:Get.height*0.16,
                                     child: Image.asset("assets/images/logo sprinkles.png",fit: BoxFit.contain,),
                                   );
                                 },
                               ),
                             );

                           }
                       ).toList(),
                     ),
                   ),
                 ),
               ):const SizedBox(),
             ],
           )
       );

     }


   }
 }
 startSearching(BuildContext context) async {
  if(searchController.text.replaceAll(' ', '') != ""||chosenFilterZone == null||chosenFilterType == null||chosenFilterStage == null ) {
      isSearchActive = true;
      update();
      schoolsListData = await SchoolServices.searchSchoolsList(
          searchController.text,
          chosenFilterZone == null ? "0" : "${chosenFilterZone?.id ?? 0}",
          chosenFilterType == null ? "0" : "${chosenFilterType?.id ?? 0}",
          chosenFilterStage == null ? "0" : "${chosenFilterStage?.id ?? 0}");
      fillingData();
      FocusManager.instance.primaryFocus?.unfocus();
      update();
    }else{
    showDialog(context: context,
        builder: (context) {
          return AlertDialogue(alertTitle: errorKey.tr, alertText: schoolSearchErrorKey.tr,alertIcon: "assets/icons/warningIcon.png",containerHeight:  Get.height*0.4);
        }
    );
  }
  }
 choosingFilterStage(SchoolFilterModel chosenFilter,BuildContext context){
   chosenFilterStage = chosenFilter;
   startSearching( context);
   update();
 }
 choosingFilterZone(SchoolFilterModel chosenFilter,BuildContext context){
   chosenFilterZone = chosenFilter;
   startSearching( context);
   update();
 }
 choosingFilterType(SchoolFilterModel chosenFilter,BuildContext context){
   chosenFilterType = chosenFilter;
   startSearching( context);
   update();
 }
}


