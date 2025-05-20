// ignore_for_file: sized_box_for_whitespace, unused_local_variable, deprecated_member_use, prefer_is_empty, use_build_context_synchronously, avoid_print, depend_on_referenced_packages

import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:get/get.dart';
import 'package:madrasty/Models/post_model.dart';
import 'package:madrasty/Models/response_model.dart';
import 'package:madrasty/Services/posting_services.dart';
import 'package:madrasty/UI/posts/report_post/report_post_screen.dart';
import 'package:madrasty/UI/posts/widgets/comment_loading_widget.dart';
import 'package:madrasty/UI/posts/widgets/comment_widget.dart';
import 'package:madrasty/UI/posts/widgets/photoDetails_screen.dart';
import 'package:madrasty/UI/posts/widgets/read_more_widget.dart';
import 'package:madrasty/UI/posts/widgets/show_more_comment_screen.dart';
import 'package:madrasty/UI/posts/widgets/video_player_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import '../../../Models/comment_model.dart';
import '../../../Models/like_model.dart';
import 'package:http/http.dart' as http;
import '../../../Models/parent_share_model.dart';
import '../../../Models/student_share_model.dart';
import '../../../Services/chat_services.dart';
import '../../../Utils/Colors_File.dart';
import '../../../Utils/constant.dart';
import '../../../Utils/localization_services.dart';
import '../../../Utils/memory.dart';
import '../../../Utils/services.dart';
import '../../../Utils/translation_key.dart';
import '../../../Widgets/alert_dialogue.dart';
import '../../../Widgets/custom_text_widget.dart';
import 'package:intl/intl.dart';
import '../../../Widgets/file_icons_widget.dart';
import '../../../Widgets/loader.dart';
import '../../../Widgets/loading_alert_dialogue.dart';
import '../../pdfViewer/pdf_viewer.dart';

class PostWidget extends StatefulWidget {
  const PostWidget({super.key, required this.postDataFromScreen, required this.schoolId, required this.classId, this.peopleSareList, this.parentShareList});
 final Post? postDataFromScreen;
 final String schoolId;
 final String classId;
 final List<StudentShareModel>? peopleSareList;
 final List<ParentShareModel>? parentShareList;
  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  Post? postData;
  late  VideoPlayerController videoPlayerController;
  late TextEditingController commentTextController;

  bool isLoadingVideo = true;
  GlobalKey previewContainer = GlobalKey();
  bool noCommentsToShow = false;
  SampleItem? selectedItem;
  var random = Random();
  var showMoreComments = false;
   bool likedPostOrNot = false ;
  bool isLoadingComment = true;
   List<CommentModel>? comments = [];
   List<CommentModel?>? shownComments = [];
  late FocusNode text1FocusNode;

