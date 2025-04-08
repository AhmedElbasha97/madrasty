import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:madrasty/Services/academic_and_behavior_recommendation_services.dart';

import '../../../../Models/academic_and_behavior_recommendation_model.dart';
import '../../../../Utils/memory.dart';
import '../../../../Utils/translation_key.dart';

class AcademicAndBehaviorRecommendationListController extends GetxController {
  List<String> typeOfRecommendation = [
    typeOfRecommendation1.tr,
    typeOfRecommendation2.tr,
  ];
  final String kidId;
  String chosenTypeOfRecommendation  = typeOfRecommendation1.tr;
  bool isLoading = true;
  List<AcademicAndBehaviorRecommendationModel>? academicAndBehaviorRecommendationList;
  ScrollController scrollController = ScrollController();
  bool isVisible = false;

  AcademicAndBehaviorRecommendationListController(this.kidId);
@override
  onInit(){
    super.onInit();
    getData();
    scrollController.addListener(() {
      if ((scrollController.position.pixels ) == (scrollController.position.maxScrollExtent)) {

      }
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (isVisible == true) {

          isVisible = false;
          update();
        }
      } else {
        if (scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (isVisible == false) {

            isVisible = true;
            update();
          }
        }
      }
    });
  }
  goUpToTopOfSScreen(){
    scrollController.animateTo( //go to top of scroll
        0,  //scroll offset to go
        duration: const Duration(milliseconds: 500), //duration of scroll
        curve:Curves.fastOutSlowIn //scroll type
    );
    isVisible = false;
    update();
  }
  selectingTypeForRecommendation(String chosenType) async {
    chosenTypeOfRecommendation = chosenType;
    getData();
    update();
  }
  getData() async {
   isLoading = true;
   update();
   if(Get.find<StorageService>().getUserType == "TEACHER") {
     academicAndBehaviorRecommendationList =
     await AcademicAndBehaviorRecommendationService
         .getTeacherAcademicAndBehaviorRecommendationList(
         chosenTypeOfRecommendation == typeOfRecommendation1.tr ? "0" : "1");
   }else  if(Get.find<StorageService>().getUserType == "PARENT") {
     academicAndBehaviorRecommendationList =
     await AcademicAndBehaviorRecommendationService
         .getAcademicAndBehaviorParentRecommendationList(
         chosenTypeOfRecommendation == typeOfRecommendation1.tr ? "0" : "1",kidId);
   }
   else{
     academicAndBehaviorRecommendationList =
     await AcademicAndBehaviorRecommendationService
         .getAcademicAndBehaviorRecommendationList(
         chosenTypeOfRecommendation == typeOfRecommendation1.tr ? "0" : "1");
   }
   isLoading = false;
   update();
  }
}