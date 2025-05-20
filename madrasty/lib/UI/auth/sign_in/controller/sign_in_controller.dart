// ignore_for_file: prefer_final_fields, sized_box_for_whitespace, unused_local_variable, avoid_init_to_null

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:madrasty/Services/app_info_services.dart';

import '../../../../Models/auth_model.dart';
import '../../../../Models/country_code_model.dart';
import '../../../../Services/auth_services.dart';
import '../../../../Utils/Colors_File.dart';
import '../../../../Utils/constant.dart';
import '../../../../Utils/localization_services.dart';
import '../../../../Utils/memory.dart';
import '../../../../Utils/services.dart';
import '../../../../Utils/translation_key.dart';
import '../../../../Utils/validator.dart';
import '../../../../Widgets/alert_dialogue.dart';
import '../../../../Widgets/custom_text_widget.dart';
import '../../otp_screen/otp_screen.dart';

class SignInController extends GetxController {
  List<String> userType = [
    chooseUserKey.tr,
    userType1.tr,
    userType2.tr,
    userType3.tr,
    userType4.tr,
    userType5.tr,
  ];
  List<CountryCodeModel>? countriesCodesList = [];
  CountryCodeModel? selectedCountryCode ;
String chosenUserType = chooseUserKey.tr;
  final _validatorHelber = ValidatorHelper.instance;
  bool isLoading = false;
  bool remembering = false;
  RxBool _visiblePsd = false.obs;
  RxBool _isEnableLogin = false.obs;

  bool get isEnableLogin => _isEnableLogin.value;

  bool get visiblePsd => _visiblePsd.value;

  void toggleVisiblePsd() {
    _visiblePsd.value = !_visiblePsd.value;
    update();
  }

  set isEnableLogin(bool value) {
    _isEnableLogin.value = value;

    update();
  }

  final formKey = GlobalKey<FormState>();
  late TextEditingController passwordController;
 bool isLoadingData = true;

  late TextEditingController phoneController;
  bool passValidated = false;
  bool phoneValidated = false;
  bool formValidated = false;
  bool passState = false;
  bool phoneState = false;
  bool passHasAnErrorViewed = false;
  bool emailHasAnErrorViewed = false;
  bool signingIn = false;

