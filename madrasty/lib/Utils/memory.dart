import 'dart:ui';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'localization_services.dart';

abstract class StorageKeys {
  StorageKeys();
  static const String activeLocale = "ACTIVE_LOCAL";
  static const String userId = "User_Id";
  static const String userType = "User_Type";
  static const String userOtp = "User_OTP";
  static const String username = "User_Name";
  static const String signingUp = "signing_Up";
  static const String forgettingPassword = "forgetting_password";
  static const String completeHisData = "Complete_His_Data";
  static const String notificationCount = "Notification_Count";
  static const String schoolId = "School_Id";

}

class StorageService extends GetxService {
  StorageService(this._prefs);

  final SharedPreferences _prefs;

  static Future<StorageService> init() async {
    // await GetStorage.init();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  //to save id of the account
  Future<void> saveAccountId(String userId) async =>
      _prefs.setString(StorageKeys.userId, userId);
  Future<void> saveSchoolId(String schoolId) async =>
      _prefs.setString(StorageKeys.schoolId, schoolId);
  Future<void> saveAccountType(String userType) async =>
      _prefs.setString(StorageKeys.userType, userType);
  Future<void> saveAccountOtp(String checker) async =>
      _prefs.setString(StorageKeys.userOtp, checker);
  Future<void> saveAccountName(String userName) async =>
      _prefs.setString(StorageKeys.username, userName);
  Future<void> saveNotificationCounter(int counter) async =>
      _prefs.setInt(StorageKeys.notificationCount, counter);

  Future<void> saveCheckerSigningUp(bool checker) async =>
      _prefs.setBool(StorageKeys.signingUp, checker);
  Future<void> saveCheckerForgettingPassword(bool checker) async =>
      _prefs.setBool(StorageKeys.forgettingPassword, checker);
  Future<void> saveCheckerCompletingUserData(bool checker) async =>
      _prefs.setBool(StorageKeys.completeHisData, checker);

  String get getId {
    return _prefs.getString(StorageKeys.userId)?? "0";
  }
  String get getUserType {
    return _prefs.getString(StorageKeys.userType)?? "0";
  }
  String get getUserOtp {
    return _prefs.getString(StorageKeys.userOtp)?? "0";
  }
  String get getUserName {
    return _prefs.getString(StorageKeys.username)?? "0";
  }
  String get getSchoolId {
    return _prefs.getString(StorageKeys.schoolId)?? "0";
  }

  int get getNotificationCounter {
    return _prefs.getInt(StorageKeys.notificationCount)?? 0;
  }
  bool get getCheckerSigningUp {
    return _prefs.getBool(StorageKeys.signingUp)??true;
  }
  bool get getCheckerForgettingPassword {
    return _prefs.getBool(StorageKeys.forgettingPassword)??true;
  }
  bool get getCheckerCompletingUserData {
    return _prefs.getBool(StorageKeys.completeHisData)??true;
  }
  removeOtpCode(){
    _prefs.remove(StorageKeys.userOtp);
    _prefs.remove(StorageKeys.signingUp);
  }
  removeCompletingUserData(){
    _prefs.remove(StorageKeys.completeHisData);
  }
  loggingOut(){
    _prefs.remove(StorageKeys.userId);
  }
  //
  // to check if user record dismissal or not
  bool get checkUserIsSignedIn  {
    return _prefs.containsKey(StorageKeys.userId);
  }
  bool get checkUserHasOtpAlready  {
    return _prefs.containsKey(StorageKeys.userOtp);
  }
  bool get checkCompleteHisData  {
    return _prefs.containsKey(StorageKeys.completeHisData);
  }


  //Active Locale
  Locale get activeLocale {
    return Locale(_prefs.getString(StorageKeys.activeLocale) ??
        SupportedLocales.arabic.toString());
  }

  set activeLocale(Locale activeLocal) {
    _prefs.setString(StorageKeys.activeLocale, activeLocal.toString());
  }
}