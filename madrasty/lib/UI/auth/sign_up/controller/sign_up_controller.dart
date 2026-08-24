// ignore_for_file: prefer_final_fields, unused_local_variable, use_build_context_synchronously, avoid_init_to_null, sized_box_for_whitespace

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:madrasty/Services/auth_services.dart';
import 'package:madrasty/UI/auth/otp_screen/otp_screen.dart';
import 'package:madrasty/UI/auth/sending_message_school/sending_message_school_screen.dart';
import 'package:madrasty/UI/home_screen/home_screen.dart';

import '../../../../Models/auth_model.dart';
import '../../../../Models/country_code_model.dart';
import '../../../../Services/app_info_services.dart';
import '../../../../Utils/Colors_File.dart';
import '../../../../Utils/constant.dart';
import '../../../../Utils/localization_services.dart';
import '../../../../Utils/memory.dart';
import '../../../../Utils/services.dart';
import '../../../../Utils/translation_key.dart';
import '../../../../Utils/validator.dart';
import '../../../../Widgets/alert_dialogue.dart';
import '../../../../Widgets/custom_text_widget.dart';
import '../../../../Widgets/yes_or_no_alert_dialogue.dart';

class SignUpController extends GetxController {
  List<String> userType = [
    chooseUserKey.tr,
    userType1.tr,
    userType2.tr,
    userType3.tr,
    userType4.tr,
    userType5.tr,
  ];
  String chosenUserType =     chooseUserKey.tr;
  bool isLoadingData = true;
  List<CountryCodeModel>? countriesCodesList = [];
  CountryCodeModel? selectedCountryCode ;
  final _validatorHelber = ValidatorHelper.instance;
  bool isLoading = false;
  RxBool _visiblePsd = false.obs;
  RxBool _isEnableLogin = false.obs;

  bool get isEnableLogin => _isEnableLogin.value;

  bool get visiblePsd => _visiblePsd.value;
  int val = 0;

  void toggleVisiblePsd() {
    _visiblePsd.value = !_visiblePsd.value;
    update();
  }

  set isEnableLogin(bool value) {
    _isEnableLogin.value = value;

    update();
  }

  final formKey = GlobalKey<FormState>();
  final formKey1 = GlobalKey<FormState>();
  late TextEditingController phoneController;
  late TextEditingController nameController;

  late TextEditingController passwordController;
  late TextEditingController reTypePasswordController;
  bool passValidated = false;
  bool nameValidated = false;
  bool secondNameValidated = false;
  bool lastNameValidated = false;
  bool phoneValidated = false;
  bool reTypePasswordValidated = false;
  bool formValidated = false;
  bool passState = false;
  bool reTypePasswordState = false;
  bool nameState = false;
  bool secondNameState = false;
  bool lastNameState = false;
  bool phoneState = true;
  bool signingUp = false;
  bool isFoundCountry = false;

  @override
  void onInit() {
    super.onInit();
    passwordController = TextEditingController();
    reTypePasswordController = TextEditingController();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    getCountriesCodes();
  }

  @override
  void onClose() {
    passwordController.dispose();
    reTypePasswordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  void clear() {
    passwordController.clear();
    reTypePasswordController.clear();
    nameController.clear();
    phoneController.clear();
  }
  chooseUserType(String userType){
    chosenUserType = userType;
    update();
  }


  void onNameUpdate(String? value) {
    if (value == "") {
      nameState = false;
    }
    update();
  }
  void onpPassUpdate(String? value) {
    if (value == "") {
      passState = false;
    }
    update();
  }
  void onpReTypePassUpdate(String? value) {
    if (value == "") {
      reTypePasswordState = false;
    }
    update();
  }

  String? validateName(String? name) {
    var validateName = _validatorHelber.validateName(name);
    if (validateName == null && name != "") {
      nameState = true;
      nameValidated = true;
    } else {
      nameValidated = true;
      nameState = false;
    }
    return validateName;
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
    } else {
    passValidated = true;
    }
    validatePassword =null;
    return validatePassword;
  }

  changeValueOfRadioBTN(value, context) {
    if (val == 0) {
      val = 1;
    } else {
      val = 0;
    }
    update();
  }

  String? validateReTypePassword(String? password) {
    var validatePassword = _validatorHelber.validatePassword(password);
    if (validatePassword == null) {
      if (passwordController.text != "") {
        if (password == passwordController.text) {
          reTypePasswordState = true;

        } else {
          validatePassword = invalidReTypePassword.tr;
        }
      } else {
        validatePassword = enterPasswordFirst.tr;
      }
    } else {
      reTypePasswordState = false;
      reTypePasswordValidated = false;
    }
    reTypePasswordValidated = true;
    validatePassword = null;
    return validatePassword;
  }

