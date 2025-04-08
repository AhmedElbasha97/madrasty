// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';


import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import '../../../../Models/messages_list_model.dart';
import '../../../../Models/response_model.dart';
import '../../../../Services/chat_services.dart';
import '../../../../Utils/Colors_File.dart';
import '../../../../Utils/constant.dart';
import '../../../../Utils/localization_services.dart';
import '../../../../Utils/memory.dart';
import '../../../../Utils/translation_key.dart';
import '../../../../Widgets/alert_dialogue.dart';
import '../../../../Widgets/custom_text_widget.dart';



class ChatScreenController extends GetxController{
List<MessagesListModel>? chatList = [];
bool isLoading = true;
final String receiverId;
final String receiverType;
final TextEditingController msgController =  TextEditingController();
FilePickerResult? pickedFile;
String choosenFileIndex = "0";
Timer? timer;
bool appBarDataIsLoading = true;
bool showAttachmentBar = false;
bool choosedImageFile = false;
bool choosedVideoFile = false;
bool choosedPDFFile = false;
late String? employeeData ;
ImageSource videoSrc = ImageSource.gallery;
ImageSource imageSrc = ImageSource.gallery;
final ImagePicker _picker = ImagePicker();
final picker = ImagePicker();
final List<File> _videos = [];
XFile? video;
final List<File> imagesFile = [];
XFile? image;
late  VideoPlayerController videoPlayerSelectorController;
  ChatScreenController(this.receiverId, this.receiverType);
@override
  void onInit() {
  getData();
  getAppBarData();
    super.onInit();
    timer = Timer.periodic(const Duration(seconds: 30), (Timer t) => getData());
  }
@override
  onClose() {
  timer?.cancel();
}
//image
showImageSourceSelector(BuildContext context) async {
    bool? done = await selectPhotoSrc(context);
    if (done??true) {
      if(image?.path == null) {
        await getImages(context);
        update();
      }else{
        await editingImage(context);
        update();
      }
    }
    update();
  }
Future<bool?> selectPhotoSrc(BuildContext context) async {
    bool? done = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          title: Center(
            child:
            CustomText(
              Get.find<StorageService>()
                  .activeLocale ==
                  SupportedLocales.english
                  ?"Choose image source":"أختر مصدر الصور",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily:
                  Get.find<StorageService>()
                      .activeLocale ==
                      SupportedLocales.english
                      ? fontFamilyEnglishName
                      : fontFamilyArabicName,
                  color: kBlueColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 14),
            ),),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MaterialButton(
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.camera_alt,color: kBlueColor,),
                      CustomText(
                        Get.find<StorageService>()
                            .activeLocale ==
                            SupportedLocales.english
                            ?"camera":"الكاميرا",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily:
                            Get.find<StorageService>()
                                .activeLocale ==
                                SupportedLocales.english
                                ? fontFamilyEnglishName
                                : fontFamilyArabicName,
                            color: kBlueColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 14),
                      ),
                    ],
                  ),
                  onPressed: () {
                    imageSrc = ImageSource.camera;
                    Navigator.pop(context, true);
                  },
                ),
                MaterialButton(
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.photo,color: kBlueColor,),
                      CustomText(
                        Get.find<StorageService>()
                            .activeLocale ==
                            SupportedLocales.english
                            ?"gallery":"معرض الصور",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily:
                            Get.find<StorageService>()
                                .activeLocale ==
                                SupportedLocales.english
                                ? fontFamilyEnglishName
                                : fontFamilyArabicName,
                            color: kBlueColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 14),
                      ),
                    ],
                  ),
                  onPressed: () {
                    imageSrc = ImageSource.gallery;
                    Navigator.pop(context, true);
                  },
                )
              ],
            ),
          ],
        ));
    return done;
  }
