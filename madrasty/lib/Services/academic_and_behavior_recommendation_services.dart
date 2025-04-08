
import 'package:get/get.dart';

import '../Models/academic_and_behavior_recommendation_model.dart';
import '../Models/academic_and_behavior_recommendation_reason_model.dart';
import '../Models/response_model.dart';
import '../Utils/api_service.dart';
import '../Utils/memory.dart';
import '../Utils/services.dart';

class AcademicAndBehaviorRecommendationService{
  static ApiService api = ApiService();
  static Future<ResponseModel?>addAcademicAndBehaviorRecommendation(String studentId,String academicAndBehaviorRecommendationType,String msg,titleId) async {

    var data = await api.request(Services.addAcademicAndBehaviorRecommendationEndPoint, "POST",queryParamters: {
      "type":academicAndBehaviorRecommendationType,
      "msg":msg,
      "title_id":titleId,
      "teacher_id":Get.find<StorageService>().getId,
      "student_id":studentId,
    });
    if (data != null) {
      return ResponseModel.fromJson(data);
    }
    return null;
  }
  static Future<List<AcademicAndBehaviorRecommendationModel>?>getTeacherAcademicAndBehaviorRecommendationList(String academicAndBehaviorRecommendationType) async {
    List<AcademicAndBehaviorRecommendationModel>?academicAndBehaviorRecommendationList = [];
    var data = await api.request(Services.getTeacherAcademicAndBehaviorRecommendationDataListEndPoint, "POST",queryParamters: {
      "teacher_id": Get
          .find<StorageService>()
          .getId,
      "type": academicAndBehaviorRecommendationType,
    });
    if (data != null) {
      for(var academicAndBehaviorRecommendationData  in data){
        academicAndBehaviorRecommendationList.add(AcademicAndBehaviorRecommendationModel.fromJson(academicAndBehaviorRecommendationData));
      }
      return academicAndBehaviorRecommendationList;
    }
    return null;
  }
  static Future<List<AcademicAndBehaviorRecommendationReasonModel>?>getReasonsOfAcademicAndBehaviorRecommendationList(String academicAndBehaviorRecommendationType) async {
    List<AcademicAndBehaviorRecommendationReasonModel>?academicAndBehaviorRecommendationReasonList = [];
    var data = await api.request(Services.getReasonAcademicAndBehaviorRecommendationDataListEndPoint, "POST",queryParamters: {

      "type": academicAndBehaviorRecommendationType,
    });
    if (data != null) {
      for(var academicAndBehaviorRecommendationReasonData  in data){
        academicAndBehaviorRecommendationReasonList.add(AcademicAndBehaviorRecommendationReasonModel.fromJson(academicAndBehaviorRecommendationReasonData));
      }
      return academicAndBehaviorRecommendationReasonList;
    }
    return null;
  }
  static Future<List<AcademicAndBehaviorRecommendationModel>?>getAcademicAndBehaviorRecommendationList(String academicAndBehaviorRecommendationType) async {
    List<AcademicAndBehaviorRecommendationModel>?academicAndBehaviorRecommendationList = [];
    var data = await api.request(Services.getAcademicAndBehaviorRecommendationDataListEndPoint, "POST",queryParamters: {
      "user_id": Get
          .find<StorageService>()
          .getId,
      "type": academicAndBehaviorRecommendationType,
    });
    if (data != null) {
      for(var academicAndBehaviorRecommendationData  in data){
        academicAndBehaviorRecommendationList.add(AcademicAndBehaviorRecommendationModel.fromJson(academicAndBehaviorRecommendationData));
      }
      return academicAndBehaviorRecommendationList;
    }
    return null;
  }
  static Future<List<AcademicAndBehaviorRecommendationModel>?>getAcademicAndBehaviorParentRecommendationList(String academicAndBehaviorRecommendationType,String kidId) async {
    List<AcademicAndBehaviorRecommendationModel>?academicAndBehaviorRecommendationList = [];
    var data = await api.request(Services.getAcademicAndBehaviorRecommendationDataListEndPoint, "POST",queryParamters: {
      "user_id": kidId,
      "type": academicAndBehaviorRecommendationType,
    });
    if (data != null) {
      for(var academicAndBehaviorRecommendationData  in data){
        academicAndBehaviorRecommendationList.add(AcademicAndBehaviorRecommendationModel.fromJson(academicAndBehaviorRecommendationData));
      }
      return academicAndBehaviorRecommendationList;
    }
    return null;
  }
}
