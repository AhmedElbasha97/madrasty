import 'package:get/get.dart';
import '../Models/attendance_table_model.dart';
import '../Models/response_model.dart';
import '../Models/student_attenndance_model.dart';
import '../Utils/api_service.dart';
import '../Utils/memory.dart';
import '../Utils/services.dart';

class AttendanceServices{
  static ApiService api = ApiService();
  static Future<List<AttendanceTableModel>?>getAttendanceTableList(String schoolId,String classId,String dayDate,) async {
    List<AttendanceTableModel>? attendanceTableList = [];
    var data = await api.request(Services.attendanceTableListEndPoint, "POST",queryParamters: {
      "school_id": schoolId,
      "class_id": classId,
      "day":dayDate
    });
    if (data != null) {
      for(var attendanceTableData  in data){
        attendanceTableList.add(AttendanceTableModel.fromJson(attendanceTableData));
      }
      return attendanceTableList;
    }
    return null;
  }
  static Future<List<StudentAttendanceModel>?>getStudentAttendanceTableList(String schoolId,String studentId,String startDayDate,String endDayDate,) async {
    List<StudentAttendanceModel>? studentAttendanceTableList = [];
    var data = await api.request(Services.getStudentAttendanceTableListEndPoint, "POST",queryParamters: {
      "school_id": schoolId,
      "student_id": studentId,
      "day_to":startDayDate,
      "day_from":endDayDate,
    });
    if (data != null) {
      for(var studentAttendanceTableData  in data){
        studentAttendanceTableList.add(StudentAttendanceModel.fromJson(studentAttendanceTableData));
      }
      return studentAttendanceTableList;
    }
    return null;
  }
  static Future<ResponseModel?>editTimeAttendanceOfStudent(String attendOrNot,String studentId,String dayDate, String attendTime) async {

    var data = await api.request(Services.editAttendanceTableListEndPoint, "POST",queryParamters: {
      "type":attendOrNot,
      "stu_id":studentId,
      "day":dayDate,
      "new_time":attendTime,
    });
    if (data != null) {
      return ResponseModel.fromJson(data);
    }
    return null;
  }
  static Future<ResponseModel?>editAttendanceOfStudent(String attendOrNot,String studentId,String dayDate) async {

    var data = await api.request(Services.editStatusAttendanceTableListEndPoint, "POST",queryParamters: {
      "add_remove":attendOrNot,
      "stu_id":studentId,
      "day":dayDate,
    });
    if (data != null) {
      return ResponseModel.fromJson(data);
    }
    return null;
  }
  static Future<ResponseModel?>editNotesAttendanceOfStudent(String notes,String studentId,String dayDate) async {

    var data = await api.request(Services.editNotesAttendanceTableListEndPoint, "POST",queryParamters: {
      "notes":notes,
      "student_id":studentId,
      "day":dayDate,
    });
    if (data != null) {
      return ResponseModel.fromJson(data);
    }
    return null;
  }

  static Future<ResponseModel?>sendingOrReceivingKidFromSchool(String kidId, String type) async {

    var data = await api.request(Services.sendingOrReceivingKidEndPoint, "POST",queryParamters: {
      "parent_id": Get
          .find<StorageService>()
          .getId,
      "student_id": kidId,
      "type":type
    });
    if (data != null) {
      return ResponseModel.fromJson(data);
    }
    return null;
  }
}