Future<void> getImageFromUserThroughCamera() async {
  image = await _picker.pickImage(source: ImageSource.camera);
  update();
}
Future<void> getImageFromUserThroughGallery() async {
  image = await _picker.pickImage(source: ImageSource.gallery);
  update();
}
Future<void> getImages(BuildContext context)  async {
  if (imageSrc == ImageSource.camera) {
    await getImageFromUserThroughCamera();
    update();
  } else {
    await getImageFromUserThroughGallery();
    update();
  }
  if (image != null) {
    {
      choosedPDFFile = false;
      choosedVideoFile = false;
      choosedImageFile = true;
        imagesFile.add(File(image?.path??""));
      }
    }else{
    showDialog(context: context,
        builder: (context) {
          return AlertDialogue(alertTitle: errorKey.tr, alertText:Get.find<StorageService>()
              .activeLocale ==
              SupportedLocales.english
              ?"you haven't choose image":"لم يتم اختيار صوره",alertIcon: "assets/icons/warningIcon.png",containerHeight:  Get.height*0.4);
        });
  }
    update();
  }
editingImage(BuildContext context) async {
  if (imageSrc == ImageSource.camera) {
    await getImageFromUserThroughCamera();
    update();
  } else {
    await getImageFromUserThroughGallery();
    update();
  }
  if(image != null){
  if(imagesFile[0] != File(image?.path ?? "")) {
    choosedPDFFile = false;
    choosedVideoFile = false;
    choosedImageFile = true;
    imagesFile[0] = File(image?.path ?? "");
    update();
  }else{
    showDialog(context: context,
        builder: (context) {
          return AlertDialogue(alertTitle: errorKey.tr, alertText:Get.find<StorageService>()
              .activeLocale ==
              SupportedLocales.english
              ?"you haven't choose different image":"لم يتم اختيار صوره مختلفه",alertIcon: "assets/icons/warningIcon.png",containerHeight:  Get.height*0.4);
        });
  }
  }else{
  showDialog(context: context,
  builder: (context) {
  return AlertDialogue(alertTitle: errorKey.tr, alertText:Get.find<StorageService>()
      .activeLocale ==
  SupportedLocales.english
  ?"you haven't choose image":"لم يتم اختيار صوره ",alertIcon: "assets/icons/warningIcon.png",containerHeight:  Get.height*0.4);
  });
  }

  update();
}
deleteImage(){
  choosedPDFFile = false;
  choosedVideoFile = false;
  choosedImageFile = false;
  imagesFile.removeAt(0);
  update();
}
//-------------------------------------------------------------
//videos
Future<void> getVideoFromUserThroughCamera() async {
    video = await _picker.pickVideo(source: ImageSource.camera);
    update();
  }
Future<void> getVideoFromUserThroughGallery() async {
    video = await _picker.pickVideo(source: ImageSource.gallery);
    update();
  }
getVideo(BuildContext context) async {
  if (videoSrc == ImageSource.camera) {
    await getVideoFromUserThroughCamera();
    update();
  } else {
    await getVideoFromUserThroughGallery();
    update();
  }
  if (video != null) {
    if (_videos.isEmpty) {
      choosedPDFFile = false;
      choosedVideoFile = true;
      choosedImageFile = false;
      _videos.add(File(video!.path));
      videoPlayerSelectorController =
      VideoPlayerController.file(File(video!.path))
        ..initialize().then((_) {
          update();
        });

    }
  }else{
    showDialog(context: context,
        builder: (context) {
          return AlertDialogue(alertTitle: errorKey.tr, alertText:Get.find<StorageService>()
              .activeLocale ==
              SupportedLocales.english
              ?"you haven't choose video":"لم يتم اختيار فيديو",alertIcon: "assets/icons/warningIcon.png",containerHeight:  Get.height*0.4);
        });

  }
}
editVideo(BuildContext context) async {
  if (videoSrc == ImageSource.camera) {
    await getVideoFromUserThroughCamera();
    update();
  } else {
    await getVideoFromUserThroughGallery();
    update();
  }
  if (video != null) {
    if(_videos[0] != File(video!.path)) {
      choosedPDFFile = false;
      choosedVideoFile = true;
      choosedImageFile = false;
  _videos[0] = File(video!.path);

      videoPlayerSelectorController =
  VideoPlayerController.file(File(video!.path))
    ..initialize().then((_) {
      update();
    });
    }else{
      showDialog(context: context,
          builder: (context) {
            return AlertDialogue(alertTitle: errorKey.tr, alertText:Get.find<StorageService>()
                .activeLocale ==
                SupportedLocales.english
                ?"you haven't choose different video":"لم يتم اختيار فيديو مختلفه",alertIcon: "assets/icons/warningIcon.png",containerHeight:  Get.height*0.4);
          });
    }
  }else{
    showDialog(context: context,
  builder: (context) {
  return AlertDialogue(alertTitle: errorKey.tr, alertText:Get.find<StorageService>()
      .activeLocale ==
  SupportedLocales.english
  ?"you haven't choose video":"لم يتم اختيار قيديو",alertIcon: "assets/icons/warningIcon.png",containerHeight:  Get.height*0.4);
  });
}
  }
