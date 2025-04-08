
import '../Models/student_model.dart';
import '../Utils/api_service.dart';
import '../Utils/services.dart';

class StudentServices {
  static ApiService api = ApiService();

  static Future<List<PersonModel>?>getStudentList(String schoolId,String classId,) async {
    List<PersonModel>?studentsData = [];

    var data = await api.request(Services.studentsListEndPoint, "POST",queryParamters: {
      "school_id":schoolId,
      "class_id":classId,
    });
    if (data != null) {
      for(var studentData  in data){
        studentsData.add(PersonModel.fromJson(studentData));
      }
      return studentsData;
    }
    return null;
  }

}