  bool isSendingComment = false;
  @override
  void initState() {
    commentTextController = TextEditingController();
    text1FocusNode = FocusNode();
    postData = widget.postDataFromScreen;
    getComments();
    if((postData?.userLike??0) == 1){
      likedPostOrNot = true;
      setState(() {

      });
    }else{
      likedPostOrNot = false;
      setState(() {

      });
    }    if((widget.postDataFromScreen?.type == "VIDEOS")||(widget.postDataFromScreen?.type == "VID")){
      videoPlayerController =
      VideoPlayerController.network("${Services.baseUrl}${postData?.images?[0]??""}")
        ..initialize().then((_) {
          isLoadingVideo = false;
          print("hiFromVideo""${Services.baseUrl}${postData?.images?[0]??""}");
          setState(() {

          });
        });


    }
    super.initState();
  }
  //sharing -------------------------------------------------------------
  sharingThePostThroughtTheMessageOfTheApp(String receiverId,BuildContext context) async {
    ResponseModel? status = await ChatServices.sendMessage(receiverId,Get.find<StorageService>().getUserType,"${postData?.id??0}",null,"POST");
    if((status?.msg??"") == "succeeded") {
      Navigator.pop(context);
      final snackBar = SnackBar(content:
      Row(children: [
        const Icon(Icons.check, color: Colors.white,),
        const SizedBox(width: 10,),
        Text(Localizations
            .localeOf(context)
            .languageCode == "en"
            ? 'the post has been shared'
            : 'تم مشاركه المنشور', style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
        ),
        ),
      ],),
          backgroundColor: Colors.green
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

    }
    else{
      final snackBar = SnackBar(content:
      Row(children: [
        const Icon(Icons.close, color: Colors.white,),
        const SizedBox(width: 10,),
        Text(Localizations
            .localeOf(context)
            .languageCode == "en"
            ? 'try again later'
            : 'حاول مره اخرى لاحقا', style: const TextStyle(
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
  sharingPost(BuildContext context){
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
              children:Get
                  .find<StorageService>()
                  .getUserType=="PARENT"?
              widget.parentShareList!.map<Widget>((e){
                return Container(
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
                              const SizedBox(
                                width: 5,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                  const SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () async {
                              await sharingThePostThroughtTheMessageOfTheApp("${e.id??0}",context);
                            },
                            child: CustomText(
                              Get.find<
                                  StorageService>()
                                  .activeLocale ==
                                  SupportedLocales
                                      .english
                                  ? "  Share   "
                                  : "  شارك   ",
                              style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: Get.find<
                                    StorageService>()
                                    .activeLocale ==
                                    SupportedLocales
                                        .english
                                    ? fontFamilyEnglishName
                                    : fontFamilyArabicName,
                                color: kDarkBlueColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      e == widget.parentShareList?.last
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
                );
              }).toList()
                  :widget.peopleSareList!.map<Widget>((e){
                return Container(
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
                              const SizedBox(
                                width: 5,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                  const SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () async {
                             await sharingThePostThroughtTheMessageOfTheApp("${e.id??0}",context);
                            },
                            child: CustomText(
                              Get.find<
                                  StorageService>()
                                  .activeLocale ==
                                  SupportedLocales
                                      .english
                                  ? "  Share   "
                                  : "  شارك   ",
                              style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: Get.find<
                                    StorageService>()
                                    .activeLocale ==
                                    SupportedLocales
                                        .english
                                    ? fontFamilyEnglishName
                                    : fontFamilyArabicName,
                                color: kDarkBlueColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      e == widget.peopleSareList?.last
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
                );
              }).toList(),
            ),
          ),
        );
    },
    );
  }
  Future<void> sharingSocialPostLink() async {
    await Share.share("Post Dynamic Link",
      subject: 'this Post Shared From App Called Madrasty',

    );
  }
  Future<void> sharingSocialPostImage() {
    List<String> imagePaths = [];
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    String message = '';
    final RenderBox box = context.findRenderObject() as RenderBox;
    return  Future.delayed(const Duration(milliseconds: 20), () async {
      RenderRepaintBoundary? boundary = previewContainer.currentContext!
          .findRenderObject() as RenderRepaintBoundary?;
      ui.Image image = await boundary!.toImage();

      final directory = (await getApplicationDocumentsDirectory()).path;
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      File imgFile = File('$directory/screenshot${random.nextInt(100)}.png');
      imagePaths.add(imgFile.path);
      imgFile.writeAsBytes(pngBytes).then((value) async {


        imgFile.writeAsBytes(pngBytes).then((value) async {
          await Share.shareFiles(imagePaths,
              subject: 'Share',
              text: 'Check this Out!',
              sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
          message = 'Post Has Been Shared';
          scaffoldMessenger.showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check,color: Colors.white,
                      size: 20,),
                    const SizedBox(width: 20,),
                    Text(
                      message,
                      style:  const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                backgroundColor:Colors.green,
              ));
        }).catchError((onError) {
          message = onError.toString();
          scaffoldMessenger.showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.close,color: Colors.white,
                      size: 20,),
                    const SizedBox(width: 20,),
                    Text(
                      message,
                      style:  const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                backgroundColor:Colors.red,
              ));
        });
      });
  });
  }
  Future<void> _captureSocialPng() {
    List<String> imagePaths = [];
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    String message = '';
    final RenderBox box = context.findRenderObject() as RenderBox;
    return Future.delayed(const Duration(milliseconds: 20), () async {
      RenderRepaintBoundary? boundary = previewContainer.currentContext!
          .findRenderObject() as RenderRepaintBoundary?;
      ui.Image image = await boundary!.toImage();

      final directory = (await getApplicationDocumentsDirectory()).path;
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      File imgFile = File('$directory/screenshot${random.nextInt(100)}.png');
      imagePaths.add(imgFile.path);
      imgFile.writeAsBytes(pngBytes).then((value) async {


        // Ask the user to save it
        final params = SaveFileDialogParams(sourceFilePath: imgFile.path);
        final finalPath = await FlutterFileDialog.saveFile(params: params);
        if (finalPath != null) {
          message = 'post saved to gallery';
          scaffoldMessenger.showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check,color: Colors.white,
                      size: 20,),
                    const SizedBox(width: 20,),
                    Text(
                      message,
                      style:  const TextStyle(
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
      }).catchError((onError) {
        message = onError.toString();
        scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.close,color: Colors.white,
                    size: 20,),
                  const SizedBox(width: 20,),
                  Text(
                    message,
                    style:  const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              backgroundColor:Colors.red,
            ));
      });
    });
  }
  //comments------------------------------------------------------------
  getComments() async {
    noCommentsToShow = false;
    isLoadingComment = true;
    setState(() {
    });
    comments = await PostingServices.getCommentsList("${postData?.id??""}");
    shownComments = [];
    if(comments?.isNotEmpty??false) {
      if ((comments?.length ?? 0)-1 > 3) {
        for (int i = 3; i > 0; i--) {
          shownComments?.add(comments?[(comments?.length??0)-(i)]);
        }
      }
    }else{
      noCommentsToShow = true;
    }
    isLoadingComment = false;
    setState(() {

    });
  }
   showingMoreComments(){
     showMoreComments = !showMoreComments;
     setState(() {

     });
   }
  addComment(BuildContext context) async {
    if(commentTextController.text.trim().isNotEmpty&&commentTextController.text != (Localizations
        .localeOf(context)
        .languageCode == "en"
        ?  "Write Your Comment"
        : 'اكتب تعليقك ')){
      setState(() {
        isSendingComment = true;
      });
    ResponseModel? data = await PostingServices.addComment(commentTextController.text, "${postData?.id??0}");
    if((data?.status??"") == "true") {
      await getComments();
      commentTextController.clear();
      text1FocusNode.unfocus();
      postData?.commentCount =  (postData?.commentCount??0) + 1;
      final snackBar = SnackBar(content:
      Row(children: [
        const Icon(Icons.check, color: Colors.white,),
        const SizedBox(width: 10,),
        Text(Localizations
            .localeOf(context)
            .languageCode == "en"
            ? 'the comment has been added'
            : 'تم أضافه التعليق بنجاح', style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
        ),
        ),
      ],),
          backgroundColor: Colors.green
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      setState(() {
        isSendingComment = false;

      });
    }
    else{
      final snackBar = SnackBar(content:
      Row(children: [
        const Icon(Icons.close, color: Colors.white,),
        const SizedBox(width: 10,),
        Text(Localizations
            .localeOf(context)
            .languageCode == "en"
            ? 'try again later'
            : 'حاول مره اخرى لاحقا', style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
        ),
        ),
      ],),
          backgroundColor: Colors.red
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        isSendingComment = false;

      });
    }}
    else{
      showDialog(context: context,
          builder: (context) {
            return AlertDialogue(alertTitle: errorKey.tr, alertText:Localizations
                .localeOf(context)
                .languageCode == "en"
                ? 'enter valid comment'
                : 'اكتب تعليق الذى تريد اضافته',alertIcon: "assets/icons/warningIcon.png",containerHeight:  Get.height*0.4);
          });
      setState(() {
        isSendingComment = false;

      });
    }
  }
  //liking post --------------------------------------------------------
  likingOrDislikingPost() async {
    ResponseModel? data = await PostingServices.likeOrDisLikePost(
        "${postData?.id ?? 0}");
     if ((data?.status ?? "") == "true") {
      await checkedIfPostLikedOrNot();
      if(likedPostOrNot) {
        postData?.likeCount = (postData?.likeCount ?? 0) + 1;
      }else{
        postData?.likeCount = (postData?.likeCount ?? 0) - 1;
      }
       setState(() {

       });
    }
    else {
      final snackBar = SnackBar(content:
      Row(children: [
        const Icon(Icons.close, color: Colors.white,),
        const SizedBox(width: 10,),
        Text(Localizations
            .localeOf(context)
            .languageCode == "en"
            ? 'try again later'
            : 'حاول مره اخرى لاحقا', style: const TextStyle(
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
  checkedIfPostLikedOrNot() async {
    LikeModel? data = await PostingServices.getUserLikedPostOrNot("${postData?.id??0}");
    if((data?.like??0) == 1){
      likedPostOrNot = true;
      setState(() {

      });
    }else{
      likedPostOrNot = false;
      setState(() {

      });
    }
  }
  //information for the post ------------------------------------------
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
  //file for pdf -------------------------------------------------------
     saveFile(String url, String fileName) async {
       final scaffoldMessenger = ScaffoldMessenger.of(context);
       String message = '';

       try {
         // Download image
         final http.Response response = await http.get(
             Uri.parse(url));

         // Get temporary directory
         final dir = await getTemporaryDirectory();

         // Create an image name
         var filename = '${dir.path}/$fileName';

         // Save to filesystem
         final file = File(filename);
         await file.writeAsBytes(response.bodyBytes);

         // Ask the user to save it
         final params = SaveFileDialogParams(sourceFilePath: file.path);
         final finalPath = await FlutterFileDialog.saveFile(params: params);
         print(finalPath);
         if (finalPath != null) {
           message = Get.find<StorageService>()
               .activeLocale ==
               SupportedLocales.english
               ?'pdf saved to Download':
           "تم تحميل الملف بنجاح";
           scaffoldMessenger.showSnackBar(
               SnackBar(
                 content: Row(
                   children: [
                     const Icon(Icons.check,color: Colors.white,
                       size: 20,),
                     const SizedBox(width: 20,),
                     Text(
                       message,
                       style:  const TextStyle(
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
       } catch (e) {
         message = e.toString();
         scaffoldMessenger.showSnackBar(
             SnackBar(
               content: Row(
                 children: [
                   const Icon(Icons.close,color: Colors.white,
                     size: 20,),
                   const SizedBox(width: 20,),
                   Text(
                     message,
                     style:  const TextStyle(
                       fontSize: 12,
                       color: Colors.white,
                       fontWeight: FontWeight.bold,
                     ),
                   ),
                 ],
               ),
               backgroundColor:Colors.red,
             ));
       }
       print(message);
     }
   getFileName(String? filePath){
     print(filePath);
     return filePath?.split('/').last??"";

   }
  @override
  Widget build(BuildContext context) {
    return  Column(

      children: [
        RepaintBoundary(
          key: previewContainer,
          child: Container(
            color: Colors.white,
            child: Column(
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
                                          .withOpacity(0.5)),
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
                                          .withOpacity(0.5)),
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
                                          .withOpacity(0.5)),
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
                    PopupMenuButton<SampleItem>(
                      icon:               const Icon(Icons.keyboard_control_outlined,color: kDarkBlueColor,),

                      initialValue: selectedItem,
                      onSelected: (SampleItem item) {
                        setState(() {
                          selectedItem = item;
                        });
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
                        PopupMenuItem<SampleItem>(
                          value: SampleItem.itemOne,
                          onTap: (){
                            _captureSocialPng();
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.post_add,color: kDarkBlueColor,
                                size: 30,),
                              const SizedBox(width: 10,),
                              CustomText(
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                "Save the Post",
                                style: TextStyle(
                                  shadows: <Shadow>[
                                    Shadow(
                                        offset:  const Offset(0.5, 0.5),
                                        blurRadius: 0.5,
                                        color: Colors.black
                                            .withOpacity(0.5)),
                                  ],
                                  fontSize: 15,
                                  letterSpacing: 0,
                                  fontFamily: Get.find<StorageService>()
                                      .activeLocale ==
                                      SupportedLocales.english
                                      ? fontFamilyEnglishName
                                      : fontFamilyArabicName,
                                  color: kDarkBlueColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem<SampleItem>(
                          value: SampleItem.itemOne,
                          onTap: (){

                            Get.to(()=> ReportPostScreen(postId: '${postData?.id??0}',));
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.report_gmailerrorred_rounded,color: kDarkBlueColor,
                                size: 30,),
                              const SizedBox(width: 10,),
                              CustomText(
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                "Report the Post",
                                style: TextStyle(
                                  shadows: <Shadow>[
                                    Shadow(
                                        offset:  const Offset(0.5, 0.5),
                                        blurRadius: 0.5,
                                        color: Colors.black
                                            .withOpacity(0.5)),
                                  ],
                                  fontSize: 15,
                                  letterSpacing: 0,
                                  fontFamily: Get.find<StorageService>()
                                      .activeLocale ==
                                      SupportedLocales.english
                                      ? fontFamilyEnglishName
                                      : fontFamilyArabicName,
                                  color: kDarkBlueColor,
                                ),
                              ),
                            ],
                          ),
                        ),

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
                                  .withOpacity(0.5)),
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
                (postData?.type == "FIL")?postData?.images?.isEmpty??true?const SizedBox():Container(
                  width: Get.width*0.8,
                  height: Get.height*0.13,
                  decoration: BoxDecoration(
                      color: Colors.white,
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
                                    getFileName(postData?.images?[0]??"")??"",
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
                            FileIconWidget(fileName:getFileName(postData?.images?[0]??"")??"",)



                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: (){
                                Get.to(()=>const PdfViewer(),arguments: ["${Services.baseUrl}${postData?.images?[0]??""}",getFileName("${Services.baseUrl}${postData?.images?[0]??""}")]);

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
                                                  .withOpacity(0.5)),
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
                              onTap: () async {
                               saveFile ("${Services.baseUrl}${postData?.images?[0]??""}", getFileName("${Services.baseUrl}${postData?.images?[0]??""}"));
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
                                                  .withOpacity(0.5)),
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
                ):
                //video of the post
                (postData?.type == "VID")||(postData?.type == "VIDEOS")?isLoadingVideo?ClipRRect( //<---here
                  borderRadius :BorderRadius.circular(25),
                  child: Loader( height: Get.height*0.4,
                    width: Get.width*0.9,),
                ):VideoPlayerWidget(videoPlayer:"${Services.baseUrl}${postData?.images?[0]??""}" , videoPlayerController: videoPlayerController,):
                (postData?.type == "IMG")?(postData?.images?.isEmpty??true)?const SizedBox():postData?.images?.length == 0
                    ?const SizedBox():
                    //images of the post
                postData?.images?.length == 1?Center(
                  child: InkWell(
                    onTap: (){
                      Get.to(()=>PhotoDetailedScreen(link: postData!.images!,index: 0,));
                    },
                    child: CachedNetworkImage(
                      imageUrl:"${Services.baseUrl}${postData?.images?[0]??""}",
                      imageBuilder: ((context, image) {
                        return Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            height: Get.height * 0.4,
                            width: Get.width * 0.9,
                            decoration:  BoxDecoration(
                              color: kDarkBlueColor,
                              boxShadow: const [
                                BoxShadow(
                                  color: kGrayColor,
                                  blurRadius: 2,
                                  offset:
                                  Offset(1, 1), // Shadow position
                                ),
                              ],
                               image: DecorationImage(
                              image: image,
                              fit: BoxFit.cover,
                            ),
                            ),
                          ),
                        );
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
                              child: Loader(
                                height: Get.height * 0.4,
                                width: Get.width * 0.9,)),
                        );
                      },
                      errorWidget: (context, url, error) {
                        return Container(
                            height: Get.height * 0.4,
                            width: Get.width * 0.9,
                            margin:
                            const EdgeInsets.symmetric(
                                horizontal: 5.0),
                          decoration:  const BoxDecoration(
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
                                  "assets/images/no_data_slideShow.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ):
                postData?.images?.length == 2?Center(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: kGrayColor,
                            blurRadius: 2,
                            offset:
                            Offset(1, 1), // Shadow position
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: (){
                              Get.to(()=>PhotoDetailedScreen(link: postData!.images!,index: 0,));
                            },
                            child: CachedNetworkImage(
                              imageUrl:"${Services.baseUrl}${postData?.images?[0]??""}",
                              imageBuilder: ((context, image) {
                                return Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Container(
                                    height: Get.height * 0.2,
                                    width: Get.width * 0.9,
                                    decoration:  BoxDecoration(
                                      color: kDarkBlueColor,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: kGrayColor,
                                          blurRadius: 2,
                                          offset:
                                          Offset(1, 1), // Shadow position
                                        ),
                                      ],
                                      image: DecorationImage(
                                        image: image,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
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
                                      child: Loader(
                                        height: Get.height * 0.2,
                                        width: Get.width * 0.9,)),
                                );
                              },
                              errorWidget: (context, url, error) {
                                return Container(
                                  height: Get.height * 0.2,
                                  width: Get.width * 0.9,
                                  margin:
                                  const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  decoration:  const BoxDecoration(
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
                                          "assets/images/no_data_slideShow.png"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            )

                          ),
                          InkWell(
                            onTap: (){
                              Get.to(()=>PhotoDetailedScreen(link: postData!.images!,index: 1,));
                            },
                            child: CachedNetworkImage(
                              imageUrl:"${Services.baseUrl}${postData?.images?[1]??""}",
                              imageBuilder: ((context, image) {
                                return Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Container(
                                    height: Get.height * 0.2,
                                    width: Get.width * 0.9,
                                    decoration:  BoxDecoration(
                                      color: kDarkBlueColor,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: kGrayColor,
                                          blurRadius: 2,
                                          offset:
                                          Offset(1, 1), // Shadow position
                                        ),
                                      ],
                                      image: DecorationImage(
                                        image: image,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
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
                                      child: Loader(
                                        height: Get.height * 0.2,
                                        width: Get.width * 0.9,)),
                                );
                              },
                              errorWidget: (context, url, error) {
                                return Container(
                                  height: Get.height * 0.2,
                                  width: Get.width * 0.9,
                                  margin:
                                  const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  decoration:  const BoxDecoration(
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
                                          "assets/images/no_data_slideShow.png"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ):
                postData?.images?.length == 3?Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: Get.width*0.9,
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: kGrayColor,
                            blurRadius: 2,
                            offset:
                            Offset(1, 1), // Shadow position
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: (){
                              Get.to(()=>PhotoDetailedScreen(link: postData!.images!,index: 0,));
                            },
                            child: CachedNetworkImage(
                              imageUrl:"${Services.baseUrl}${postData?.images?[1]??""}",
                              imageBuilder: ((context, image) {
                                return Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Container(
                                    height: Get.height * 0.4,
                                    width: Get.width * 0.45,
                                    decoration:  BoxDecoration(
                                      color: kDarkBlueColor,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: kGrayColor,
                                          blurRadius: 2,
                                          offset:
                                          Offset(1, 1), // Shadow position
                                        ),
                                      ],
                                      image: DecorationImage(
                                        image: image,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
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
                                      child: Loader(
                                        height: Get.height * 0.4,
                                        width: Get.width * 0.45,)),
                                );
                              },
                              errorWidget: (context, url, error) {
                                return Container(
                                  height: Get.height * 0.4,
                                  width: Get.width * 0.45,
                                  margin:
                                  const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  decoration:  const BoxDecoration(
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
                                          "assets/images/no_data_slideShow.png"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Column(
                            children: [
                              InkWell(
                                onTap: (){
                                  Get.to(()=>PhotoDetailedScreen(link: postData!.images!,index: 1,));
                                },
                                child: CachedNetworkImage(
                                  imageUrl:"${Services.baseUrl}${postData?.images?[1]??""}",
                                  imageBuilder: ((context, image) {
                                    return Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Container(
                                        height: Get.height * 0.2,
                                        width: Get.width * 0.45,
                                        decoration:  BoxDecoration(
                                          color: kDarkBlueColor,
                                          boxShadow: const [
                                            BoxShadow(
                                              color: kGrayColor,
                                              blurRadius: 2,
                                              offset:
                                              Offset(1, 1), // Shadow position
                                            ),
                                          ],
                                          image: DecorationImage(
                                            image: image,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
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
                                          child: Loader(
                                            height: Get.height * 0.2,
                                            width: Get.width * 0.45,)),
                                    );
                                  },
                                  errorWidget: (context, url, error) {
                                    return Container(
                                      height: Get.height * 0.2,
                                      width: Get.width * 0.45,
                                      margin:
                                      const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      decoration:  const BoxDecoration(
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
                                              "assets/images/no_data_slideShow.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  Get.to(()=>PhotoDetailedScreen(link:postData!.images!,index: 2,));
                                },
                                child: CachedNetworkImage(
                                  imageUrl:"${Services.baseUrl}${postData?.images?[2]??""}",
                                  imageBuilder: ((context, image) {
                                    return Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Container(
                                        height: Get.height * 0.2,
                                        width: Get.width * 0.45,
                                        decoration:  BoxDecoration(
                                          color: kDarkBlueColor,
                                          boxShadow: const [
                                            BoxShadow(
                                              color: kGrayColor,
                                              blurRadius: 2,
                                              offset:
                                              Offset(1, 1), // Shadow position
                                            ),
                                          ],
                                          image: DecorationImage(
                                            image: image,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
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
                                          child: Loader(
                                            height: Get.height * 0.2,
                                            width: Get.width * 0.45,)),
                                    );
                                  },
                                  errorWidget: (context, url, error) {
                                    return Container(
                                      height: Get.height * 0.2,
                                      width: Get.width * 0.45,
                                      margin:
                                      const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      decoration:  const BoxDecoration(
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
                                              "assets/images/no_data_slideShow.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ):
                postData?.images?.length == 4?Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: Get.width*0.9,
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: kGrayColor,
                            blurRadius: 2,
                            offset:
                            Offset(1, 1), // Shadow position
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              InkWell(
                                onTap: (){
                                  Get.to(()=>PhotoDetailedScreen(link: postData!.images!,index: 0,));
                                },
                                child: CachedNetworkImage(
                                  imageUrl:"${Services.baseUrl}${postData?.images?[0]??""}",
                                  imageBuilder: ((context, image) {
                                    return Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Container(
                                        height: Get.height * 0.2,
                                        width: Get.width * 0.45,
                                        decoration:  BoxDecoration(
                                          color: kDarkBlueColor,
                                          boxShadow: const [
                                            BoxShadow(
                                              color: kGrayColor,
                                              blurRadius: 2,
                                              offset:
                                              Offset(1, 1), // Shadow position
                                            ),
                                          ],
                                          image: DecorationImage(
                                            image: image,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
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
                                          child: Loader(
                                            height: Get.height * 0.2,
                                            width: Get.width * 0.45,)),
                                    );
                                  },
                                  errorWidget: (context, url, error) {
                                    return Container(
                                      height: Get.height * 0.2,
                                      width: Get.width * 0.45,
                                      margin:
                                      const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      decoration:  const BoxDecoration(
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
                                              "assets/images/no_data_slideShow.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  Get.to(()=>PhotoDetailedScreen(link: postData!.images!,index: 1,));
                                },
                                child: CachedNetworkImage(
                                  imageUrl:"${Services.baseUrl}${postData?.images?[1]??""}",
                                  imageBuilder: ((context, image) {
                                    return Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Container(
                                        height: Get.height * 0.2,
                                        width: Get.width * 0.45,
                                        decoration:  BoxDecoration(
                                          color: kDarkBlueColor,
                                          boxShadow: const [
                                            BoxShadow(
                                              color: kGrayColor,
                                              blurRadius: 2,
                                              offset:
                                              Offset(1, 1), // Shadow position
                                            ),
                                          ],
                                          image: DecorationImage(
                                            image: image,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
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
                                          child: Loader(
                                            height: Get.height * 0.2,
                                            width: Get.width * 0.45,)),
                                    );
                                  },
                                  errorWidget: (context, url, error) {
                                    return Container(
                                      height: Get.height * 0.2,
                                      width: Get.width * 0.45,
                                      margin:
                                      const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      decoration:  const BoxDecoration(
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
                                              "assets/images/no_data_slideShow.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              InkWell(
                                onTap: (){
                                  Get.to(()=>PhotoDetailedScreen(link: postData!.images!,index: 2,));
                                },
                                child: CachedNetworkImage(
                                  imageUrl:"${Services.baseUrl}${postData?.images?[2]??""}",
                                  imageBuilder: ((context, image) {
                                    return Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Container(
                                        height: Get.height * 0.2,
                                        width: Get.width * 0.45,
                                        decoration:  BoxDecoration(
                                          color: kDarkBlueColor,
                                          boxShadow: const [
                                            BoxShadow(
                                              color: kGrayColor,
                                              blurRadius: 2,
                                              offset:
                                              Offset(1, 1), // Shadow position
                                            ),
                                          ],
                                          image: DecorationImage(
                                            image: image,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
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
                                          child: Loader(
                                            height: Get.height * 0.2,
                                            width: Get.width * 0.45,)),
                                    );
                                  },
                                  errorWidget: (context, url, error) {
                                    return Container(
                                      height: Get.height * 0.2,
                                      width: Get.width * 0.45,
                                      margin:
                                      const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      decoration:  const BoxDecoration(
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
                                              "assets/images/no_data_slideShow.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  Get.to(()=>PhotoDetailedScreen(link: postData!.images!,index: 3,));
                                },
                                child: CachedNetworkImage(
                                  imageUrl:"${Services.baseUrl}${postData?.images?[3]??""}",
                                  imageBuilder: ((context, image) {
                                    return Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Container(
                                        height: Get.height * 0.2,
                                        width: Get.width * 0.45,
                                        decoration:  BoxDecoration(
                                          color: kDarkBlueColor,
                                          boxShadow: const [
                                            BoxShadow(
                                              color: kGrayColor,
                                              blurRadius: 2,
                                              offset:
                                              Offset(1, 1), // Shadow position
                                            ),
                                          ],
                                          image: DecorationImage(
                                            image: image,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
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
                                          child: Loader(
                                            height: Get.height * 0.2,
                                            width: Get.width * 0.45,)),
                                    );
                                  },
                                  errorWidget: (context, url, error) {
                                    return Container(
                                      height: Get.height * 0.2,
                                      width: Get.width * 0.45,
                                      margin:
                                      const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      decoration:  const BoxDecoration(
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
                                              "assets/images/no_data_slideShow.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ):
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: Get.width*0.93,
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: kGrayColor,
                            blurRadius: 2,
                            offset:
                            Offset(1, 1), // Shadow position
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              InkWell(
                                onTap: (){
                                  Get.to(()=>PhotoDetailedScreen(link:postData!.images!,index: 0,));
                                },
                                child: CachedNetworkImage(
                                  imageUrl:"${Services.baseUrl}${postData?.images?[0]??""}",
                                  imageBuilder: ((context, image) {
                                    return Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Container(
                                        height: Get.height * 0.2,
                                        width: Get.width * 0.45,
                                        decoration:  BoxDecoration(
                                          color: kDarkBlueColor,
                                          boxShadow: const [
                                            BoxShadow(
                                              color: kGrayColor,
                                              blurRadius: 2,
                                              offset:
                                              Offset(1, 1), // Shadow position
                                            ),
                                          ],
                                          image: DecorationImage(
                                            image: image,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
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
                                          child: Loader(
                                            height: Get.height * 0.2,
                                            width: Get.width * 0.45,)),
                                    );
                                  },
                                  errorWidget: (context, url, error) {
                                    return Container(
                                      height: Get.height * 0.2,
                                      width: Get.width * 0.45,
                                      margin:
                                      const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      decoration:  const BoxDecoration(
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
                                              "assets/images/no_data_slideShow.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  Get.to(()=>PhotoDetailedScreen(link:postData!.images!,index: 1,));
                                },
                                child: CachedNetworkImage(
                                  imageUrl:"${Services.baseUrl}${postData?.images?[1]??""}",
                                  imageBuilder: ((context, image) {
                                    return Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Container(
                                        height: Get.height * 0.2,
                                        width: Get.width * 0.45,
                                        decoration:  BoxDecoration(
                                          color: kDarkBlueColor,
                                          boxShadow: const [
                                            BoxShadow(
                                              color: kGrayColor,
                                              blurRadius: 2,
                                              offset:
                                              Offset(1, 1), // Shadow position
                                            ),
                                          ],
                                          image: DecorationImage(
                                            image: image,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
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
                                          child: Loader(
                                            height: Get.height * 0.2,
                                            width: Get.width * 0.45,)),
                                    );
                                  },
                                  errorWidget: (context, url, error) {
                                    return Container(
                                      height: Get.height * 0.2,
                                      width: Get.width * 0.45,
                                      margin:
                                      const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      decoration:  const BoxDecoration(
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
                                              "assets/images/no_data_slideShow.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              InkWell(
                                onTap: (){
                                  Get.to(()=>PhotoDetailedScreen(link:postData!.images!,index: 2,));
                                },
                                child: CachedNetworkImage(
                                  imageUrl:"${Services.baseUrl}${postData?.images?[2]??""}",
                                  imageBuilder: ((context, image) {
                                    return Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Container(
                                        height: Get.height * 0.2,
                                        width: Get.width * 0.45,
                                        decoration:  BoxDecoration(
                                          color: kDarkBlueColor,
                                          boxShadow: const [
                                            BoxShadow(
                                              color: kGrayColor,
                                              blurRadius: 2,
                                              offset:
                                              Offset(1, 1), // Shadow position
                                            ),
                                          ],
                                          image: DecorationImage(
                                            image: image,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
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
                                          child: Loader(
                                            height: Get.height * 0.2,
                                            width: Get.width * 0.45,)),
                                    );
                                  },
                                  errorWidget: (context, url, error) {
                                    return Container(
                                      height: Get.height * 0.2,
                                      width: Get.width * 0.45,
                                      margin:
                                      const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      decoration:  const BoxDecoration(
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
                                              "assets/images/no_data_slideShow.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  Get.to(()=>PhotoDetailedScreen(link: postData!.images!,index: 3,));
                                },
                                child: Stack(
                                  children: [
                                CachedNetworkImage(
                                imageUrl:"${Services.baseUrl}${postData?.images?[3]??""}",
                                  imageBuilder: ((context, image) {
                                    return Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Container(
                                        height: Get.height * 0.2,
                                        width: Get.width * 0.45,
                                        decoration:  BoxDecoration(
                                          color: kDarkBlueColor,
                                          boxShadow: const [
                                            BoxShadow(
                                              color: kGrayColor,
                                              blurRadius: 2,
                                              offset:
                                              Offset(1, 1), // Shadow position
                                            ),
                                          ],
                                          image: DecorationImage(
                                            image: image,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
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
                                          child: Loader(
                                            height: Get.height * 0.2,
                                            width: Get.width * 0.45,)),
                                    );
                                  },
                                  errorWidget: (context, url, error) {
                                    return Container(
                                      height: Get.height * 0.2,
                                      width: Get.width * 0.45,
                                      margin:
                                      const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      decoration:  const BoxDecoration(
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
                                              "assets/images/no_data_slideShow.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                    Container(
                                      height: Get.height * 0.205,
                                      width: Get.width * 0.46,
                                      decoration:  BoxDecoration(
                                        color: Colors.black.withOpacity(0.3),

                                      ),
                                      child: Center(
                                        child: CustomText(
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          "${postData?.images?.length??0 - 4}+",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 40,
                                            letterSpacing: 0,
                                            fontFamily: Get.find<StorageService>()
                                                .activeLocale ==
                                                SupportedLocales.english
                                                ? fontFamilyEnglishName
                                                : fontFamilyArabicName,
                                            color: kBlueColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ):const SizedBox(),
              ],
            ),
          ),
        ),


        const SizedBox(height: 5,),
        //counter for the post
        Container(
          width: Get.width*0.9,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Row(
                children: [
                  CustomText(
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    "${postData!.commentCount??0}",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
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
                  const Icon(Icons.shortcut_outlined ,color: kBlueColor,),


                ],
              ),
              Row(
                children: [
                  CustomText(
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    "${postData!.commentCount??0}",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
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
                  const Icon(Icons.comment_outlined  ,color: kBlueColor,),


                ],
              ),
              Row(
                children: [
                  CustomText(
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    "${postData!.likeCount??0}",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
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
                  const Icon(Icons.thumb_up_off_alt_outlined ,color: kBlueColor,),


                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 5,),
        const Divider(
          color: kYellowColor,
          height: 1,
          thickness: 2,
          endIndent: 10,
          indent: 10,
        ),
        //action button for the post
        const SizedBox(height: 5,),
        Container(
          width: Get.width*0.9,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              PopupMenuButton<SampleItem>(
                initialValue: selectedItem,
                onSelected: (SampleItem item) {
                  setState(() {
                    selectedItem = item;
                  });
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
                  PopupMenuItem<SampleItem>(
                    value: SampleItem.itemOne,
                    onTap: (){
                      sharingSocialPostImage();
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.post_add,color: kDarkBlueColor,
                          size: 30,),
                        const SizedBox(width: 10,),
                        CustomText(
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          "Share Image Of the Post",
                          style: TextStyle(
                            shadows: <Shadow>[
                              Shadow(
                                  offset:  const Offset(0.5, 0.5),
                                  blurRadius: 0.5,
                                  color: Colors.black
                                      .withOpacity(0.5)),
                            ],
                            fontSize: 15,
                            letterSpacing: 0,
                            fontFamily: Get.find<StorageService>()
                                .activeLocale ==
                                SupportedLocales.english
                                ? fontFamilyEnglishName
                                : fontFamilyArabicName,
                            color: kDarkBlueColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem<SampleItem>(
                    value: SampleItem.itemOne,
                    onTap: (){

                      sharingSocialPostLink();
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.share,color: kDarkBlueColor,
                          size: 30,),
                        const SizedBox(width: 10,),
                        CustomText(
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          "Share Link Of The Post",
                          style: TextStyle(
                            shadows: <Shadow>[
                              Shadow(
                                  offset:  const Offset(0.5, 0.5),
                                  blurRadius: 0.5,
                                  color: Colors.black
                                      .withOpacity(0.5)),
                            ],
                            fontSize: 15,
                            letterSpacing: 0,
                            fontFamily: Get.find<StorageService>()
                                .activeLocale ==
                                SupportedLocales.english
                                ? fontFamilyEnglishName
                                : fontFamilyArabicName,
                            color: kDarkBlueColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
                child: InkWell(
                  onTap: (){
                    sharingPost(context);
                  },
                  child: Row(
                    children: [
                      CustomText(
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        'Share',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
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
                      const Icon(Icons.shortcut_outlined ,color: kBlueColor,),


                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  CustomText(
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    'Comment',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
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
                  const Icon(Icons.comment_outlined  ,color: kBlueColor,),


                ],
              ),
              InkWell(
                onTap: (){
                  likingOrDislikingPost();
                },
                child: likedPostOrNot?Row(
                  children: [
                    CustomText(
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      'Unlike',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
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
                    const Icon(Icons.thumb_up_alt_rounded ,color: kBlueColor,),


                  ],
                ):Row(
                  children: [
                    CustomText(
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      'Like',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
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
                    const Icon(Icons.thumb_up_off_alt_outlined ,color: kBlueColor,),


                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5,),
        const Divider(
          color: kYellowColor,
          height: 1,
          thickness: 2,
          endIndent: 10,
          indent: 10,
        ),
        const SizedBox(height: 5,),
        //comments
        isLoadingComment? const CommentLoadingWidget():
    (noCommentsToShow)?Center(
            child:CustomText(
          maxLines: 1,
              Get.find<StorageService>()
                  .activeLocale ==
                  SupportedLocales.english
                  ? " No Comment Yet "
                  :"لا تعليق حتى الآن",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 15,
            letterSpacing: 0,
            fontFamily: Get.find<StorageService>()
                .activeLocale ==
                SupportedLocales.english
                ? fontFamilyEnglishName
                : fontFamilyArabicName,
            color: kBlueColor,

          ),
        )):
        (comments?.length??0)<4?
        Container(
          width: Get.width*0.95,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
             children:  comments!.map<Widget>((e){
                return CommentWidget(commentData: e);
              }).toList(),
          ),
        ):
        Container(
            width: Get.width*0.95,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  shownComments!.map<Widget>((e){
              return CommentWidget(commentData: e);
              }).toList(),
            ),
        ),
        const SizedBox(),
        const SizedBox(height: 5,),
        isLoadingComment?const SizedBox():(noCommentsToShow)?const SizedBox(): ((comments?.length??0)<4)?const SizedBox():
        InkWell(
          onTap: (){
            Get.to(()=>ShowMoreCommentScreen(comments: comments,));
          },
          child: Container(
            width: Get.width,
            child: CustomText(
              textAlign: TextAlign.center,
              maxLines: 1,
              Get.find<StorageService>()
                  .activeLocale ==
                  SupportedLocales.english
                  ? "Show other comments"
                  :"إظهار التعليقات الأخرى",
              style: TextStyle(
                fontWeight: FontWeight.w900,
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
          ),
        ),
        const SizedBox(height: 5,),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: InkWell(
            onTap: () {},
            child: Container(
              constraints: BoxConstraints(
                minHeight: Get.height * 0.07,
              ),
              width: Get.width*0.95,
              decoration:  BoxDecoration(
                borderRadius: BorderRadius.circular(25),
               color: kLightBlueColor
              ),
              child: Row(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: Get.width*0.75,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                      ),

                      child: TextField(
                        controller: commentTextController,
                      cursorColor: kDarkBlueColor,
                      focusNode:     text1FocusNode,
                      autocorrect: false,
                      maxLines: null,

                      keyboardType: TextInputType.multiline,
                      decoration:   InputDecoration(
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            borderSide: BorderSide(width: 1,color:kDarkBlueColor),
                          ),
                          disabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            borderSide: BorderSide(width: 1,color:kDarkBlueColor),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            borderSide: BorderSide(width: 1,color:kDarkBlueColor),
                          ),
                          border: const OutlineInputBorder(
                              borderRadius:  BorderRadius.all(Radius.circular(50)),
                              borderSide: BorderSide(width: 1,color:kDarkBlueColor)
                          ),
                          errorBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                              borderSide: BorderSide(width: 1,color:kDarkBlueColor)
                          ),
                          focusedErrorBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                              borderSide: BorderSide(width: 1,color:kDarkBlueColor)
                          ),
                          hintStyle:  const TextStyle(
                            fontSize: 14,
                            color: kDarkBlueColor,
                          ),
                          suffixIcon: InkWell(
                              onTap: (){
                                if(isSendingComment){
                                  showDialog(context: context,
                                      builder: (context) {
                                        return const LoadingAlertDialogue();
                                      });
                                }else {
                                  addComment(context);
                                }
                              },
                              child: const Icon(Icons.add_comment_outlined,color: kDarkBlueColor,)),
                          hintText:Localizations
                              .localeOf(context)
                              .languageCode == "en"
                              ?  "Write Your Comment"
                              : 'اكتب تعليقك ')
                                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}



enum SampleItem { itemOne, itemTwo, itemThree }