deleteVideo(){
  choosedPDFFile = false;
  choosedVideoFile = false;
  choosedImageFile = false;
  _videos.removeAt(0);
  update();
}
Future<bool?> selectVideoSrc(BuildContext context) async {
  bool? done = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        title: Center(
          child:
          CustomText(
            Get.find<StorageService>()
                .activeLocale ==
                SupportedLocales.english
                ?"Select video source":"أختر مصدر الفيديو",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily:
                Get.find<StorageService>()
                    .activeLocale ==
                    SupportedLocales.english
                    ? fontFamilyEnglishName
                    : fontFamilyArabicName,
                color: kBlueColor,
                fontWeight: FontWeight.w700,
                fontSize: 14),
          ),),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                child: Row(
                  children: <Widget>[
                    const Icon(Icons.camera_alt,color: kBlueColor,),
                    CustomText(
                      Get.find<StorageService>()
                          .activeLocale ==
                          SupportedLocales.english
                          ?"camera":"الكاميرا",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily:
                          Get.find<StorageService>()
                              .activeLocale ==
                              SupportedLocales.english
                              ? fontFamilyEnglishName
                              : fontFamilyArabicName,
                          color: kBlueColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 14),
                    ),
                  ],
                ),
                onPressed: () {
                  videoSrc = ImageSource.camera;
                  Navigator.pop(context, true);
                },
              ),
              MaterialButton(
                child: Row(
                  children: <Widget>[
                    const Icon(Icons.photo,color: kBlueColor,),
                    CustomText(
                      Get.find<StorageService>()
                          .activeLocale ==
                          SupportedLocales.english
                          ?"gallery":"معرض الصور",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily:
                          Get.find<StorageService>()
                              .activeLocale ==
                              SupportedLocales.english
                              ? fontFamilyEnglishName
                              : fontFamilyArabicName,
                          color: kBlueColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 14),
                    ),
                  ],
                ),
                onPressed: () {
                  videoSrc = ImageSource.gallery;
                  Navigator.pop(context, true);
                },
              )
            ],
          ),
        ],
      ));
  return done;
}
showVideoSourceSelector(BuildContext context) async {
  bool? done = await selectVideoSrc(context);
  if (done??true) {
    if(video?.path == null) {
      await getVideo(context);
      update();
    }else{
      await editVideo(context);
      update();
    }
  }
  update();
}
//-------------------------------------------------------------
//files
void pickFile(BuildContext context) async {
    final result = await  FilePicker.platform.pickFiles(allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc'],
    );

    if (result == null){
      showDialog(context: context,
          builder: (context) {
            return AlertDialogue(alertTitle: errorKey.tr, alertText:Get.find<StorageService>()
                .activeLocale ==
                SupportedLocales.english
                ?"you haven't choose file":"لم يتم اختيار ملف",alertIcon: "assets/icons/warningIcon.png",containerHeight:  Get.height*0.4);
          });
    }else{
      pickedFile = result;
      choosedPDFFile = true;
      choosedVideoFile = false;
      choosedImageFile = false;
      choosenFileIndex = "1";
      update();
    }


  }
