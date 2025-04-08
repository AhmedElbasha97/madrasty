import 'package:get/get.dart';
import 'package:madrasty/Utils/memory.dart';

import '../Models/school_categories_model.dart';
import '../Models/school_details_model.dart';
import '../Models/school_filter_model.dart';
import '../Models/school_id_model.dart';
import '../Models/school_model.dart';
import '../Utils/api_service.dart';
import '../Utils/services.dart';

class SchoolServices{
  static ApiService api = ApiService();

  static Future<List<SchoolModel>?>getSchoolsList() async {
    List<SchoolModel>? schoolsData = [];
    var data = await api.request(Services.schoolListEndPoint, "POST",queryParamters: {
    });
    if (data != null) {
      for(var schoolData  in data){
        schoolsData.add(SchoolModel.fromJson(schoolData));
      }
      return schoolsData;
    }
    return null;
  }
  static Future<List<SchoolModel>?>searchSchoolsList(String schoolName,String zoneId,String typeId,String stageId) async {
    List<SchoolModel>? schoolsData = [];
    var data = await api.request(Services.searchSchoolListEndPoint, "POST",queryParamters: {
      "name":schoolName,
      "area":zoneId,
      "type":typeId,
      "level":stageId,
    });
    if (data != null) {
      for(var schoolData  in data){
        schoolsData.add(SchoolModel.fromJson(schoolData));
      }
      return schoolsData;
    }
    return null;
  }
  static Future<List<SchoolCategoriesModel>?>getSchoolsTaps(String schoolId) async {
    List<SchoolCategoriesModel>? schoolsTapsData = [];
    var data = await api.request(Services.schoolTapsEndPoint, "POST",queryParamters: {
      "school_id":schoolId,
    });
    if (data != null) {
      for(var schoolTapData  in data){
        schoolsTapsData.add(SchoolCategoriesModel.fromJson(schoolTapData));
      }
      return schoolsTapsData;
    }
    return null;
  }  static Future<List<SchoolFilterModel>?>getSchoolsTypeFilter() async {
    List<SchoolFilterModel>? schoolsTypesFiltersData = [];
    var data = await api.request(Services.schoolsTypeFilterEndPoint, "POST",);
    if (data != null) {
      for(var schoolTypeFilterData  in data){
        schoolsTypesFiltersData.add(SchoolFilterModel.fromJson(schoolTypeFilterData));
      }
      return schoolsTypesFiltersData;
    }
    return null;
  }  static Future<List<SchoolFilterModel>?>getSchoolsStageFilter() async {
    List<SchoolFilterModel>? schoolsStagesFiltersData = [];
    var data = await api.request(Services.schoolsStageFilterEndPoint, "POST");
    if (data != null) {
      for(var schoolStageFiltersData  in data){
        schoolsStagesFiltersData.add(SchoolFilterModel.fromJson(schoolStageFiltersData));
      }
      return schoolsStagesFiltersData;
    }
    return null;
  }  static Future<List<SchoolFilterModel>?>getSchoolsZoneFilter() async {
    List<SchoolFilterModel>? schoolsZonesFiltersData = [];
    var data = await api.request(Services.schoolsZoneFilterEndPoint, "POST");
    if (data != null) {
      for(var schoolZoneFiltersData  in data){
        schoolsZonesFiltersData.add(SchoolFilterModel.fromJson(schoolZoneFiltersData));
      }
      return schoolsZonesFiltersData;
    }
    return null;
  }
  static Future<SchoolDetailModel?>getSchoolsDetails(String schoolId) async {
    var data = await api.request(Services.schoolDetailsEndPoint, "POST",queryParamters: {
      "school_id":schoolId,
    });
    if (data != null) {

      return SchoolDetailModel.fromJson(data[0]);
    }
    return null;
  }
  static Future<SchoolIdModel?>getSchoolsId(String? studentId) async {
    var data = await api.request(Services.getSchoolIdsEndPoint, "POST",queryParamters: {
      "user_id":Get.find<StorageService>().getUserType=="PARENT"?studentId:Get.find<StorageService>().getId,
      "type":Get.find<StorageService>().getUserType=="PARENT"?"STUDENT":Get.find<StorageService>().getUserType,
    });
    if (data != null) {

      return SchoolIdModel.fromJson(data);
    }
    return null;
  }
}