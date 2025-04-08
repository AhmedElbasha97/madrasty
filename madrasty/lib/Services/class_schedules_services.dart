import 'package:get/get.dart';

import '../Models/class_schedules_model.dart';
import '../Models/teacher_schedules_class_model.dart';
import '../Utils/api_service.dart';
import '../Utils/memory.dart';
import '../Utils/services.dart';

class ClassSSchedulesServices{

  static ApiService api = ApiService();

  static Future<ClassSchedulesModel?>getClassTableList(String schoolId,String classId,) async {

    var data = await api.request(Services.getClassSchedulesListEndPoint, "POST",data: {
      "school_id":schoolId,
      "class_id":classId,
    });
    if (data != null) {

      return ClassSchedulesModel.fromJson(data);
    }
    return null;
  }

  static Future<TeacherSchedulesClassModel?>getClassTableTeacherList(String schoolId,String classId,) async {

    var data = await api.request(Services.getTeacherClassSchedulesListEndPoint, "POST",data: {
      "school_id":schoolId,
      "teacher_id":Get
          .find<StorageService>()
          .getId,
    });
    if (data != null) {

      return TeacherSchedulesClassModel.fromJson(data);
    }
    return null;
  }

}