void editPickedFile(BuildContext context) async {
    final result = await  FilePicker.platform.pickFiles(allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc'],
    );

    if (result == null){
      showDialog(context: context,
          builder: (context) {
            return AlertDialogue(alertTitle: errorKey.tr, alertText:Get.find<StorageService>()
                .activeLocale ==
                SupportedLocales.english
                ?"you haven't choose file":"لم يتم اختيار ملف",alertIcon: "assets/icons/warningIcon.png",containerHeight:  Get.height*0.4);
          });
    }else{
      if(pickedFile != result){
      pickedFile = result;
      choosedPDFFile = true;
      choosedVideoFile = false;
      choosedImageFile = false;
      choosenFileIndex = "1";
      update();
      }else{
        showDialog(context: context,
            builder: (context) {
              return AlertDialogue(alertTitle: errorKey.tr, alertText:Get.find<StorageService>()
                  .activeLocale ==
                  SupportedLocales.english
                  ?"you haven't choose different file ":"لم يتم اختيار ملف مختلف",alertIcon: "assets/icons/warningIcon.png",containerHeight:  Get.height*0.4);
            });
      }
    }


  }
removePickedFile(){
  choosedPDFFile = false;
  choosedVideoFile = false;
  choosedImageFile = false;
  pickedFile?.files.removeAt(0);
  update();
  }
showFileSelector(BuildContext context) async {

  if(pickedFile?.files[0].path == null) {
     pickFile(context);
        update();
      }else{
         editPickedFile(context);
        update();
      }
    }

//-------------------------------------------------------------
getAppBarData() async {
  appBarDataIsLoading = false;
  update();
}
getData() async {

   chatList = await ChatServices.getMessagesList(receiverId, receiverType);
   isLoading = false;
   update();
}
detectWhoWroteTheMessage( senderId){
  bool theUserIsSender = false;
  var employeeId =  Get.find<StorageService>().getId;
  if(
  senderId == employeeId
  ){
    theUserIsSender = true;
  }
  return theUserIsSender;
}
showingAttachmentBar(){
  showAttachmentBar = !showAttachmentBar;
  update();
}
String detectUserTypeTranslated(String userType){
  String userTypeTranslated = "";
  switch(userType){
    case "TEACHER":{
      userTypeTranslated =userType2.tr;

    }
    break;
    case "PARENT":{
      userTypeTranslated =userType1.tr;
    }
    break;
    case "STUDENT":{
      userTypeTranslated = userType3.tr;
    }
    break;
    case "DRIVER":{
      userTypeTranslated = userType5.tr;
    }
    break;
    case "SUPERVISOR":{
      userTypeTranslated = userType4.tr;
    }
    break;
  }

  return userTypeTranslated;

}
sendMessage(context) async {
   ResponseModel? status = await ChatServices.sendMessage(receiverId,receiverType,msgController.text,choosedPDFFile?File(pickedFile?.files[0].path??""):choosedVideoFile?File(_videos[0].path):choosedImageFile?File(imagesFile[0].path):null,choosedPDFFile?"FIL":choosedVideoFile?"VID":choosedImageFile?"IMG":"TXT");
  if(status?.msg=="succeeded"){
    showAttachmentBar = false;
    choosedPDFFile = false;
    choosedVideoFile = false;
    choosedImageFile = false;
  getData();
  }else{
    update();
    showDialog(context: context,
        builder: (context) {
          return AlertDialogue(alertTitle: errorKey.tr, alertText:Get.find<StorageService>()
              .activeLocale ==
              SupportedLocales.english
              ?"something went wrong try again later":"حدث خطأ ما، حاول مرة أخرى لاحقًا",alertIcon: "assets/icons/warningIcon.png",containerHeight:  Get.height*0.4);
        });
  }
}
}
