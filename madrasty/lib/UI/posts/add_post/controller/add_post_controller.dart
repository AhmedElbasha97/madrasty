// ignore_for_file: avoid_print, use_build_context_synchronously, deprecated_member_use

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:madrasty/Services/posting_services.dart';
import 'package:madrasty/Utils/Colors_File.dart';
import 'package:madrasty/Utils/constant.dart';
import 'package:madrasty/Utils/localization_services.dart';
import 'package:madrasty/Utils/memory.dart';
import 'package:madrasty/Widgets/custom_text_widget.dart';
import 'package:video_player/video_player.dart';
import '../../../../Models/response_model.dart';
import '../../../../Models/student_share_model.dart';
import '../../../../Models/teacher_info_model.dart';
import '../../../../Services/teacher_services.dart';
import '../../../../Utils/translation_key.dart';
import '../../../../Widgets/alert_dialogue.dart';
import '../../widgets/sharing_list_loading_widget.dart';



class AddPostController extends GetxController{
  TeacherInfoModel? teacherData;
  List<Class>? chosenClass = [];

  late FocusNode text1FocusNode;
  bool isLoading = false;
  late TextEditingController textController1;
  final formKey = GlobalKey<FormState>();
  ImageSource videoSrc = ImageSource.gallery;
  final ImagePicker _picker = ImagePicker();
  bool sharingListIsLoading = true;
  final picker = ImagePicker();
  final List<File> _videos = [];
  XFile? video;
  final List<File> imagesFile = [];
  List<XFile>? images;
  late  VideoPlayerController videoPlayerController;
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  int index = 0;
  FilePickerResult? pickedFile;
  List<StudentShareModel>? listPostTypes = [];
  List<StudentShareModel>? chosenPostType = [];
  final String schoolId;
  final String classId;
AddPostController(this.schoolId, this.classId);
  @override
  void onInit() {
    super.onInit();
    textController1 = TextEditingController();
    text1FocusNode = FocusNode();
  }
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
      print(pickedFile?.count??0);

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
        print(pickedFile?.count??0);

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
  String returnChosenTagOfPost(){
   String theChosenOfPeople = "";
   if(Get.find<StorageService>().getUserType == "TEACHER") {
     for (int i = 0; i < (chosenClass?.length ?? 0); i++) {
       theChosenOfPeople = "$theChosenOfPeople ${ Get
           .find<StorageService>()
           .activeLocale ==
           SupportedLocales.english
           ? (chosenClass?[i].nameEn ?? "") : (chosenClass?[i].name ?? "")}";
       if ((i + 1) < (chosenClass?.length ?? 0)) {
         theChosenOfPeople = "$theChosenOfPeople , ";
       }
     }
   }else{
     for (int i = 0; i < (chosenPostType?.length ?? 0); i++) {
       theChosenOfPeople = "$theChosenOfPeople ${ (chosenPostType?[i].name ?? "")}";
       if ((i + 1) < (chosenPostType?.length ?? 0)) {
         theChosenOfPeople = "$theChosenOfPeople , ";
       }
     }
   }
   return theChosenOfPeople;
}

  addTagToChosenClass(var choosedTag){
    if(Get.find<StorageService>().getUserType == "TEACHER") {
      chosenClass?.add(choosedTag!);
      print("added${chosenClass?.contains(choosedTag)}${choosedTag?.id ?? 0}");
      update();
    }else{
      chosenPostType?.add(choosedTag!);
      print("added${chosenPostType?.contains(choosedTag)}${choosedTag?.id ?? 0}");
      update();
    }
  }

  removeTagFromChosenClass(var choosedTag){
    if(Get.find<StorageService>().getUserType == "TEACHER") {
      chosenClass?.remove(choosedTag!);
      print(
          "removed${chosenClass?.contains(choosedTag)}${choosedTag?.id ?? 0}");
      update();
    }else{
      chosenPostType?.remove(choosedTag!);
      print(
          "removed${chosenClass?.contains(choosedTag)}${choosedTag?.id ?? 0}");
      update();
    }
  }

  bool checkIfTagAddedOrNot(var choosedTag){
    if(Get.find<StorageService>().getUserType == "TEACHER") {
      return chosenClass?.contains(choosedTag) ?? false;
    }else{
      return chosenPostType?.contains(choosedTag) ?? false;

    }
  }
  sharingPost(BuildContext context){

    showModalBottomSheet(
      backgroundColor: kLightBlueColor,
      context:context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer, builder: (BuildContext context) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState ) {
            return SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      sharingListIsLoading? const SharingListLoadingWidget():
                      Get.find<StorageService>().getUserType == "TEACHER"?Column(
                        children: teacherData!.teacherInfoModelClass!.map<Widget>((e){
                          return InkWell(
                            onTap: (){
                              if(checkIfTagAddedOrNot(e)){

                                setState(() {
                                  removeTagFromChosenClass(e);
                                });
                              }else{

                                setState(() {
                                  addTagToChosenClass(e);
                                });
                              }
                            },
                            child: SizedBox(
                              width: Get.width,

                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [

                                          const SizedBox(
                                            width: 20,
                                          ),

                                          CustomText(
                                            Get.find<
                                                StorageService>()
                                                .activeLocale ==
                                                SupportedLocales
                                                    .english
                                                ?e.nameEn??"":e.name??"",
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
                                      Row(children: [
                                        Image.asset(
                                          checkIfTagAddedOrNot(e)?"assets/icons/wrongIcon.png":"assets/icons/unCheckedIcon.png",
                                          fit: BoxFit.contain,
                                          height: MediaQuery.of(context).size.height * 0.04,
                                          width: MediaQuery.of(context).size.width * 0.05,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                      ],)
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  e == teacherData!.teacherInfoModelClass!.last
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
                      ):
                      Column(
                        children: listPostTypes!.map<Widget>((e){
                          return InkWell(
                            onTap: (){
                              if(checkIfTagAddedOrNot(e)){

                                setState(() {
                                  removeTagFromChosenClass(e);
                                });
                              }else{

                                setState(() {
                                  addTagToChosenClass(e);
                                });
                              }
                            },
                            child: SizedBox(
                              width: Get.width,

                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [

                                          const SizedBox(
                                            width: 20,
                                          ),

                                          CustomText(
                                            e.name??"",
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
                                      Row(children: [
                                        Image.asset(
                                          checkIfTagAddedOrNot(e)?"assets/icons/wrongIcon.png":"assets/icons/unCheckedIcon.png",
                                          fit: BoxFit.contain,
                                          height: MediaQuery.of(context).size.height * 0.04,
                                          width: MediaQuery.of(context).size.width * 0.05,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                      ],)
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  e == listPostTypes?.last
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
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);

                        },
                        child: Center(
                          child: Container(
                            height: Get.height * 0.1,
                            width: Get.width * 0.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              image: const DecorationImage(
                                  image: AssetImage(
                                      "assets/images/backgroundImage.png"),
                                  fit: BoxFit.cover),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                constraints: BoxConstraints(
                                  minHeight: Get.height * 0.06,
                                ),
                                width: Get.width * 0.8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: kDarkBlueColor,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: kGrayColor,
                                      blurRadius: 2,
                                      offset: Offset(1, 1), // Shadow position
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                                    child: SizedBox(
                                      width: Get.width * 0.6,
                                      child: CustomText(
                                        textAlign: TextAlign.center,
                                        maxLines: 3,
                                        Get.find<StorageService>()
                                            .activeLocale ==
                                            SupportedLocales.english
                                            ?"Chosen":"تم الأختيار",
                                        style: TextStyle(
                                          shadows: <Shadow>[
                                            Shadow(
                                                offset:
                                                const Offset(0.5, 0.5),
                                                blurRadius: 0.5,
                                                color: Colors.black
                                                    .withOpacity(0.5)),
                                          ],
                                          fontSize: 13,
                                          letterSpacing: 0,
                                          fontFamily:
                                          Get.find<StorageService>()
                                              .activeLocale ==
                                              SupportedLocales.english
                                              ? fontFamilyEnglishName
                                              : fontFamilyArabicName,
                                          color: kWhiteColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
              ),
            );
          }
      );
    },
    );
  }


  getSharingData(BuildContext context) async {
    if(Get.find<StorageService>().getUserType == "TEACHER"){
      if(teacherData.isNull) {
        teacherData = await TeacherServices.getTeacherInfoData();
        sharingListIsLoading = false;
        update();
      }
      sharingPost(context);
    }else{
      if(listPostTypes?.isEmpty??false) {
        listPostTypes = await PostingServices.getSubjectsList(schoolId);
        sharingListIsLoading = false;
        update();
      }
      sharingPost(context);

    }

  }


  getPrevImages(){
    if(index > 0 ){
      index = index-1;
     update();
    }else{
      index = imagesFile.length-1;
      update();

    }
  }
  getNextImages(){
    if(index < (imagesFile.length-1) ){
      index = index+1;
      update();
    }else{
      index = 0;
      update();

    }
  }

  Future<void> getImages(BuildContext context)  async {
    images = await _picker.pickMultiImage();
    update();
    if (images != null) {
      if(images!.length >= 14) {
        final snackBar = SnackBar(content:
        Row(children: [
          const Icon(Icons.close, color: Colors.white,),
          const SizedBox(width: 10,),
          Text(Get
              .find<StorageService>()
              .activeLocale ==
              SupportedLocales.english
              ? 'An error occurred while sending the message'
              : 'لا يمكن أختيار أكثر من 15 صوره', style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),
          ),
        ],),
            backgroundColor: Colors.red
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }else{
        for (XFile image in images!
        ) {
          imagesFile.add(File(image.path));
        }
      }
    update();
    }
  }

  editingImage() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    imagesFile[index] = File(image?.path??"");
    update();
  }

  deleteImage(){
    imagesFile.removeAt(index);
    update();
  }

  Future<void> getVideoFromUserThroughCamera() async {
    video = await _picker.pickVideo(source: ImageSource.camera);
    update();
  }

  //get image from user through gallery
  Future<void> getVideoFromUserThroughGallery() async {
    video = await _picker.pickVideo(source: ImageSource.gallery);
    update();
  }

  getVideo(int index, ImageSource src) async {
    if (videoSrc == ImageSource.camera) {
      await getVideoFromUserThroughCamera();
      update();
    } else {
      await getVideoFromUserThroughGallery();
      update();
    }
    if (video != null) {
      if (_videos.isEmpty) {
        print('in add');
        _videos.add(File(video!.path));
        print(video!.path);
        videoPlayerController =
        VideoPlayerController.file(File(video!.path))
          ..initialize().then((_) {
            update();
          });

      }
    }
  }

  editVideo(int index, ImageSource src) async {
    if (videoSrc == ImageSource.camera) {
      await getVideoFromUserThroughCamera();
      update();
    } else {
      await getVideoFromUserThroughGallery();
      update();
    }
    if (video != null) {

        print('in insert');
        _videos[index] = File(video!.path);
        print(video!.path);

        videoPlayerController =
        VideoPlayerController.file(File(video!.path))
          ..initialize().then((_) {
            update();
          });

    }
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
                "أختر مصدر الفيديو",
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
                        "الكاميرا",
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
                        "معرض الصور",
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
    print("$done hdsfibghdisubgfiudsuibfi");
    if (done??true) {
      if(video?.path == null) {
        await getVideo(0, videoSrc);
        update();
      }else{
        await editVideo(0,videoSrc);
        update();
      }
    }
   update();
  }

  addingPost(BuildContext context) async {
    List<String> chosenClassId =[];
    List<String> chosenSubjectId =[];
    if(Get.find<StorageService>().getUserType == "TEACHER"){
      for (int i = 0; i < (chosenClass?.length ?? 0); i++) {
        chosenClassId.add("${chosenClass?[i].id ?? 0}");
      }
    }else{
      for (int i = 0; i < (chosenPostType?.length ?? 0); i++) {
        chosenSubjectId.add("${chosenPostType?[i].id ?? 0}");
      }
    }
    isLoading = true;
    update();
    ResponseModel? data = await PostingServices.addPost(
        Get.find<StorageService>().getUserType == "TEACHER"?"${teacherData?.school??0}":schoolId,
        textController1.text ,
        Get.find<StorageService>().getUserType == "TEACHER"?chosenClassId:[classId],
        Get.find<StorageService>().getUserType == "TEACHER"?[classId]:chosenSubjectId,
        _videos.isNotEmpty?_videos:
        imagesFile.isNotEmpty?imagesFile:
        (pickedFile?.files.isNotEmpty??false)?([File(pickedFile?.files[0].path??"")]):[],_videos.isNotEmpty?"VID":
    imagesFile.isNotEmpty?"IMG":
    (pickedFile?.files.isNotEmpty??false)?"FIL":"TXT");
    print(data?.msg);
    if (data?.msg == "succeeded") {
      final snackBar = SnackBar(content:
      Row(children: [
        const Icon(Icons.check, color: Colors.white,),
        const SizedBox(width: 10,),
        Text(Get
            .find<StorageService>()
            .activeLocale ==
            SupportedLocales.english
            ? 'The recommendation has been sent'
            : 'تم أضافه المنشور ', style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
        ),
        ),
      ],),
          backgroundColor: Colors.green
      );
      isLoading = false;
      update();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pop(context);
    }
    else {
      isLoading = false;
      update();
      final snackBar = SnackBar(content:
      Row(children: [
        const Icon(Icons.close, color: Colors.white,),
        const SizedBox(width: 10,),
        Text(Get
            .find<StorageService>()
            .activeLocale ==
            SupportedLocales.english
            ? 'An error occurred while Adding the Post'
            : 'حدث خطاء أثناء أضافه المنشور', style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
        ),
        ),
      ],),
          backgroundColor: Colors.red
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

}
