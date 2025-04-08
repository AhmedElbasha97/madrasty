import 'package:get/get.dart';
import '../Models/class_teacher_model.dart';
import '../Models/teacher_info_model.dart';
import '../Utils/api_service.dart';
import '../Utils/memory.dart';
import '../Utils/services.dart';

class TeacherServices {
  static ApiService api = ApiService();

  static Future<List<ClassTeacherModel>?>getStagesTeacher(String schoolId) async {
    List<ClassTeacherModel>?classTeacherList = [];
    var data = await api.request(Services.getClassTeacherListEndPoint, "POST",queryParamters:Get
        .find<StorageService>()
        .getUserType == "SUPERVISOR"? {
      "school_id": schoolId,
    }:{
      "school_id": schoolId,
      "teacher_id": Get
          .find<StorageService>()
          .getId,
    });
    if (data != null) {
      for(var classTeacher  in data){
        classTeacherList.add(ClassTeacherModel.fromJson(classTeacher));
      }
      return classTeacherList;
    }
    return null;
  }

  static Future<List<ClassTeacherModel>?>getClassTeacherModelList(String schoolId,String classId) async {
    List<ClassTeacherModel>?classTeacherList = [];
    var data = await api.request(Services.getClassTeacherListEndPoint, "POST",queryParamters:Get
        .find<StorageService>()
        .getUserType == "SUPERVISOR"?{
      "school_id": schoolId,
      "class_id": classId,

    }: {
      "school_id": schoolId,
      "class_id": classId,
      "teacher_id": Get
          .find<StorageService>()
          .getId,
    });
    if (data != null) {
      for(var classTeacher  in data){
        classTeacherList.add(ClassTeacherModel.fromJson(classTeacher));
      }
      return classTeacherList;
    }
    return null;
  }

  static Future<TeacherInfoModel?>getTeacherInfoData() async {
    var data = await api.request(Services.getTeacherInfoEndPoint, "POST",data: {
      "user_id":Get.find<StorageService>().getId,
    });
    if (data != null) {

      return TeacherInfoModel.fromJson(data);
    }
    return null;
  }

}