  Future<void> sendPressed(context) async {
    formValidated = formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (formValidated) {
      signningUp(context);
    }
  }
  Future<void> sendPressed1(context) async {
    formValidated = formKey1.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (formValidated) {
      completingData(context);
    }
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
    for(var countryCode in countriesCodesList!){
      if(placeMark.country == countryCode.name){
        selectedCountryCode = countryCode;
        isLoadingData = false;
        isFoundCountry = true;
        update();
      }
    }

  }
  choosingAnotherCountryCode(CountryCodeModel chosenCountryCode,BuildContext context){
    selectedCountryCode = chosenCountryCode;
    isFoundCountry = true;
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
// late String _optCode;
  Future errorDialog(String err) async {
    return Get.defaultDialog(
        title: "error /n tryAgain.tr ",
        titlePadding: const EdgeInsets.symmetric(vertical: 10),
        middleText: err);
  }
completingData(
   BuildContext context)
async {
  isLoading = true;
  update();

    if(passState&&reTypePasswordState){
      AuthModel? data = await AuthServices.editingUserData( passwordController.text);
      if(data?.status == "true"){
        isLoading = false;
        update();
        await Get.find<StorageService>().removeCompletingUserData();
        await Get.to(()=> const HomeScreen());
      }else{
        isLoading = false;
        update();
        await Get.find<StorageService>().removeCompletingUserData();
        await Get.to(()=> const HomeScreen());
        showDialog(context: context,
            builder: (context) {
              return AlertDialogue(alertTitle: errorKey.tr, alertText: data?.msg??"",alertIcon: "assets/icons/warningIcon.png",containerHeight:  Get.height*0.4);
            }
        );}

  }
}

  signningUp(BuildContext context) async {

    isLoading = true;
    update();
      if(phoneState&&(val == 1)&&chosenUserType != chooseUserKey.tr&&selectedCountryCode!=null){

        AuthModel? data = await AuthServices.signingUp(chosenUserType, "${selectedCountryCode?.code ?? ""}${phoneController.text}");
        if(data?.status == "true"){
          if(data?.msg!="OLD") {
            await Get.find<StorageService>().saveAccountType(
                data?.info?.type ?? "");
            await Get.find<StorageService>().saveAccountId(
                "${data?.info?.id ?? 0}");
            await Get.find<StorageService>().saveAccountOtp(
                "${data?.info?.otp ?? 0}");
            await Get.find<StorageService>().saveAccountName(
                data?.info?.name ?? "");
            await Get.find<StorageService>().saveUserPhoneNumber(
                " ${phoneController.text}");
            await Get.find<StorageService>().saveUserCountryCode(
                " ${selectedCountryCode?.code ?? ""}");
            await Get.find<StorageService>().saveCheckerSigningUp(true);
            await Get.find<StorageService>().saveCheckerForgettingPassword(false);
            await Get.to(()=>const OtpScreen(comingFromSignUp: false,comingFromForgetPassword: false,));
            isLoading = false;
            update();
          }else{
            showDialog(context: context,
                builder: (context) {
                  return AlertDialogue(alertTitle: errorKey.tr, alertText: "هذا الرقم تم تسجيله بالفعل",alertIcon: "assets/icons/warningIcon.png",containerHeight:  Get.height*0.4);
                }
            );
          }
        }else{
          isLoading = false;
          update();
          showDialog(context: context,
              builder: (context) {
            return YesOrNoAlertDialogue(alertTitle: errorKey.tr, alertText: Get.find<StorageService>().activeLocale ==
                SupportedLocales.english
                ? "user type"
                :"This number is not registered in the school. You can send a message to the school to register you.",alertIcon: "assets/icons/warningIcon.png",containerHeight:  Get.height*0.4, yesAlertText: Get.find<StorageService>().activeLocale ==
                SupportedLocales.english
                ? "ok"
                :'حسنا', noAlertText: Get.find<StorageService>().activeLocale ==
                SupportedLocales.english
                ? "cancel"
                :'لا,أريد', yesSendPress: () {Get.to(()=>SendingMessageSchoolScreen(phoneNumber: "${selectedCountryCode?.code ?? ""}${phoneController.text}"));}, noSendPress: () { Get.back(); },);
          }
          );
        }
        }
      else{
        isLoading = false;
        update();
        if(val == 0){
        showDialog(context: context,
            builder: (context) {
              return AlertDialogue(alertTitle: errorKey.tr, alertText:signUpAlert1.tr,alertIcon: "assets/icons/warningIcon.png",containerHeight:  Get.height*0.4);
            }
        );
        }
        if(!phoneState){
          showDialog(context: context,
              builder: (context) {
            return AlertDialogue(alertTitle: errorKey.tr, alertText:signUpAlert2.tr,alertIcon: "assets/icons/warningIcon.png",containerHeight:  Get.height*0.4);
          });
        }
        if(chosenUserType ==chooseUserKey.tr){
          showDialog(context: context,
              builder: (context) {
                return AlertDialogue(alertTitle: errorKey.tr, alertText:signInAlert.tr,alertIcon: "assets/icons/warningIcon.png",containerHeight:  Get.height*0.4);
              });
        }
        if(selectedCountryCode == null){
          showDialog(context: context,
              builder: (context) {
                return AlertDialogue(alertTitle: errorKey.tr, alertText:Get.find<StorageService>().activeLocale ==
                    SupportedLocales.english
                    ?"You must select a country code.":"يجب عليك أختيار مفتاح رقم الدولة",alertIcon: "assets/icons/warningIcon.png",containerHeight:  Get.height*0.4);
              });
        }
      }
      }


  }

