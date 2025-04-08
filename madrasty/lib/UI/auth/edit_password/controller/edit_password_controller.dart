// ignore_for_file: use_build_context_synchronously, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madrasty/Models/response_model.dart';
import 'package:madrasty/Services/auth_services.dart';
import 'package:madrasty/UI/welcome_screen/welcome_screen.dart';

import '../../../../Utils/localization_services.dart';
import '../../../../Utils/memory.dart';
import '../../../../Utils/translation_key.dart';
import '../../../../Utils/validator.dart';
import '../../../../Widgets/alert_dialogue.dart';

class EditPasswordController extends GetxController{
  final bool comingFromForgetPassword;
  final _validatorHelber = ValidatorHelper.instance;
  bool isLoading = false;
  RxBool _visiblePsd = false.obs;
  RxBool _isEnableLogin = false.obs;

EditPasswordController(this.comingFromForgetPassword);
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

  final formKey1 = GlobalKey<FormState>();
  late TextEditingController phoneController;

  late TextEditingController passwordController;
  late TextEditingController reTypePasswordController;
  bool passValidated = false;

  bool reTypePasswordValidated = false;
  bool formValidated = false;
  bool passState = false;
  bool reTypePasswordState = false;

  bool phoneState = true;
  bool signingUp = false;

  @override
  void onInit() {
    super.onInit();
    passwordController = TextEditingController();
    reTypePasswordController = TextEditingController();

  }

  @override
  void onClose() {
    passwordController.dispose();
    reTypePasswordController.dispose();

    super.onClose();
  }

  void clear() {
    passwordController.clear();
    reTypePasswordController.clear();

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

  Future<void> sendPressed1(context) async {
    formValidated = formKey1.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (formValidated) {
      editingPassword(context);
    }
  }


// late String _optCode;
  Future errorDialog(String err) async {
    return Get.defaultDialog(
        title: "error /n tryAgain.tr ",
        titlePadding: const EdgeInsets.symmetric(vertical: 10),
        middleText: err);
  }
  editingPassword(
      BuildContext context)
  async {
    isLoading = true;
    update();
    ResponseModel? data = await AuthServices.editPassword(passwordController.text);
    if(passState&&reTypePasswordState){
      if(data?.status == "true"){
        isLoading = false;
        final snackBar = SnackBar(content:
        Row(children: [
          const Icon(Icons.check, color: Colors.white,),
          const SizedBox(width: 10,),
          Text(Get
              .find<StorageService>()
              .activeLocale ==
              SupportedLocales.english
              ? 'Password has been modified successfully'
              : 'تم تعديل كلمه السر بنجاح ', style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),
          ),
        ],),
            backgroundColor: Colors.green
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        if(comingFromForgetPassword){
          Get.to(()=>const WelcomeScreen());
        }else{
        Navigator.pop(context);}
      }else{
        isLoading = false;
        update();

        showDialog(context: context,
            builder: (context) {
              return AlertDialogue(alertTitle: errorKey.tr, alertText: data?.msg??"",alertIcon: "assets/icons/warningIcon.png",containerHeight:  Get.height*0.4);
            }
        );}

    }
  }



}