

// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:madrasty/Services/chat_services.dart';
import 'package:madrasty/Utils/Colors_File.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../Models/messages_list_model.dart';
import '../../../../Models/post_status_model.dart';
import '../../../../Utils/constant.dart';
import '../../../../Utils/localization_services.dart';
import '../../../../Utils/memory.dart';
import '../../../../Utils/services.dart';
import '../../../../Widgets/custom_text_widget.dart';
import '../../../../Widgets/file_icons_widget.dart';
import '../../../../Widgets/loader.dart';
import '../../../../Widgets/yes_or_no_alert_dialogue.dart';
import '../../../pdfViewer/pdf_viewer.dart';
import '../../../posts/widgets/photoDetails_screen.dart';
import 'package:http/http.dart' as http;
class PdfChattingCell extends StatefulWidget {

  const PdfChattingCell({super.key, required this.sender, this.message});
  final bool sender;
  final MessagesListModel? message;
  @override
  State<PdfChattingCell> createState() => _PdfChattingCellState();
}

class _PdfChattingCellState extends State<PdfChattingCell> {
  late SampleItem? selectedItem = SampleItem.itemOne;
  late PostStatusModel? checker;
   bool isLoadingPDFFile = true;
  String fileSize = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkFileAvailablity();

  }

  callPhone() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: widget.message?.text??"",
    );
    await launchUrl(launchUri);
  }

  chatThroughtWhatsApp() async {
    var androidUrl = "whatsapp://send?phone=${  widget.message?.text??""}&text=${'hi \n أهلا'}";
    var iosUrl = "https://wa.me/${  widget.message?.text??""}?text=${Uri.parse('hi \n أهلا')}";
    try{
      if(Platform.isIOS){
        await launchUrl(Uri.parse(iosUrl));
      }
      else{
        await launchUrl(Uri.parse(androidUrl));
      }
    }  catch (e, stackTrace) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: e,
        stack: stackTrace,
      ));
    }

  }

  showingActionForPhoneNumber(BuildContext context){
    showDialog(context: context,
        builder: (context) {
          return YesOrNoAlertDialogue(alertTitle: Get.find<StorageService>().activeLocale ==
              SupportedLocales.english
              ? "Alert"
              :"تنبيه", alertText: Get.find<StorageService>().activeLocale ==
              SupportedLocales.english
              ? "choose what you want to do"
              :"أختر ما تريد فعله",alertIcon: "assets/icons/warningIcon.png",containerHeight:  Get.height*0.4, yesAlertText: Get.find<StorageService>().activeLocale ==
              SupportedLocales.english
              ? "call throught phone"
              :'اتصل عبر الهاتف', noAlertText: "what's app", yesSendPress: () {callPhone();}, noSendPress: () { chatThroughtWhatsApp(); },);
    }
    );
  }

  String returnDateAndTime(String? date){
    String dateOrTime = "" ;
    final format = DateFormat('HH:mm a');
    DateFormat formatDate = DateFormat("MMM dd");
    final dateTime = DateTime.parse(date??"");
    if(dateTime.day == DateTime.now().day){
      dateOrTime = format.format(dateTime);
    }else{
      dateOrTime = formatDate.format(dateTime);
    }
    return dateOrTime;
  }



  detectPhoneNumber(String message) {
    RegExp phoneRegex = RegExp(r'^(?:[+0]9)?[0-9]{10}$');

    if (phoneRegex.hasMatch(message)) {

      return true;
    }

    return false;
  }

  copyTextToClipBoard(BuildContext context) async {
    await Clipboard.setData( ClipboardData(text:  widget.message?.text??""));
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check,color: Colors.white,
                size: 20,),
              SizedBox(width: 20,),
              Text(
                "تم نسخ الرساله بنجاح",
                style:  TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          backgroundColor:Colors.green,
        ));
  }

  getFileName(String filePath){
    return filePath.split('/').last;
  }
  Future<bool> requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }
  checkFileAvailablity() async {
    checker = await ChatServices.getFileStatus(getFileName(widget.message?.file??""));
   if((checker?.status??0) == 1){
     getFileDetails();
   }
   isLoadingPDFFile = false;
   setState(() {});
  }
  Future<bool> hasAcceptedPermissions() async {
    if (Platform.isAndroid) {
      if (await requestPermission(Permission.storage) &&
          // access media location needed for android 10/Q
          await requestPermission(Permission.accessMediaLocation) &&
          // manage external storage needed for android 11/R
          await requestPermission(Permission.manageExternalStorage)) {
        return true;
      } else {
        return false;
      }
    }
    if (Platform.isIOS) {
      if (await requestPermission(Permission.photos)) {
        return true;
      } else {
        return false;
      }
    } else {
      // not android or ios
      return false;
    }
  }

  Future<bool> saveFile() async {
    hasAcceptedPermissions();
    try {
      if (await requestPermission(Permission.storage)) {
        Directory? directory;
        directory = Platform.isAndroid
            ? await getExternalStorageDirectory() //FOR ANDROID
            : await getApplicationSupportDirectory(); //FOR iOS
        String newPath = "";
        List<String> paths = directory!.path.split("/");
        for (int x = 1; x < paths.length; x++) {
          String folder = paths[x];
          if (folder != "Android") {
            newPath += "/$folder";
          } else {
            break;
          }
        }
        newPath = "$newPath/madrasty_App";
        directory = Directory(newPath);

        File saveFile = File("${directory.path}/${getFileName(widget.message?.file??"")}");
        if (kDebugMode) {
          print(saveFile.path);
        }
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
        if (await directory.exists()) {
          await Dio().download(
            "${Services.baseUrl}${widget.message?.file??""}",
            saveFile.path,
          );
        }
        final snackBar = SnackBar(
          backgroundColor:Colors.green,

          content: SizedBox(
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.file_copy, color: Colors.white,),
                ),
                Row(
                  children: [
                    CustomText(Get.find<StorageService>()
                        .activeLocale ==
                        SupportedLocales.english
                        ?'file name:':'اسم الملف:'),
                    CustomText(widget.message?.file??"" ,),
                  ],
                ),
                CustomText(Get.find<StorageService>()
                    .activeLocale ==
                    SupportedLocales.english
                    ?"It was uploaded to a file whose path is:":"تم تحميله في ملف مساره هو:",
                ),

                CustomText(newPath,),

              ],
            ),
          ),

        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  linkSize(String url) async{

    try{
      String? fileSize = "";
      http.Response response = await http.get(Uri.parse(url));
      fileSize = response.headers["content-length"];
      double bytes = double.parse(fileSize!);
      if (bytes <= 0) {
        fileSize = "0 B";
      }
      const suffixes = ["B", "KB", "MG", "GB", "TB", "PB", "EB", "ZB", "YB"];
      (log(bytes) / log(1024)).floor();
      fileSize =  '${(bytes / pow(1024, 1)).toStringAsFixed(0)} ${suffixes[1]}';
      return fileSize;
    } catch (e, stackTrace) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: e,
        stack: stackTrace,
      ));
    }

  }

  getFileDetails() async {
    fileSize = await linkSize("${Services.baseUrl}${widget.message?.file??""}");
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment:
                widget.sender? MainAxisAlignment.end : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [

                  InkWell(
                    onLongPress: (){
                      if(widget.message?.text?.isNotEmpty??false) {
                        copyTextToClipBoard(context);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width*0.6),

                      decoration: BoxDecoration(
                          color: widget.sender? kBlueColor:kYellowColor ,
                          borderRadius: BorderRadius.only(
                            bottomRight:  Radius.circular(widget.sender? 12 : 0),
                            bottomLeft:  const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            topLeft: Radius.circular(widget.sender ? 0 : 12),
                          )),
                      child: Column(
                        children: [
                          isLoadingPDFFile?Loader( height: Get.height*0.3,
                            width: Get.width*0.7,):(checker?.status??0) ==0?
                          Container(
                            width: Get.width*0.6,
                            height: Get.height*0.13,
                            decoration: BoxDecoration(
                                color: kLightBlueColor,
                                borderRadius: BorderRadius.circular(10)

                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.warning_amber_rounded,color: kDarkBlueColor,size: 50),
                                  const SizedBox(height: 10,),
                                  CustomText(
                                      Get.find<StorageService>().activeLocale ==
                                          SupportedLocales.english
                                          ? "this file was deleted"
                                          :"تم حذف هذا الملف",
                                      style:  TextStyle(
                                        fontFamily:  Get.find<StorageService>().activeLocale ==
                                            SupportedLocales.english
                                            ? fontFamilyEnglishName
                                            : fontFamilyArabicName,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                        color: kDarkBlueColor,
                                      )
                                  ),

                                ],
                              ),
                            ),
                          ):
                          Container(
                            width: Get.width*0.6,
                            height: Get.height*0.13,
                            decoration: BoxDecoration(
                                color: kLightBlueColor,
                                borderRadius: BorderRadius.circular(20)

                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          CustomText(
                                              getFileName(widget.message?.file??""),
                                              style:  TextStyle(
                                                fontFamily:  Get.find<StorageService>().activeLocale ==
                                                    SupportedLocales.english
                                                    ? fontFamilyEnglishName
                                                    : fontFamilyArabicName,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 12,
                                                color: kDarkBlueColor,
                                              )
                                          ),
                                          const SizedBox(height: 10,),

                                        ],
                                      ),
                                      const SizedBox(width: 10,),
                                      FileIconWidget(fileName:getFileName(widget.message?.file??""),)


                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                        onTap: (){
                                          Get.to(()=>const PdfViewer(),arguments: ["${Services.baseUrl}${widget.message?.file??""}",getFileName(widget.message?.file??"")]);

                                        },
                                        child: Container(
                                          height:Get.height * 0.03,
                                          width: Get.width*0.2,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: kBlackColor,width: 1,),
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(1.0),
                                              child: CustomText(
                                                textAlign: TextAlign.center,
                                                maxLines: 3,
                                                Get.find<StorageService>()
                                                    .activeLocale ==
                                                    SupportedLocales.english
                                                    ?"open File":"فتح الملف",
                                                style: TextStyle(
                                                  shadows: <Shadow>[
                                                    Shadow(
                                                        offset:
                                                        const Offset(0.5, 0.5),
                                                        blurRadius: 0.5,
                                                        color: Colors.black
                                                            .withValues(alpha:0.5)),
                                                  ],
                                                  fontSize: 10,
                                                  letterSpacing: 0,
                                                  fontFamily:
                                                  Get.find<StorageService>()
                                                      .activeLocale ==
                                                      SupportedLocales.english
                                                      ? fontFamilyEnglishName
                                                      : fontFamilyArabicName,
                                                  color: kBlackColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: (){
                                          saveFile();
                                        },
                                        child: Container(
                                          height:Get.height * 0.03,
                                          width: Get.width*0.2,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: kBlackColor,width: 1,),
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(1.0),
                                              child: CustomText(
                                                textAlign: TextAlign.center,
                                                maxLines: 3,
                                                Get.find<StorageService>()
                                                    .activeLocale ==
                                                    SupportedLocales.english
                                                    ?"download File":"تحميل الملف",
                                                style: TextStyle(
                                                  shadows: <Shadow>[
                                                    Shadow(
                                                        offset:
                                                        const Offset(0.5, 0.5),
                                                        blurRadius: 0.5,
                                                        color: Colors.black
                                                            .withValues(alpha:0.5)),
                                                  ],
                                                  fontSize: 10,
                                                  letterSpacing: 0,
                                                  fontFamily:
                                                  Get.find<StorageService>()
                                                      .activeLocale ==
                                                      SupportedLocales.english
                                                      ? fontFamilyEnglishName
                                                      : fontFamilyArabicName,
                                                  color: kBlackColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          detectPhoneNumber(widget.message?.text??"")?InkWell(
                            onTap: (){
                              showingActionForPhoneNumber(context);
                            },
                            child: CustomText(
                                widget.message?.text??"",
                                style: widget.sender? TextStyle(
                                  fontFamily:  Get.find<StorageService>().activeLocale ==
                                      SupportedLocales.english
                                      ? fontFamilyEnglishName
                                      : fontFamilyArabicName,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: Colors.white,
                                ): TextStyle(
                                  fontFamily:  Get.find<StorageService>().activeLocale ==
                                      SupportedLocales.english
                                      ? fontFamilyEnglishName
                                      : fontFamilyArabicName,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: kDarkBlueColor,
                                )
                            ),
                          ):
                          Linkify(
                            text:
                            widget.message?.text??"",
                            onOpen: (link) async {
                              if (!await launchUrl(Uri.parse(link.url))) {
                                throw Exception('Could not launch ${link.url}');
                              }
                            },
                            linkStyle: widget.sender? TextStyle(
                              fontFamily:  Get.find<StorageService>().activeLocale ==
                                  SupportedLocales.english
                                  ? fontFamilyEnglishName
                                  : fontFamilyArabicName,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: Colors.white,
                            ): TextStyle(
                              fontFamily:  Get.find<StorageService>().activeLocale ==
                                  SupportedLocales.english
                                  ? fontFamilyEnglishName
                                  : fontFamilyArabicName,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: kDarkBlueColor,
                            ),
                            style: widget.sender? TextStyle(
                              fontFamily:  Get.find<StorageService>().activeLocale ==
                                  SupportedLocales.english
                                  ? fontFamilyEnglishName
                                  : fontFamilyArabicName,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: Colors.white,
                            ): TextStyle(
                              fontFamily:  Get.find<StorageService>().activeLocale ==
                                  SupportedLocales.english
                                  ? fontFamilyEnglishName
                                  : fontFamilyArabicName,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: kDarkBlueColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Row(
              mainAxisAlignment:
              widget.sender? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                CustomText(
                  returnDateAndTime(widget.message?.date??""),
                  style: TextStyle(
                    fontFamily:  Get.find<StorageService>().activeLocale ==
                        SupportedLocales.english
                        ? fontFamilyEnglishName
                        : fontFamilyArabicName,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.black26,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}


