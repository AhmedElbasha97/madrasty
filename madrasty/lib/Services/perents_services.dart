import 'package:get/get.dart';

import '../Models/kids_model.dart';
import '../Models/student_model.dart';
import '../Utils/api_service.dart';
import '../Utils/memory.dart';
import '../Utils/services.dart';

class ParentServices {
  static ApiService api = ApiService();

  static Future<List<KidsModel>?>getKidsList() async {
    List<KidsModel>?kidsData = [];
    var data = await api.request(Services.kidsListEndPoint, "POST",queryParamters: {
      "parent_id":Get.find<StorageService>().getId,
    });
    if (data != null) {

      for(var kidData  in data){
        kidsData.add(KidsModel.fromJson(kidData));
      }
      return kidsData;
    }
    return null;
  }
  static Future<List<PersonModel>?>getParentList(String schoolId,String classId,) async {
    List<PersonModel>?parentsData = [];
    var data = await api.request(Services.parentsListEndPoint, "POST",data: {
      "school_id":schoolId,
      "class_id":classId,
    });
    if (data != null) {
      for(var parentData  in data){
        parentsData.add(PersonModel.fromJson(parentData));
      }
      return parentsData;
    }
    return null;
  }
}