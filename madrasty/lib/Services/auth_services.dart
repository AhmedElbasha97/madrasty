import 'package:get/get.dart';

import '../Models/auth_model.dart';
import '../Models/response_model.dart';
import '../Utils/api_service.dart';
import '../Utils/memory.dart';
import '../Utils/services.dart';
import '../Utils/translation_key.dart';

class AuthServices {
  static ApiService api = ApiService();

  static Future<AuthModel?>signingUp(String userType,String phone) async {
    var data = await api.request(Services.signUpEndPoint, "POST",queryParamters: {
      "type":userType == userType2.tr?"TEACHER":userType == userType1.tr?"PARENT":userType == userType3.tr?"STUDENT":userType == userType4.tr?"SUPERVISOR":userType == userType5.tr?"DRIVER":"",
      "phone":phone,

    });
    if (data != null) {
      return AuthModel.fromJson(data);
    }
    return null;
  }
  static Future<AuthModel?>loggingIn(String name,String password,String userType) async {
    var data = await api.request(Services.logInEndPoint, "POST",queryParamters: {
      "username":name,
      "type":userType == userType2.tr?"TEACHER":userType == userType1.tr?"PARENT":userType == userType3.tr?"STUDENT":userType == userType4.tr?"SUPERVISOR":userType == userType5.tr?"DRIVER":"",
      "password":password,

    });
    if (data != null) {
      return AuthModel.fromJson(data);
    }
    return null;
  }
  static Future<AuthModel?>forgettingPassword(String phoneNumber,String userType) async {
    var data = await api.request(Services.forgettingPasswordEndPoint, "POST",queryParamters: {
      "phone":phoneNumber,
      "type":userType == userType2.tr?"TEACHER":userType == userType1.tr?"PARENT":userType == userType3.tr?"STUDENT":userType == userType4.tr?"SUPERVISOR":userType == userType5.tr?"DRIVER":"",

    });
    if (data != null) {
      return AuthModel.fromJson(data);
    }
    return null;
  }
  static Future<AuthModel?>editingUserData(String password) async {
    var data = await api.request(Services.editUserDataEndPoint, "POST",queryParamters: {
      "type": Get.find<StorageService>().getUserType,
      "user_id":Get.find<StorageService>().getId,
      "password":password,
    });
    if (data != null) {
      return AuthModel.fromJson(data);
    }
    return null;
  }
static Future<AuthModel?>sendingMessageToSchool(String schoolId,String message,String phoneNumber,) async {
    var data = await api.request(Services.sendingMessageToSchoolEndPoint, "POST",queryParamters: {
      "school_id":schoolId,
      "phone":phoneNumber,
      "msg":message,
    });
    if (data != null) {
      return AuthModel.fromJson(data);
    }
    return null;
  }
  static Future<ResponseModel?>editPassword(String password) async {



    var data = await api.request(Services.editingPasswordEndPoint, "POST",queryParamters: {
      "user_id":Get.find<StorageService>().getId,
      "type":Get.find<StorageService>().getUserType,
      "password":password,
    });

    if (data != null) {
      return ResponseModel.fromJson(data);
    }
    return null;
  }
  static Future<ResponseModel?>deleteAccount() async {



    var data = await api.request(Services.deletingAccountEndPoint, "POST",queryParamters: {
      "user_id":Get.find<StorageService>().getId,
      "type":Get.find<StorageService>().getUserType,
    });

    if (data != null) {
      return ResponseModel.fromJson(data);
    }
    return null;
  }
//types PARENT || TEACHER || DRIVER || SUPERVISOR || STUDENT
}