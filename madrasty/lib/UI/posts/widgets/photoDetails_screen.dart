// ignore_for_file: avoid_print, sort_child_properties_last, prefer_is_empty, file_names, empty_statements, depend_on_referenced_packages

import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import '../../../Utils/Colors_File.dart';
import '../../../Utils/constant.dart';
import '../../../Utils/localization_services.dart';
import '../../../Utils/memory.dart';
import '../../../Utils/services.dart';
import '../../../Widgets/custom_text_widget.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:http/http.dart' as http;

import '../../../Widgets/loader.dart';

class PhotoDetailedScreen extends StatefulWidget {
  final List<String?>? link;
  final int? index;
  const PhotoDetailedScreen({super.key,  this.link, this.index});

  @override
  State<PhotoDetailedScreen> createState() => _PhotoDetailedScreenState();
}

class _PhotoDetailedScreenState extends State<PhotoDetailedScreen> {
  int activeIndex = 0;
  SampleItem? selectedItem;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  static const _url = 'https://dosomthings.com/wp-content/uploads/2023/07/How-to-download-and-save-image-to-file-in-FlutterDosomthings.com_-1024x576.png';
  var random = Random();
  getNextImage(){
    if(activeIndex != ((widget.link?.length??0)-1)){
      activeIndex += 1;
      setState((){});
    }
  }
  Future<void> _saveImage(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
     String message = '';

    try {
      // Download image
      final http.Response response = await http.get(
          Uri.parse(_url));

      // Get temporary directory
      final dir = await getTemporaryDirectory();

      // Create an image name
      var filename = '${dir.path}/SaveImage${random.nextInt(100)}.png';

      // Save to filesystem
      final file = File(filename);
      await file.writeAsBytes(response.bodyBytes);

      // Ask the user to save it
      final params = SaveFileDialogParams(sourceFilePath: file.path);
      final finalPath = await FlutterFileDialog.saveFile(params: params);
      print(finalPath);
      if (finalPath != null) {
        message = 'Image saved to gallery';
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
    };
print(message);

  }
  getPreviousImage(){
    if(activeIndex != 0){
      activeIndex -= 1;
      setState((){});
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    activeIndex = (widget.index??0);
    print(activeIndex);
    setState((){});
  }
  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Hero(
                tag: 'imageHero ${widget.index}',
                child: PinchZoom(
                  resetDuration:const Duration(milliseconds: 100000000),
                  child: Center(
                    child: CachedNetworkImage(
                      imageUrl:"${Services.baseUrl}${widget.link?[activeIndex]??""}",
                      imageBuilder: ((context, image) {
                        return Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(

                            width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height,

                            decoration:  BoxDecoration(color: Colors.grey.withValues(alpha:0.5),

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
                                width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height,
                              )),
                        );
                      },
                      errorWidget: (context, url, error) {
                        return Container(
                          width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height,

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
                  maxScale: 3.5,
                  onZoomStart: (){},
                  onZoomEnd: (){print('Stop zooming');},
                ),
              ),
            ),
            Positioned(
                top: 10,
                left: 10,
                child: Row(
                  children: [PopupMenuButton<SampleItem>(
                    icon: const Icon(Icons.keyboard_control_outlined,color: Colors.white,
                      size: 30,),
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
                          _saveImage(context);
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.image,color: kDarkBlueColor,
                              size: 30,),
                            const SizedBox(width: 10,),
                              CustomText(
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              "Save Image",
                              style: TextStyle(
                              shadows: <Shadow>[
                              Shadow(
                              offset:  const Offset(0.5, 0.5),
                              blurRadius: 0.5,
                              color: Colors.black
                                  .withValues(alpha:0.5)),
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

                    const SizedBox(width: 10,),
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child:  const Icon(
                        Icons.clear_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                )),
            widget.index == -1?const SizedBox():Positioned(
              right:10,
              top:15,
              child: Container(
                  width:Get.width*0.2,
                  height:Get.height*0.04,
                  decoration:BoxDecoration(
                    borderRadius:BorderRadius.circular(20),
                    color:Colors.white.withValues(alpha:0.65),
                  ),
                  child:Center(
                    child: Row(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children: [
                        CustomText(
                          "${activeIndex + 1}/${widget.link?.length}",
                          style:  TextStyle(
                            height: 1.3,
                            fontSize: 12,
                            letterSpacing: 0,
                            fontFamily: Get
                                .find<StorageService>()
                                .activeLocale == SupportedLocales.english ?fontFamilyEnglishName:fontFamilyArabicName,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          width:10,
                        ),
                        const Icon(
                          Icons.image,
                          color: Colors.black,
                          size: 17,
                        ),
                      ],
                    ),

                  )
              ),
            ),
            widget.index == -1?const SizedBox():activeIndex != ((widget.link?.length??0)-1)?Positioned(
                top: Get.height*0.45,
                left: 10,
                child: GestureDetector(
                  onTap: (){
                    getNextImage();
                  },
                  child:  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 50,
                  ),
                )):const SizedBox(),
            widget.index == -1?const SizedBox():activeIndex != 0?Positioned(
                top: Get.height*0.45,
                right: 10,
                child: GestureDetector(
                  onTap: (){
                    getPreviousImage();
                  },
                  child:  const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.white,
                    size: 50,
                  ),
                )):const SizedBox(),
          ],
        ),
      ),
    );
  }
}
enum SampleItem { itemOne, itemTwo, itemThree }