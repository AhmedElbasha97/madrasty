// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import '../../../../Utils/Colors_File.dart';
import '../../../../Utils/constant.dart';
import '../../../../Utils/localization_services.dart';
import '../../../../Utils/memory.dart';
import '../../../../Widgets/custom_text_widget.dart';
import '../../../posts/widgets/photoDetails_screen.dart';
import '../../../posts/widgets/video_fullscreen_widget.dart';

class VideoChatWidget extends StatefulWidget {
  const VideoChatWidget({super.key, required this.videoPlayerController, required this.videoPlayer});
  final VideoPlayerController videoPlayerController;
  final String videoPlayer;
  @override
  State<VideoChatWidget> createState() => _VideoChatWidgetState();
}

class _VideoChatWidgetState extends State<VideoChatWidget> {
  var random = Random();
  late SampleItem? selectedItem = SampleItem.itemOne;

  String timePlay = "0:0";
  Timer? timer;
  bool showReplayIcon = false;
  bool showController = false;
  bool showPlayButton = true;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => renewTimeText());
    widget.videoPlayerController.addListener(() {
      checkVideo();
    }) ;

  }
  Future<void> saveVideo(BuildContext context,String url) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    String message = '';

    try {
      // Download image
      final http.Response response = await http.get(
          Uri.parse(url));

      // Get temporary directory
      final dir = await getTemporaryDirectory();

      // Create an image name
      var filename = '${dir.path}/SaveVideo${random.nextInt(100)}.mp4';

      // Save to filesystem
      final file = File(filename);
      await file.writeAsBytes(response.bodyBytes);

      // Ask the user to save it
      final params = SaveFileDialogParams(sourceFilePath: file.path);
      final finalPath = await FlutterFileDialog.saveFile(params: params);
      if (finalPath != null) {
        message = 'Video saved to gallery';
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

  }
  void checkVideo(){
    if (! widget.videoPlayerController.value.isPlaying && widget.videoPlayerController.value.isInitialized &&
        ( widget.videoPlayerController.value.duration == widget.videoPlayerController.value.position)) { //checking the duration and position every time
      showController=false;
      showPlayButton=false;
      showReplayIcon = true;
      setState(() {

      });
    }

  }
  @override
  void dispose() {
    widget.videoPlayerController.dispose();
    timer?.cancel();
    super.dispose();
  }
  showingController(){
    showController = true;
    setState(() {

    });
    Future.delayed(const Duration(seconds: 10), () {

      showController = false;
      if( !widget.videoPlayerController.value.isPlaying && !showReplayIcon){
        showPlayButton = true;
        setState(() {

        });
      }
      setState(() {
        // Here you can write your code for open new view
      });

    });
  }
  renewTimeText()async{
    var time = await  widget.videoPlayerController.position;
    timePlay = "${time?.inMinutes}:${time?.inSeconds}";
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 7.0),
        child: SizedBox(
            child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 2),
                      blurRadius: 6,
                      color: Colors.black12,
                    ),
                  ],
                ),
                child:Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      InkWell(
                        onTap: (){
                          showingController();
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: FittedBox(
                            fit: BoxFit.cover, // Set BoxFit to cover the entire container
                            child: SizedBox(
                                height: Get.height * 0.3,
                                width: Get.width * 0.9,

                                child: VideoPlayer( widget.videoPlayerController)),
                          ),
                        ),
                      ),

                      showController?Positioned(
                          top: 10,
                          left: 10,
                          child: InkWell(
                            onTap: (){
                              widget.videoPlayerController.pause();
                              Get.to(()=>FullScreenVideoPlayerWidget(videoPlayer: widget.videoPlayer,));
                            },
                            child: Container(
                              height: Get.height*0.07,
                              width: Get.width*0.13,
                              decoration:  BoxDecoration(
                                color: Colors.black.withValues(alpha:0.50),
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                boxShadow: const [
                                  BoxShadow(
                                    offset: Offset(0, 2),
                                    blurRadius: 6,
                                    color: Colors.black12,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.fullscreen,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          )):const SizedBox(),
                      showController?Positioned(
                          top: 10,
                          right: 10,
                          child: InkWell(
                            onTap: (){
                              widget.videoPlayerController.pause();
                              Get.to(()=>FullScreenVideoPlayerWidget(videoPlayer: widget.videoPlayer,));
                            },
                            child: Container(
                              height: Get.height*0.07,
                              width: Get.width*0.13,
                              decoration:  BoxDecoration(
                                color: Colors.black.withValues(alpha:0.50),
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                boxShadow: const [
                                  BoxShadow(
                                    offset: Offset(0, 2),
                                    blurRadius: 6,
                                    color: Colors.black12,
                                  ),
                                ],
                              ),
                              child: PopupMenuButton<SampleItem>(
                                icon:const Icon(Icons.keyboard_control,color: kWhiteColor,),
                                initialValue: selectedItem,
                                onSelected: (SampleItem item) {
                                },
                                itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
                                  PopupMenuItem<SampleItem>(
                                    value: SampleItem.itemOne,
                                    onTap: (){saveVideo(context, widget.videoPlayer);
                                    },
                                    child: Row(
                                      children: [
                                        const Icon(Icons.save_alt_outlined,color: kDarkBlueColor,
                                          size: 30,),
                                        const SizedBox(width: 10,),
                                        CustomText(
                                          textAlign: TextAlign.center,
                                          maxLines: 3,
                                          "Save the video",
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
                            ),
                          )):const SizedBox(),
                      showController?Positioned(
                          top: Get.width*0.2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 40,
                              width: Get.width*0.65,

                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                children: [
                                  Container(
                                    height: Get.height*0.07,
                                    width: Get.width*0.13,
                                    decoration:  BoxDecoration(
                                      color: Colors.black.withValues(alpha:0.50),
                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                                      boxShadow: const [
                                        BoxShadow(
                                          offset: Offset(0, 2),
                                          blurRadius: 6,
                                          color: Colors.black12,
                                        ),
                                      ],
                                    ),

                                    child: IconButton(
                                        padding: const EdgeInsets.all(0),
                                        onPressed: (){
                                      showingController();
                                      widget.videoPlayerController.seekTo(Duration(
                                          seconds:  widget.videoPlayerController.value.position.inSeconds - 10));
                                    }, icon: const Icon(Icons.fast_forward,color: Colors.white,)),
                                  ),
                                  Container(
                                    height: Get.height*0.07,
                                    width: Get.width*0.13,
                                    decoration:  BoxDecoration(
                                      color: Colors.black.withValues(alpha:0.50),
                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                                      boxShadow: const [
                                        BoxShadow(
                                          offset: Offset(0, 2),
                                          blurRadius: 6,
                                          color: Colors.black12,
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                        padding: const EdgeInsets.all(0),
                                        onPressed: (){
                                      if( widget.videoPlayerController.value.isPlaying){
                                        widget.videoPlayerController.pause();
                                        showingController();
                                        setState(() {

                                        });
                                      }else{
                                        widget.videoPlayerController.play();
                                        showingController();
                                        setState(() {

                                        });
                                      }
                                    }, icon:  widget.videoPlayerController.value.isPlaying?const Icon(Icons.pause,color: Colors.white,):const Icon(Icons.play_arrow,color: Colors.white,)),
                                  ),
                                  Container(
                                    height: Get.height*0.07,
                                    width: Get.width*0.13,
                                    decoration:  BoxDecoration(
                                      color: Colors.black.withValues(alpha:0.50),
                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                                      boxShadow: const [
                                        BoxShadow(
                                          offset: Offset(0, 2),
                                          blurRadius: 6,
                                          color: Colors.black12,
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                        padding: const EdgeInsets.all(0),
                                        onPressed: (){
                                      showingController();
                                      widget.videoPlayerController.seekTo(Duration(
                                          seconds:  widget.videoPlayerController.value.position.inSeconds + 10));
                                    }, icon: const Icon(Icons.fast_rewind,color: Colors.white,)),
                                  ),

                                ],
                              ),
                            ),
                          )):const SizedBox(),
                      showReplayIcon?InkWell(
                        onTap: (){
                          showReplayIcon = false;
                          showController = true;
                          widget.videoPlayerController.seekTo(Duration.zero);
                          widget.videoPlayerController.play();
                          setState(() {
                          });
                        },
                        child: Center(
                          child: AspectRatio(
                            aspectRatio:   widget.videoPlayerController.value.aspectRatio,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: Get.height*0.1,
                                  width: Get.width*0.2,
                                  decoration:  BoxDecoration(
                                    color: Colors.black.withValues(alpha:0.50),
                                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                                    boxShadow: const [
                                      BoxShadow(
                                        offset: Offset(0, 2),
                                        blurRadius: 6,
                                        color: Colors.black12,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.replay,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ):const SizedBox(),
                      showPlayButton?InkWell(
                        onTap: (){
                          showPlayButton = false;
                          widget.videoPlayerController.play();
                          showingController();
                          setState(() {

                          });
                        },
                        child: Center(
                          child: AspectRatio(
                            aspectRatio:   widget.videoPlayerController.value.aspectRatio,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: Get.height*0.1,
                                  width: Get.width*0.2,
                                  decoration:  BoxDecoration(
                                    color: Colors.black.withValues(alpha:0.50),
                                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                                    boxShadow: const [
                                      BoxShadow(
                                        offset: Offset(0, 2),
                                        blurRadius: 6,
                                        color: Colors.black12,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ):const SizedBox(),
                    ],
                  ),
                )
            )));
  }
}
