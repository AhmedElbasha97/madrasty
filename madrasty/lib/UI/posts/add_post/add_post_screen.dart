// ignore_for_file: sized_box_for_whitespace

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madrasty/UI/posts/add_post/widget/image_show_widget.dart';
import 'package:madrasty/UI/posts/add_post/widget/video_show_widget.dart';

import 'package:madrasty/Utils/localization_services.dart';
import 'package:madrasty/Utils/memory.dart';
import 'package:madrasty/Widgets/DrawerWidget.dart';
import 'package:madrasty/Widgets/custom_text_widget.dart';

import 'package:madrasty/Utils/Colors_File.dart';
import 'package:madrasty/Utils/constant.dart';
import 'package:madrasty/Widgets/loading_alert_dialogue.dart';

import 'controller/add_post_controller.dart';
import 'widget/pdf_file_selector_widget.dart';

class AddPostScreen extends StatelessWidget {
  const AddPostScreen({super.key, this.schoolId, this.classId});
  final String? schoolId;
  final String? classId;

  @override
  Widget build(BuildContext context) {
    return  GetBuilder(
      init: AddPostController(schoolId??"",classId??""),
      builder: (AddPostController controller) => Scaffold(

        key: controller.scaffoldState,
        drawer: AppDrawers(
          scaffoldKey: controller.scaffoldState,
        ),
        appBar: AppBar(
          actions: [
            const SizedBox(
              width: 8,
            ),
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: Get.height * 0.07,
                  width: Get.width * 0.11,
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
                  child: const Center(
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      )),
                ),
              ),
            ),
          ],
          leading: InkWell(
            onTap: () {
              controller.scaffoldState.currentState!.openDrawer();
            },
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Image.asset(
                "assets/icons/menu_icon.png",
                fit: BoxFit.contain,
                height: MediaQuery.of(context).size.height * 0.04,
                width: MediaQuery.of(context).size.width * 0.05,
              ),
            ),
          ),
          backgroundColor: kYellowColor,
          title: Image.asset(
            "assets/images/appMultiColorLogoWithoutbackground.png",
            fit: BoxFit.fitHeight,
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.3,
          ),
          centerTitle: true,
        ),

        body: Container(
          height: Get.height,
          width: Get.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/backgroundImage.png"),
                fit: BoxFit.cover),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Container(
                height: Get.height * 0.887,
                width: Get.width ,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25)),
                  color: kLightBlueColor,
                  boxShadow: [
                    BoxShadow(
                      color: kGrayColor,
                      blurRadius: 2,
                      offset: Offset(1, 1), // Shadow position
                    ),
                  ],
                ),
                child: Center(
                  child: Form(
                    key: controller.formKey,
                    child:  SingleChildScrollView(
                      child: Container(
                        height: Get.height * 0.9,
                        child: SingleChildScrollView(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [

                                CustomText(
                                  "أضافه منشور",
                                  style: TextStyle(
                                      fontFamily:
                                      Get.find<StorageService>().activeLocale ==
                                          SupportedLocales.english
                                          ? fontFamilyEnglishName
                                          : fontFamilyArabicName,
                                      color: kBlueColor,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20),
                                ),
                                controller.video?.path == null?const SizedBox(
                                  height: 20,
                                ):const SizedBox(
                                  height: 10,
                                ),
                                controller.video?.path == null? const SizedBox():VideoShowWidget(videoPlayerController: controller.videoPlayerController, chooseAnotherVideo: () {                                                controller.showVideoSourceSelector(context);
                                }, schoolId: Get
                                    .find<StorageService>()
                                    .getUserType=="TEACHER"?"0":schoolId, classId: '',),
                                controller.video?.path == null?const SizedBox(
                                  height: 20,
                                ):
                                const SizedBox(
                                  height: 10,
                                ),
                                controller.pickedFile?.files[0].path == null?const SizedBox(
                                  height: 20,
                                ):const SizedBox(

                                ),
                                controller.pickedFile?.files[0].path == null? const SizedBox():
                                PdfFileSelectorWidget(file:File(controller.pickedFile?.files[0].path??""),chooseAnotherFile: () {controller.showFileSelector(context);}, deleteFile: () {controller.removePickedFile();},),
                                controller.pickedFile?.files[0].path == null?const SizedBox(
                                  height: 20,
                                ):
                                const SizedBox(

                                ),
                                  controller.imagesFile.isEmpty?const SizedBox(
                                  height: 20,
                                ):const SizedBox(
                                  height: 10,
                                ),
                                controller.imagesFile.isEmpty? const SizedBox():ImageShowWidget(
                                  index: controller.index,
                                  getNextImage: (){
                                    controller.getNextImages();
                                  },
                                  getPreviousImage: (){
                                    controller.getPrevImages();
                                  },
                                  chooseAnotherImage: (){
                                    controller.editingImage();
                                  },
                                  deleteImage: (){
                                    controller.deleteImage();
                                  },
                                  images: controller.imagesFile,

                                ),
                                controller.imagesFile.isEmpty?const SizedBox(
                                  height: 20,
                                ):const SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  children: [


                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(color: kDarkBlueColor,width: 1.0),
                                        color: Colors.white
                                      ),
                                      width: Get.width*0.85,
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            maxLines: 4,
                                            focusNode: controller.text1FocusNode,
                                            controller: controller.textController1,
                                            enableSuggestions: false,
                                            autocorrect: false,
                                            keyboardType: TextInputType.text,

                                            textAlign: Get.find<StorageService>()
                                                .activeLocale ==
                                                SupportedLocales.english
                                                ? TextAlign.left
                                                : TextAlign.right,

                                            style:  TextStyle(
                                              fontSize: 15.0,
                                              fontFamily: Get.find<StorageService>().activeLocale == SupportedLocales.english?fontFamilyEnglishName:fontFamilyArabicName,
                                              color: kGrayColor,
                                            ),
                                            cursorColor: kGrayColor,
                                            decoration: InputDecoration(
                                              hintText: "ما الذي يدور في ذهنك",
                                              hintStyle: TextStyle(
                                                  fontFamily:
                                                  Get.find<StorageService>().activeLocale ==
                                                      SupportedLocales.english
                                                      ? fontFamilyEnglishName
                                                      : fontFamilyArabicName,
                                                  color: kGrayColor,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 15),
                                              contentPadding: const EdgeInsets.only(right: 10,bottom: 10),
                                              counterText: '',
                                              isDense: false,
                                              fillColor: Colors.white,
                                              filled: true,
                                              border:  UnderlineInputBorder(
                                                  borderSide: const BorderSide(width: 0, color:Colors.white,),
                                                  borderRadius: BorderRadius.circular(15)
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                  borderSide: const  BorderSide(width: 0, color:Colors.white,),
                                                  borderRadius: BorderRadius.circular(15)),
                                              focusedErrorBorder: OutlineInputBorder(
                                                  borderSide: const  BorderSide(width: 0, color:Colors.white,),
                                                  borderRadius: BorderRadius.circular(15)),
                                              enabledBorder:   OutlineInputBorder(
                                                  borderSide:  const  BorderSide(width: 0, color:Colors.white,),
                                                  borderRadius: BorderRadius.circular(15)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide:   const BorderSide(width: 0, color:Colors.white,),
                                                  borderRadius: BorderRadius.circular(15)),
                                              labelStyle:TextStyle(
                                                fontSize: 15.0,
                                                fontFamily: Get.find<StorageService>().activeLocale == SupportedLocales.english?fontFamilyEnglishName:fontFamilyArabicName,
                                                color: kGrayColor,
                                              ),
                                              suffixStyle:  TextStyle(
                                                fontSize: 15.0,
                                                fontFamily: Get.find<StorageService>().activeLocale == SupportedLocales.english?fontFamilyEnglishName:fontFamilyArabicName,
                                                color: kGrayColor,
                                              ),

                                            ),

                                          ),
                                          (controller.video?.path == null)&&(controller.pickedFile?.files[0].path==null)?const SizedBox(height: 20,):const SizedBox(),
                                          (controller.video?.path == null)&&(controller.pickedFile?.files[0].path==null)? const Divider(
                                            color: kYellowColor,
                                            height: 1,
                                            thickness: 2,
                                            endIndent: 0,
                                            indent: 0,
                                          ):const SizedBox(),
                                          (controller.video?.path == null)&&(controller.pickedFile?.files[0].path==null)?const SizedBox(height: 5,):const SizedBox(),
                                          (controller.video?.path == null)&&(controller.pickedFile?.files[0].path==null)?InkWell(
                                            onTap: (){
                                              controller.getImages(context);
                                            },
                                            child: Row(
                                              children: [
                                                const SizedBox(width: 10,),
                                                const Icon(Icons.photo_camera_back_outlined,color: kBlueColor,size: 30,),
                                                const SizedBox(width: 10,),
                                                CustomText(
                                                  Get.find<StorageService>()
                                                      .activeLocale ==
                                                      SupportedLocales.english
                                                      ?"photos":"صوره",
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
                                          ):const SizedBox(),
                                          (controller.imagesFile.isEmpty)&&(controller.pickedFile?.files[0].path==null)?const SizedBox(height: 5,):const SizedBox(),
                                          (controller.imagesFile.isEmpty)&&(controller.pickedFile?.files[0].path==null)?const Divider(
                                            color: kYellowColor,
                                            height: 1,
                                            thickness: 2,
                                            endIndent: 0,
                                            indent: 0,
                                          ):const SizedBox(),
                                          (controller.imagesFile.isEmpty)&&(controller.pickedFile?.files[0].path==null)?const SizedBox(height: 5,):const SizedBox(),
                                          (controller.imagesFile.isEmpty)&&(controller.pickedFile?.files[0].path==null)?InkWell(
                                            onTap: (){

                                                controller.showVideoSourceSelector(context);

                                            },
                                            child: Row(
                                              children: [
                                                const SizedBox(width: 10,),
                                                const Icon(Icons.photo_camera_back_outlined,color: kBlueColor,size: 30,),
                                                const SizedBox(width: 10,),
                                                CustomText(
                                                  Get.find<StorageService>()
                                                      .activeLocale ==
                                                      SupportedLocales.english
                                                      ?"video":"فيديو",
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
                                          ):const SizedBox(),
                                          (controller.imagesFile.isEmpty)&&(controller.video?.path == null)?const SizedBox(height: 5,):const SizedBox(),
                                          (controller.imagesFile.isEmpty)&&(controller.video?.path == null)?const Divider(
                                            color: kYellowColor,
                                            height: 1,
                                            thickness: 2,
                                            endIndent: 0,
                                            indent: 0,
                                          ):const SizedBox(),
                                          (controller.imagesFile.isEmpty)&&(controller.video?.path == null)?const SizedBox(height: 5,):const SizedBox(),
                                          (controller.imagesFile.isEmpty)&&(controller.video?.path == null)?InkWell(
                                            onTap: (){

                                                controller.showFileSelector(context);

                                            },
                                            child: Row(
                                              children: [
                                                const SizedBox(width: 10,),
                                                const Icon(Icons.file_present,color: kBlueColor,size: 30,),
                                                const SizedBox(width: 10,),
                                                CustomText(
                                                  Get.find<StorageService>()
                                                      .activeLocale ==
                                                      SupportedLocales.english
                                                      ?"File":"ملف",
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
                                          ):const SizedBox(),
                                          const SizedBox(height: 5,),
                                          const Divider(
                                            color: kYellowColor,
                                            height: 1,
                                            thickness: 2,
                                            endIndent: 0,
                                            indent: 0,
                                          ),
                                          const SizedBox(height: 5,),
                                          InkWell(
                                            onTap: (){
                                              controller.getSharingData( context);
                                            },
                                            child: Row(
                                              children: [
                                                const SizedBox(width: 10,),
                                                const Icon(Icons.person_add_alt,color: kBlueColor,size: 30,),
                                                const SizedBox(width: 10,),
                                                CustomText(
                                                  Get.find<StorageService>()
                                                      .activeLocale ==
                                                      SupportedLocales.english
                                                      ? "Choose who the post reaches"
                                                      : "أختار الأشخاص التى يصل أليها المنشور",
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
                                          ),
                                          const SizedBox(height: 5,),

                                          (controller.chosenClass?.isEmpty??true)&&(controller.chosenPostType?.isEmpty??true)?const SizedBox():
                                          const Divider(
                                            color: kYellowColor,
                                            height: 1,
                                            thickness: 2,
                                            endIndent: 0,
                                            indent: 0,
                                          ),
                                          (controller.chosenClass?.isEmpty??true)&&(controller.chosenPostType?.isEmpty??true)?const SizedBox():
                                          const SizedBox(height: 5,),

                                          (controller.chosenClass?.isEmpty??true)&&(controller.chosenPostType?.isEmpty??true)?const SizedBox():
                                          Row(
                                            children: [
                                              const SizedBox(width: 10,),
                                              CustomText(
                                                Get.find<StorageService>()
                                                    .activeLocale ==
                                                    SupportedLocales.english
                                                    ? "the post reaches :"
                                                    : "المنشور يصل إلى :",
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
                                              SizedBox(
                                                width: Get.width*0.5,
                                                child: CustomText(
                                                  controller.returnChosenTagOfPost(),
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
                                              ),
                                            ],
                                          ),
                                          (controller.chosenClass?.isEmpty??true)&&(controller.chosenPostType?.isEmpty??true)?const SizedBox():
                                          const SizedBox(height: 5,),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                               const SizedBox(
                                  height: 20,
                                ),

                                InkWell(
                                  onTap: () {
                                    if(controller.isLoading){
                                      showDialog(context: context,
                                          builder: (context) {
                                            return const LoadingAlertDialogue();
                                          });
                                    }else{
                                      controller.addingPost(context);
                                      }

                                  },
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
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: Get.height * 0.1,
                                          width: Get.width * 0.8,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50),
                                            color: kDarkBlueColor,
                                            boxShadow: const [
                                              BoxShadow(
                                                color: kGrayColor,
                                                blurRadius: 2,
                                                offset:
                                                Offset(1, 1), // Shadow position
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: CustomText(
                                              Get.find<StorageService>()
                                                  .activeLocale ==
                                                  SupportedLocales.english
                                                  ?"add post":"أضافه منشور",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily:
                                                  Get.find<StorageService>()
                                                      .activeLocale ==
                                                      SupportedLocales.english
                                                      ? fontFamilyEnglishName
                                                      : fontFamilyArabicName,
                                                  color: kLightBlueColor,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 18),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: Get.height*0.07,)
                              ]
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
      ),
    );
  }
}