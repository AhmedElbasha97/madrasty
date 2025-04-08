// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:madrasty/UI/chat/message_list/widget/video_chat_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../../../../Models/messages_list_model.dart';
import '../../../../Models/post_status_model.dart';
import '../../../../Services/chat_services.dart';
import '../../../../Utils/Colors_File.dart';
import '../../../../Utils/constant.dart';
import '../../../../Utils/localization_services.dart';
import '../../../../Utils/memory.dart';
import '../../../../Utils/services.dart';
import '../../../../Widgets/custom_text_widget.dart';
import '../../../../Widgets/loader.dart';
import '../../../../Widgets/yes_or_no_alert_dialogue.dart';

class VideoChattingCell extends StatefulWidget {
    const VideoChattingCell({super.key, required this.sender, this.message});
  final bool sender;
  final MessagesListModel? message;


  @override
  State<VideoChattingCell> createState() => _VideoChattingCellState();
}

class _VideoChattingCellState extends State<VideoChattingCell> {
   late  VideoPlayerController videoPlayerController;
   late PostStatusModel? checker;
   bool isLoadingVideo = false;
   callPhone() async {
     final Uri launchUri = Uri(
       scheme: 'tel',
       path: widget.message?.text??"",
     );
     await launchUrl(launchUri);
   }

   chatThroughtWhatsApp() async {
     var androidUrl = "whatsapp://send?phone=${ widget.message?.text??""}&text=${'hi \n أهلا'}";
     var iosUrl = "https://wa.me/${ widget.message?.text??""}?text=${Uri.parse('hi \n أهلا')}";
     try{
       if(Platform.isIOS){
         await launchUrl(Uri.parse(iosUrl));
       }
       else{
         await launchUrl(Uri.parse(androidUrl));
       }
     } catch (e, stackTrace) {
       FlutterError.reportError(FlutterErrorDetails(
         exception: e,
         stack: stackTrace,
       ));
     }

   }

   getFileName(String filePath){
     return filePath.split('/').last;
   }
   checkFileAvailablity() async {
     checker = await ChatServices.getFileStatus(getFileName(widget.message?.file??""));
     if((checker?.status??0) == 1){
       videoPlayerController =
           VideoPlayerController.networkUrl(Uri.parse("${Services.baseUrl}${widget.message?.file??""}"))
         ..initialize().then((_) {
           setState(() {

           });
         });
     }
     isLoadingVideo =false;
     setState(() {

     });

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
               :'اتصل عبر الهاتف', noAlertText: "what's app", yesSendPress: () {callPhone();}, noSendPress: () { chatThroughtWhatsApp(); },);         }
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
     await Clipboard.setData( ClipboardData(text: widget.message?.text??""));
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
   @override
   void initState() {
     super.initState();
     checkFileAvailablity();

   }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
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
                      maxWidth: MediaQuery.of(context).size.width*0.85),

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
                      isLoadingVideo?Loader( height: Get.height*0.3,
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
                                      ? "this Video was deleted"
                                      :"تم حذف هذا الفيديو",
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
                      ):VideoChatWidget(videoPlayerController: videoPlayerController,videoPlayer:"${Services.baseUrl}${widget.message?.file??""}",),
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