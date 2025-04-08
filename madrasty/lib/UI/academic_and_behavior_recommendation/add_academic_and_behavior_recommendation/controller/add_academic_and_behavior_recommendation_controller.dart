// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madrasty/Services/academic_and_behavior_recommendation_services.dart';
import 'package:madrasty/Utils/translation_key.dart';

import '../../../../Models/academic_and_behavior_recommendation_reason_model.dart';
import '../../../../Models/class_teacher_model.dart';
import '../../../../Models/response_model.dart';
import '../../../../Models/student_model.dart';
import '../../../../Models/teacher_info_model.dart';
import '../../../../Services/student_services.dart';
import '../../../../Services/teacher_services.dart';
import '../../../../Utils/localization_services.dart';
import '../../../../Utils/memory.dart';

class AddAcademicAndBehaviorRecommendationController extends GetxController {
  List<AcademicAndBehaviorRecommendationReasonModel>? reasonsForRecommendation ;
  List<String> typeOfRecommendation = [
    typeOfRecommendations.tr,
    typeOfRecommendation1.tr,
    typeOfRecommendation2.tr,
  ];
  String chosenTypeOfRecommendation  = "";
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  AcademicAndBehaviorRecommendationReasonModel? chosenReasonsForRecommendation;
   late List<ClassTeacherModel>? eductionStage ;
  ClassTeacherModel? chosenEductionStage ;
  List<ClassTeacherModel>? supStageOfSchool ;
  ClassTeacherModel? chosenSupStageOfSchool;
  List<ClassTeacherModel>? teacherClass;
  ClassTeacherModel? chosenClassOfSchool;
  List<PersonModel>? studentName ;
  PersonModel? chosenStudentName ;
  bool isSendingRecommendation = false;
  bool schedulesIsLoadingTable = true;
  late TextEditingController textController1;
  late FocusNode text1FocusNode;
   TeacherInfoModel? teacherData;
  bool isReasonForRecommendationLoading = true;
  bool isClassLoading = true;
  bool isSubStageLoading = true;
  bool isStudentNameLoading = true;
  @override
  onInit(){
    super.onInit();
  textController1 = TextEditingController();
  text1FocusNode = FocusNode();
    getTeacherData();
  }
  getTeacherData() async {
    teacherData = await TeacherServices.getTeacherInfoData();
  }
  getTeacherClass() async {
    isClassLoading = true;
    update();
    teacherClass = await TeacherServices.getClassTeacherModelList("${teacherData?.school??0}", "${chosenSupStageOfSchool?.id??0}");
    isClassLoading = false;
    update();
  }

  gettingRecommendationReasons()async{
    isReasonForRecommendationLoading = true;
    update();
    reasonsForRecommendation = await AcademicAndBehaviorRecommendationService.getReasonsOfAcademicAndBehaviorRecommendationList(chosenTypeOfRecommendation==typeOfRecommendation1.tr?"0":"1");
    eductionStage = await TeacherServices.getStagesTeacher("${teacherData?.school??0}");

    isReasonForRecommendationLoading = false;
    update();
  }

  gettingStudentData() async {
    isStudentNameLoading = true;
    update();
    studentName = await StudentServices.getStudentList("${teacherData?.school??0}", "${chosenClassOfSchool?.id??0}") ;
    isStudentNameLoading = false;
    update();
  }

  getTeacherSubStages() async {
    isSubStageLoading = true;
    update();
    supStageOfSchool = await TeacherServices.getClassTeacherModelList("${teacherData?.school??0}", "${chosenEductionStage?.id??0}");
    isSubStageLoading = false;
    update();
  }

  selectingTypeForRecommendation(String chosenType) async {
    chosenTypeOfRecommendation = chosenType;
    await gettingRecommendationReasons();
    update();
  }

  selectingReasonsForRecommendation(AcademicAndBehaviorRecommendationReasonModel chosenReasons){
    chosenReasonsForRecommendation = chosenReasons;
    update();
  }

  selectingEductionStage(ClassTeacherModel chosenStage){
    chosenEductionStage = chosenStage;
    chosenSupStageOfSchool = null;
    chosenClassOfSchool = null;
    chosenStudentName = null;
    getTeacherSubStages();
    update();
  }

  selectingClassOfSchool(ClassTeacherModel chosenClass){
    chosenClassOfSchool = chosenClass;
    gettingStudentData();

    chosenStudentName = null;
    update();
  }

  selectingSubStageOfSchool(ClassTeacherModel chosenSubStage){
    chosenSupStageOfSchool = chosenSubStage;

    chosenClassOfSchool = null;
    chosenStudentName = null;
    getTeacherClass();
    update();
  }

  selectingStudentName(PersonModel? chosenName){
    chosenStudentName = chosenName;
    update();
  }
sendRecommendation(BuildContext context) async {
  isSendingRecommendation = true;
  update();
  ResponseModel? data = await AcademicAndBehaviorRecommendationService.addAcademicAndBehaviorRecommendation(
      "${chosenStudentName?.id ?? 0}","${ typeOfRecommendation1.tr == chosenTypeOfRecommendation?0:1}",textController1.text,"${chosenReasonsForRecommendation?.id??0}");
  if (data?.status == "true") {
    final snackBar = SnackBar(content:
    Row(children: [
      const Icon(Icons.check, color: Colors.white,),
      const SizedBox(width: 10,),
      Text(Get
          .find<StorageService>()
          .activeLocale ==
          SupportedLocales.english
          ? 'The recommendation has been sent'
          : 'تم أرسال التوصيه ', style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold
      ),
      ),
    ],),
        backgroundColor: Colors.green
    );
    isSendingRecommendation = false;
    update();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pop(context);

  }
  else {
    isSendingRecommendation = false;
    update();
    final snackBar = SnackBar(content:
    Row(children: [
      const Icon(Icons.close, color: Colors.white,),
      const SizedBox(width: 10,),
      Text(Get
          .find<StorageService>()
          .activeLocale ==
          SupportedLocales.english
          ? 'An error occurred while sending the recommendation'
          : 'حدث خطاء أثناء أرسال التوصيه', style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold
      ),
      ),
    ],),
        backgroundColor: Colors.red
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
}