  @override
  void onInit() {
    super.onInit();
    passwordController = TextEditingController();
    phoneController = TextEditingController();
    checkForUpgrades();
    getCountriesCodes();
  }

  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
  getCountriesCodes() async {
    countriesCodesList = await AppInfoServices.getSchoolsList();
    _getCurrentLocation();
  }
  void _getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    Position res = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    getAddressOfLocation(res.latitude, res.longitude);

  }
  getAddressOfLocation(double lat,double long) async {
    List<Placemark> i =
    await placemarkFromCoordinates(lat, long);
    Placemark placeMark = i.first;
    bool isFoundCountry = false;
    for(var countryCode in countriesCodesList!){
      if(placeMark.country == countryCode.name){
        selectedCountryCode = countryCode;
        isLoadingData = false;
        isFoundCountry = true;
        update();
      }
    }
    if(!isFoundCountry){
      for(var countryCode in countriesCodesList!){
        if("Qatar" == countryCode.name){
          selectedCountryCode = countryCode;
          isLoading = false;
          update();
        }
      }
    }

  }
  choosingAnotherCountryCode(CountryCodeModel chosenCountryCode,BuildContext context){
    selectedCountryCode = chosenCountryCode;
    update();
    Navigator.pop(context);
  }
  choosingCountryCode(BuildContext context){
    showModalBottomSheet(
        context:context,
        shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
    top: Radius.circular(20),
    ),
    ),
    clipBehavior: Clip.antiAliasWithSaveLayer, builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: countriesCodesList!.map((e){
                 return InkWell(
                   onTap: (){
                     choosingAnotherCountryCode(e, context);
                   },
                   child: Container(
                     width: Get.width,
                     child: Column(
                       children: [
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Row(
                               children: [
                                 Container(
                                   width: 25,
                                   height: 25,
                                   decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(5),
                                       color: Colors.white,
                                       boxShadow: const [
                                         BoxShadow(
                                           color: kGrayColor,
                                           blurRadius: 2,
                                           offset:
                                           Offset(1, 1), // Shadow position
                                         ),
                                       ],
                                       border: Border.all(
                                           color: kDarkBlueColor, width: 1)),
                                   child: Center(
                                     child: Icon(
                                       Icons.check_box,
                                       color: selectedCountryCode?.name==e.name
                                           ? kDarkBlueColor
                                           : Colors.white,
                                     ),
                                   ),
                                 ),
                                 const SizedBox(
                                   width: 20,
                                 ),
                                 CachedNetworkImage(
                                   imageUrl:"${Services.baseUrl}${e.flag}",
                                   imageBuilder: ((context, image) {
                                     return Container(
                                         height: Get.height * 0.04,
                                         width: Get.width * 0.07,

                                         decoration: BoxDecoration(
                                           borderRadius: BorderRadius.circular(10),

                                           image: DecorationImage(
                                             image: image,
                                             fit: BoxFit.fitWidth,
                                           ),
                                         ));
                                   }),
                                   placeholder: (context, image) {
                                     return Padding(
                                       padding: const EdgeInsets.all(5),
                                       child: Container(
                                           decoration: const BoxDecoration(
                                               borderRadius:
                                               BorderRadius.all(
                                                   Radius.circular(
                                                       15))),
                                           child:const CircularProgressIndicator(
                                             color: kYellowColor,
                                           )),
                                     );
                                   },
                                   errorWidget: (context, url, error) {
                                     return Container(
                                         height: Get.height * 0.04,
                                         width: Get.width * 0.07,

                                         decoration: const BoxDecoration(

                                             image: DecorationImage(
                                               image: AssetImage(
                                                   "assets/images/27002.jpg"),
                                               fit: BoxFit.fitHeight,
                                             ),
                                             borderRadius:
                                             BorderRadius.all(
                                                 Radius.circular(
                                                     10))));
                                   },
                                 ),
                                 const SizedBox(
                                   width: 5,
                                 ),
                                 CustomText(
                                   "   ${e.name}    ",
                                   style: TextStyle(
                                     fontSize: 15.0,
                                     fontFamily: Get.find<
                                         StorageService>()
                                         .activeLocale ==
                                         SupportedLocales
                                             .english
                                         ? fontFamilyEnglishName
                                         : fontFamilyArabicName,
                                     color: kBlueColor,
                                   ),
                                 ),
                               ],
                             ),
                             CustomText(
                               "   ${e.code}    ",
                               style: TextStyle(
                                 fontSize: 15.0,
                                 fontFamily: Get.find<
                                     StorageService>()
                                     .activeLocale ==
                                     SupportedLocales
                                         .english
                                     ? fontFamilyEnglishName
                                     : fontFamilyArabicName,
                                 color: kBlueColor,
                               ),
                             ),
                           ],
                         ),
                         const SizedBox(
                           height: 10,
                         ),
                         e ==  countriesCodesList?.last
                             ? const SizedBox()
                             : const Divider(
                           color: kYellowColor,
                           height: 1,
                           thickness: 1,
                           endIndent: 0,
                           indent: 0,
                         ),
                         const SizedBox(
                           height: 10,
                         ),
                       ],
                     ),
                   ),
                 );
                }).toList(),
              ),
            ),
          );
    },
    );
  }
  void clear() {
    passwordController.clear();
    phoneController.clear();
  }

  rememberMe() {
    remembering = !remembering;
    update();
  }

  chooseUserType(String userType){
    chosenUserType = userType;
    update();
  }
  checkForUpgrades() {
    InAppUpdate.checkForUpdate().then((updateInfo) {
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        if (updateInfo.immediateUpdateAllowed) {
          // Perform immediate update
          InAppUpdate.performImmediateUpdate().then((appUpdateResult) {
            if (appUpdateResult == AppUpdateResult.success) {
              //App Update successful
            }
          });
        } else if (updateInfo.flexibleUpdateAllowed) {
          //Perform flexible update
          InAppUpdate.startFlexibleUpdate().then((appUpdateResult) {
            if (appUpdateResult == AppUpdateResult.success) {
              //App Update successful
              InAppUpdate.completeFlexibleUpdate();
            }
          });
        }
      }
    });
  }

  void onPhoneNumberUpdate(String? value) {
    if (value == "") {
      phoneState = false;
    }
    update();
  }

  String? validatePhoneNumber(String? phoneNumber) {
    var validateName = null;
    if (validateName == null && phoneNumber != "") {
      phoneState = true;
      phoneValidated = true;
    } else {
      phoneValidated = true;
      phoneState = false;
    }
    return validateName;
  }

  String? validatePassword(String? password) {
    String? validatePassword = _validatorHelber.validatePassword(password);
    if (validatePassword == null) {
      passState = true;
    } else {}
    passValidated = true;
    validatePassword = null;
    return validatePassword;
  }

  Future<void> sendPressed(context) async {
    formValidated = formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (formValidated) {
      sinningIn(context);
    }
  }
  void onpPassUpdate(String? value) {
    if (value == "") {
      passState = false;
    }
    update();
  }
  // late String _optCode;
  Future errorDialog(String err) async {
    return Get.defaultDialog(
        title: "error /n tryAgain.tr ",
        titlePadding: const EdgeInsets.symmetric(vertical: 10),
        middleText: err);
  }

  sinningIn(context) async {
    signingIn = true;
    update();

    if(phoneState&&passState&&chosenUserType !=( chooseUserKey.tr)){

      AuthModel? data = await AuthServices.loggingIn(
          "${selectedCountryCode?.code ?? ""}${phoneController.text}", passwordController.text,chosenUserType);
      if(data?.status == "true"){
        await Get.find<StorageService>().saveAccountType(data?.info?.type??"");
        await Get.find<StorageService>().saveAccountId("${data?.info?.id??0}");
        await Get.find<StorageService>().saveAccountOtp("${data?.info?.otp??0}");
        await Get.find<StorageService>().saveAccountName(data?.info?.name??"");
        await Get.find<StorageService>().saveUserPhoneNumber(
            " ${phoneController.text ?? ""}");
        await Get.find<StorageService>().saveUserCountryCode(
            " ${selectedCountryCode?.code ?? ""}");
        await Get.find<StorageService>().saveCheckerSigningUp(false);
        await Get.find<StorageService>().saveCheckerForgettingPassword(false);
        await Get.to(()=>const OtpScreen(comingFromSignUp: false,comingFromForgetPassword: false,));
      }else{
        isLoading = false;
        update();
        showDialog(context: context,
            builder: (context) {
              return AlertDialogue(alertTitle: errorKey.tr, alertText: data?.msg??"",alertIcon: "assets/icons/warningIcon.png",containerHeight:  Get.height*0.4);
            }
        );
      }
    }else{
      isLoading = false;
      update();
      if(chosenUserType == chooseUserKey.tr){
        showDialog(context: context,
            builder: (context) {
              return AlertDialogue(alertTitle: errorKey.tr, alertText:signInAlert.tr,alertIcon: "assets/icons/warningIcon.png",containerHeight:  Get.height*0.4);
            });
      }
    }
  }

  @override
  String toString() {
    return 'LoginController{ _email: ${phoneController.value}, _password: ${passwordController.value}}';
  }
}
