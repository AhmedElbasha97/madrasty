import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madrasty/Services/posting_services.dart';
import '../../../../Models/messages_list_model.dart';
import '../../../../Models/post_model.dart';
import '../../../../Models/post_status_model.dart';
import '../../../../Utils/Colors_File.dart';
import '../../../../Utils/constant.dart';
import '../../../../Utils/localization_services.dart';
import '../../../../Utils/memory.dart';
import '../../../../Utils/translation_key.dart';
import '../../../../Widgets/custom_text_widget.dart';
import '../../../../Widgets/loader.dart';
import '../../../posts/widgets/read_more_widget.dart';
import 'package:intl/intl.dart';

import 'post_screen_chat.dart';

class PostWidgetChatScreen extends StatefulWidget {
  const PostWidgetChatScreen({super.key, required this.sender, this.message, });
  final bool sender;
  final MessagesListModel? message;
  @override
  State<PostWidgetChatScreen> createState() => _PostWidgetChatScreenState();
}

class _PostWidgetChatScreenState extends State<PostWidgetChatScreen> {
 late PostStatusModel? checker;
  late Post? postData;
 bool isLoadingPost = true;
  @override
  void initState() {
    checkPostAvailablity();
    super.initState();
  }
  checkPostAvailablity() async {
     checker = await PostingServices.checkPostAvailability(widget.message?.text??"");
    if((checker?.status??0) == 1) {
      getPostData();
    }else{
      isLoadingPost = false;
      setState(() {

      });
    }
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

 getPostData() async {
    postData = await PostingServices.getPost(widget.message?.text??"");
    isLoadingPost = false;
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
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: isLoadingPost?Loader( height: Get.height*0.3,
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
                                        ? "this post was deleted"
                                        :"تم حذف هذا المنشور",
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
                        )
                            :Column(
                          children: [
                            //header of the post
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(width: 5,),
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        height: Get.height * 0.13,
                                        width: Get.width * 0.13,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/backgroundImage.png"),
                                              fit: BoxFit.cover),
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Container(
                                              height: Get.height * 0.11,
                                              width: Get.width * 0.11,
                                              decoration:  const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: kDarkBlueColor,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: kGrayColor,
                                                    blurRadius: 2,
                                                    offset:
                                                    Offset(1, 1), // Shadow position
                                                  ),
                                                ],
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        "assets/images/27002.jpg"),
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          textAlign: TextAlign.center,
                                          maxLines: 3,
                                          postData?.user?.name??"",
                                          style: TextStyle(
                                            shadows: <Shadow>[
                                              Shadow(
                                                  offset:  const Offset(0.5, 0.5),
                                                  blurRadius: 0.5,
                                                  color: Colors.black
                                                      .withValues(alpha:0.5)),
                                            ],
                                            fontSize: 12,
                                            letterSpacing: 0,
                                            fontFamily: Get.find<StorageService>()
                                                .activeLocale ==
                                                SupportedLocales.english
                                                ? fontFamilyEnglishName
                                                : fontFamilyArabicName,
                                            color: kDarkBlueColor,
                                          ),
                                        ),
                                        CustomText(
                                          textAlign: TextAlign.center,
                                          maxLines: 3,
                                          detectUserTypeTranslated(postData?.user?.type??""),
                                          style: TextStyle(
                                            shadows: <Shadow>[
                                              Shadow(
                                                  offset:  const Offset(0.5, 0.5),
                                                  blurRadius: 0.5,
                                                  color: Colors.black
                                                      .withValues(alpha:0.5)),
                                            ],
                                            fontSize: 12,
                                            letterSpacing: 0,
                                            fontFamily: Get.find<StorageService>()
                                                .activeLocale ==
                                                SupportedLocales.english
                                                ? fontFamilyEnglishName
                                                : fontFamilyArabicName,
                                            color: kBlueColor,
                                          ),
                                        ),
                                        const SizedBox(width: 5,),
                                        CustomText(
                                          textAlign: TextAlign.center,
                                          maxLines: 3,
                                          returnDateAndTime(postData?.date??""),
                                          style: TextStyle(
                                            shadows: <Shadow>[
                                              Shadow(
                                                  offset:  const Offset(0.5, 0.5),
                                                  blurRadius: 0.5,
                                                  color: Colors.black
                                                      .withValues(alpha:0.5)),
                                            ],
                                            fontSize: 12,
                                            letterSpacing: 0,
                                            fontFamily: Get.find<StorageService>()
                                                .activeLocale ==
                                                SupportedLocales.english
                                                ? fontFamilyEnglishName
                                                : fontFamilyArabicName,
                                            color: kBlueColor,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                            //text of the post
                            const SizedBox(height: 5,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: ReadMoreText(
                                  postData?.text??"",
                                  colorClickableText: kDarkBlueColor,

                                  style: TextStyle(
                                    shadows: <Shadow>[
                                      Shadow(
                                          offset:  const Offset(0.5, 0.5),
                                          blurRadius: 0.5,
                                          color: Colors.black
                                              .withValues(alpha:0.5)),
                                    ],
                                    fontSize: 12,
                                    letterSpacing: 0,
                                    fontFamily: Get.find<StorageService>()
                                        .activeLocale ==
                                        SupportedLocales.english
                                        ? fontFamilyEnglishName
                                        : fontFamilyArabicName,
                                    color: kDarkBlueColor,
                                  ),
                                  textAlign: TextAlign.center,
                                  semanticsLabel: "gjeirsdogio"),
                            ),
                            const SizedBox(height: 5,),
                            InkWell(
                              onTap: (){
                                Get.to(()=>PostScreenChat(postId: "${postData?.id??0}",));
                              },
                              child: Container(
                                width: Get.width*0.7,
                                decoration: BoxDecoration(
                                  color: kBlueColor,
                                  border: Border.all(color: kBlueColor,width: 3),
                                  borderRadius: const BorderRadius.only(
                                    bottomRight:  Radius.circular(10),
                                    bottomLeft:  Radius.circular(10),
                                  ),
                                ),
                                child: Center(
                                  child:  CustomText(
                                    textAlign: TextAlign.center,
                                    maxLines: 3,
                                    Get.find<StorageService>()
                                        .activeLocale ==
                                        SupportedLocales.english
                                        ?"open post":"فتح المنشور",
                                    style: TextStyle(
                                      shadows: <Shadow>[
                                        Shadow(
                                            offset:  const Offset(0.5, 0.5),
                                            blurRadius: 0.5,
                                            color: Colors.black
                                                .withValues(alpha:0.5)),
                                      ],
                                      fontSize: 12,
                                      letterSpacing: 0,
                                      fontFamily: Get.find<StorageService>()
                                          .activeLocale ==
                                          SupportedLocales.english
                                          ? fontFamilyEnglishName
                                          : fontFamilyArabicName,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
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
