// ignore_for_file: avoid_print, unused_local_variable, depend_on_referenced_packages, unnecessary_import, unnecessary_to_list_in_spreads, use_build_context_synchronously

import 'package:carousel_slider/carousel_controller.dart' ;
import 'package:easy_localization/easy_localization.dart' hide StringTranslateExtension;
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as color;
import 'package:flutter/rendering.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:madrasty/Models/response_model.dart';
import 'package:madrasty/Services/attendance_services.dart';
import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:madrasty/Services/perents_services.dart';
import 'package:madrasty/Services/posting_services.dart';
import 'package:madrasty/Services/school_services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' show sin, cos, sqrt, atan2;
import 'package:vector_math/vector_math.dart';
import '../../../Models/class_schedules_model.dart';
import '../../../Models/kids_model.dart';
import '../../../Models/parent_share_model.dart';
import '../../../Models/post_model.dart';
import '../../../Models/school_id_model.dart';
import '../../../Models/student_attenndance_model.dart';
import '../../../Models/student_share_model.dart';
import '../../../Services/class_schedules_services.dart';
import '../../../Utils/constant.dart';
import '../../../Utils/localization_services.dart';
import '../../../Utils/memory.dart';
import '../../../Utils/translation_key.dart';
import '../../../Widgets/alert_dialogue.dart';
import '../../../Widgets/custom_text_widget.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../widget/parent_filtering_screen.dart';
class PerentProfileController extends GetxController {
  List<String> userType = [
    chooseUserKey.tr,
    userType1.tr,
    userType2.tr,
    userType3.tr,
  ];
  String chosenUserType = chooseUserKey.tr;
  List<String> postsTypes = [
    choosePostType.tr,
    postType1.tr,
    postType2.tr,
    postType3.tr,
    postType4.tr,
  ];
  String chosenPostsType = choosePostType.tr;
  StudentShareModel? chosenTeacher;
  ParentShareModel? chosenParent;
  StudentShareModel? chosenStudent;
  List<StudentShareModel>? teacherList = [];
  List<ParentShareModel>? parentList = [];
  List<StudentShareModel>? studentList = [];
  bool filteringData = false;
  List<String> userTaps = [
    parentTap1.tr,
    parentTap2.tr,
    parentTap3.tr,
    parentTap4.tr,
    parentTap6.tr,
    parentTap7.tr,
  ];
  var selectedStartDateVal = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day-7);
  var selectedEndDateVal = DateTime.now();
  bool isAttendanceTableLoading = true;
  List<StudentAttendanceModel>? attendanceTable = [];
  GlobalKey previewAttendanceContainer = GlobalKey();

  List<bool> cancelsClass = [];
  var random = Random();
  GlobalKey previewContainer = GlobalKey();
  String noteOfVacation="";
  String selectedPostType = "";
  late PostModel? postData;
  late SchoolIdModel? schoolId;
  List<StudentShareModel>? listPostTypes = [];
  late StudentShareModel? chosenPostType;
  bool isLoadingPostsTypes = true;

  List<DataRow> listOfRowsSchedules =[];
  bool postIsLoading = true;
  int pageNumber = 1;
  bool isLoadingMoreDataForPosts = false;
  bool isLoading = true;
  String chosenUserTap = parentTap1.tr;
  int chosenUserTapIndicator = 0;
  int current = 0;
  List<Widget> dotsList = [];
  List? child;
  final CarouselSliderController controller = CarouselSliderController();
  LatLng positionFromMap = const LatLng(0.0, 0.0);
  bool mapIsLoading = true;
  late GoogleMapController mapController;
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  String googleApikey = "AIzaSyBr4gzBhTiKovqTAgfV0e0Ygh5SY6DWB2k";
  late LatLng position;
  int _markerIdCounter = 1;
  String previousMarkerId = "";
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  bool isSchedulesLoading = true;
  late ClassSchedulesModel? dataClass;

  int chosenTap = 0;
  List<KidsModel>? kidsData = [];
  late KidsModel? chosenKids;
  late List<Post>? postsListData;
  ScrollController scrollController = ScrollController();
  bool isVisible = false;
  List<ParentShareModel>? peopleShareList = [];
  double earthRadius = 6371000;
  @override
  onInit() {
    super.onInit();
    getKidsData();
    _getCurrentLocation();

    scrollController.addListener(() {
      if ((scrollController.position.pixels ) == (scrollController.position.maxScrollExtent)) {
        print(scrollController.position.pixels);
        print(scrollController.position.maxScrollExtent);

        if(filteringData){
         getMoreFilteredData();
        }else {
          getMoreData();
        }
        update();
      }
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (isVisible == true) {
          isVisible = false;
          update();
        }
      } else {
        if (scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (isVisible == false) {
            isVisible = true;
            update();
          }
        }
      }
    });

  }
  Future<void> launchMap(double latitude, double longitude) async {
    Uri uri;

    if (Platform.isAndroid) {
      uri = Uri.parse('geo:$latitude,$longitude?q=$latitude,$longitude');
    } else {
      uri = Uri.parse('comgooglemaps://?q=$latitude,$longitude');
    }

    final fallbackUri = Uri(
      scheme: "https",
      host: "maps.google.com",
      queryParameters: {'q': '$latitude, $longitude'},
    );

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        await launchUrl(fallbackUri);
      }
    } catch (e) {
      await launchUrl(fallbackUri);
      debugPrint(e.toString());
    }
  }
  getClassSchedules() async {
    isSchedulesLoading = true;
    update();
    dataClass =await ClassSSchedulesServices.getClassTableList("${schoolId?.school??0}", "${schoolId?.schoolIdModelClass??0}");
    dataClass?.header?.removeAt(0);

    initiateClassTable();
    isSchedulesLoading = false;
    update();
  }
  choosingAnotherKid(KidsModel choosedKid) async {
    chosenKids = choosedKid;
    await Get.find<StorageService>().saveSchoolId("${chosenKids?.school?.id??0}");

    getSchoolId();
    choosingUserTap(chosenUserTap);
    update();
  }
  showFilteringScreen(BuildContext context, ) async {
  Navigator.of(context).push(createDrawerRoute());
  List<StudentShareModel>? teacherDataList =await PostingServices.getTeacherShareList("${schoolId?.school??0}");
  teacherList = [];
  for(StudentShareModel? teacher in teacherDataList??[] ) {


    if(teacher?.id == chosenPostType?.id){
      teacherList?.add(teacher!);

    }
  }
  parentList =await PostingServices.getParentShareList("${schoolId?.school??0}","${schoolId?.schoolIdModelClass??0}");
  studentList =await PostingServices.getStudentShareList("${schoolId?.school??0}","${schoolId?.schoolIdModelClass??0}");
}
  Route createDrawerRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const ParentSlidingFilterScreen(),
      opaque: false, // Allows content behind the drawer to remain visible
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0); // Start from the left
        const end = Offset.zero; // End at the current position
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
  initiateClassTable(){

    listOfRowsSchedules = [];
    for (int index =0; index < (dataClass?.rows?.length??0); index++){
      if( dataClass?.rows?[index].classOfTheDay?.length == 1){
        noteOfVacation = "$noteOfVacation \n ${dataClass?.rows?[index].day??""} : ${dataClass?.rows?[index].classOfTheDay?[0].subject}";
      } else{
        listOfRowsSchedules.add(DataRow(
            cells: [

              DataCell(
                  Center(
                    child: CustomText(
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      dataClass?.rows?[index].day??"",
                      style: TextStyle(
                        shadows: <Shadow>[
                          Shadow(
                              offset: const Offset(0.5, 0.5),
                              blurRadius: 0.5,
                              color:
                              color.Colors.black.withValues(alpha:0.5)),
                        ],
                        fontSize: 13,
                        letterSpacing: 0,
                        fontFamily: Get
                            .find<StorageService>()
                            .activeLocale ==
                            SupportedLocales.english
                            ? fontFamilyEnglishName
                            : fontFamilyArabicName,
                        color: color.Colors.white,
                      ),
                    ),
                  )
              ),
              ...dataClass!.rows![index].classOfTheDay!.map((e) {
                return DataCell(
                  Center(
                    child: CustomText(
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      '''${e.subject} \n ${e.teacher}''',
                      style: TextStyle(
                        shadows: <Shadow>[
                          Shadow(
                              offset: const Offset(0.5, 0.5),
                              blurRadius: 0.5,
                              color:
                              color.Colors.black.withValues(alpha:0.5)),
                        ],
                        fontSize: 13,
                        letterSpacing: 0,
                        fontFamily: Get
                            .find<StorageService>()
                            .activeLocale ==
                            SupportedLocales.english
                            ? fontFamilyEnglishName
                            : fontFamilyArabicName,
                        color: color.Colors.white,
                      ),
                    ),
                  ),
                );
              })
            ]
        ));
      }

    }

    update();

  }
  Future<void> saveTheClassSchedules(BuildContext context) {
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
      File imgFile = File('$directory/weekly schedules${DateFormat('yMMMMEEEEd').format(DateTime.now())}.png');
      imagePaths.add(imgFile.path);
      imgFile.writeAsBytes(pngBytes).then((value) async {


        // Ask the user to save it
        final params = SaveFileDialogParams(sourceFilePath: imgFile.path);
        final finalPath = await FlutterFileDialog.saveFile(params: params);
        if (finalPath != null) {
          message = 'class schedules saved to gallery';
          scaffoldMessenger.showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check,color: color.Colors.white,
                      size: 20,),
                    const SizedBox(width: 20,),
                    Text(
                      message,
                      style:  const TextStyle(
                        fontSize: 12,
                        color: color.Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                backgroundColor:color.Colors.green,
              ));
        }
      }).catchError((onError) {
        message = onError.toString();
        scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.close,color: color.Colors.white,
                    size: 20,),
                  const SizedBox(width: 20,),
                  Text(
                    message,
                    style:  const TextStyle(
                      fontSize: 12,
                      color: color.Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              backgroundColor:color.Colors.red,
            ));
      });
    });
  }
  Future<void> generateStyledPdf(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    String message = '';

    final pdf = pw.Document();
    List<String>? headers = [];
    List<List<String>? >data = [];
    // Define table headers and data
    for(int i = 0; i<=(dataClass?.header?.length??0);i++){
      if(i==0){
        headers.add(Get.find<StorageService>().activeLocale ==
            SupportedLocales.english
            ?"day \n class ":'''الحصص \n اليوم''');
      }else{
        headers.add(dataClass!.header![i-1]);
      }
    }
    for(int i = 0; i<(dataClass?.rows?.length??0);i++){
      List<String> row = [];
      row.add(dataClass?.rows?[i].day??"");
      for(int e = 0; e < (dataClass?.rows?[i].classOfTheDay?.length??0)-1;e++){
        if(dataClass?.rows?[i].classOfTheDay?[e].subject?.isNotEmpty??false) {
          row.add('''${dataClass?.rows?[i].classOfTheDay?[e].subject ??
              ""} \n ${dataClass?.rows?[i].classOfTheDay?[e].teacher ?? ""}''');
        }else{
          row.add("ملغى");
        }
        }
      data.add(row);
    }
    final  font = await rootBundle.load('assets/fonts/Bahij_TheSansArabic-Plain.ttf');
    final  ttf = pw.Font.ttf(font);
    final  fontRegular = await rootBundle.load('assets/fonts/Bahij TheSansArabic.ttf');
    final  ttfRegular = pw.Font.ttf(fontRegular);
    // Load images for logo and QR codes
    final logoImage =  pw.MemoryImage(
      (await rootBundle.load(Get.find<StorageService>().activeLocale ==
          SupportedLocales.english
          ? 'assets/images/appMultiColorLogoEnWithoutbackground.png'
          : 'assets/images/appMultiColorLogoArWithoutbackground.png',)).buffer.asUint8List(),
    ); // Replace with your logo image

    final appStoreQr = pw.MemoryImage(
      (await rootBundle.load('assets/images/apple-qr-code.png',)).buffer.asUint8List(),
    ); // Replace with your App Store QR code
    final googlePlayQr = pw.MemoryImage(
      (await rootBundle.load('assets/images/android-qr-code.png',)).buffer.asUint8List(),
    );
    // Add page with the table
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return  pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // Title
              pw.Text(
                'جدول الدراسه',
                textDirection:pw.TextDirection.rtl,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontSize: 18,
                  color: PdfColors.blue800,
                  font: ttf,
                ),
              ),
              pw.SizedBox(height: 10), // Add spacing below the title
              pw.Text(
                'للطالب: ${chosenKids?.name??""}',
                textDirection:pw.TextDirection.rtl,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontSize: 18,
                  color: PdfColors.blue800,
                  font: ttf,
                ),
              ),
              pw.SizedBox(height: 10),
              // Table with rounded corners
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  borderRadius: pw.BorderRadius.circular(10),
                  color: PdfColors.blue800,
                  border: pw.Border.all(color: PdfColors.yellow, width: 2),
                ),
                child: pw.Column(
                  children: [
                    // Header Row
                    pw.Container(
                      decoration: const pw.BoxDecoration(
                        color: PdfColors.blue900,
                        borderRadius: pw.BorderRadius.only(
                          topLeft: pw.Radius.circular(8),
                          topRight: pw.Radius.circular(8),
                        ),
                      ),
                      child: pw.Row(
                        children: headers.map((header) {
                          return pw.Expanded(
                            child: pw.Container(
                              alignment: pw.Alignment.center,
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(
                                header,
                                textDirection:pw.TextDirection.rtl,
                                textAlign: pw.TextAlign.center,
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  color: PdfColors.white,
                                  font: ttf,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    // Data Rows
                    ...data.map((row) {
                      return pw.Container(
                        decoration: pw.BoxDecoration(
                          color: PdfColors.blue700,
                          borderRadius: data.last == row
                              ? const pw.BorderRadius.only(
                            bottomLeft: pw.Radius.circular(8),
                            bottomRight: pw.Radius.circular(8),
                          )
                              : null,
                        ),
                        child: pw.Row(
                          children: row!.map((cell) {
                            return pw.Expanded(
                              child: pw.Container(

                                alignment: pw.Alignment.center,
                                padding: const pw.EdgeInsets.all(8),
                                child: pw.Text(
                                  cell,
                                  textDirection:pw.TextDirection.rtl,
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                    fontSize: 10,
                                    color: PdfColors.white,
                                    font: ttfRegular,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
              pw.SizedBox(height: 10), //
              pw.Container(

                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  borderRadius: pw.BorderRadius.circular(20),
                  color: PdfColors.white,
                  border: pw.Border.all(color: PdfColors.blue800, width: 2),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    // App Logo
                    pw.Image(logoImage, width: 50, height: 50),
                    // QR Codes
                    pw.Row(
                      children: [
                        pw.Column(
                          children: [
                            pw.Text(
                              'App Store',
                              style: const pw.TextStyle(
                                fontSize: 10,
                                color: PdfColors.blue800,
                              ),
                            ),
                            pw.Image(appStoreQr, width: 50, height: 50),
                          ],
                        ),
                        pw.SizedBox(width: 10),
                        pw.Column(
                          children: [
                            pw.Text(
                              'Google Play',
                              style: const pw.TextStyle(
                                fontSize: 10,
                                color: PdfColors.blue800,
                              ),
                            ),
                            pw.Image(googlePlayQr, width: 50, height: 50),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    // Save the PDF file to the device
    final directory = (await getApplicationDocumentsDirectory()).path;
    File file = File('$directory/weekly schedules${DateFormat('yMMMMEEEEd').format(DateTime.now())}.pdf');

    file.writeAsBytes(await pdf.save()).then((value) async {
      // Ask the user to save it
      final params = SaveFileDialogParams(sourceFilePath: file.path);
      final finalPath = await FlutterFileDialog.saveFile(params: params);
      if (finalPath != null) {
        message = 'class table saved to Download';
        scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check,color: color.Colors.white,
                    size: 20,),
                  const SizedBox(width: 20,),
                  Text(
                    message,
                    style:  const TextStyle(
                      fontSize: 12,
                      color: color.Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              backgroundColor:color.Colors.green,
            ));
      }
    }).
    catchError((onError) {
      message = onError.toString();
      scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.close,color:color.Colors.white,
                  size: 20,),
                const SizedBox(width: 20,),
                Text(
                  message,
                  style:  const TextStyle(
                    fontSize: 12,
                    color: color.Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            backgroundColor:color.Colors.red,
          ));
    });


    print("PDF saved to ${file.path}");
  }

  goUpToTopOfSScreen(){
    scrollController.animateTo( //go to top of scroll
        0,  //scroll offset to go
        duration: const Duration(milliseconds: 500), //duration of scroll
        curve:Curves.fastOutSlowIn //scroll type
    );
    isVisible = false;
    update();
  }

  choosingTap(int index) {
    chosenTap = index;

    update();
  }

  sendingOrReceivingKid(String type,String kidId,BuildContext context,) async {
  ResponseModel? data = await AttendanceServices.sendingOrReceivingKidFromSchool(kidId, type);
  if (data?.status == "true") {
    final snackBar = SnackBar(content:
    Row(children: [
      const Icon(Icons.check, color: color.Colors.white,),
      const SizedBox(width: 10,),
      Text(Get
          .find<StorageService>()
          .activeLocale ==
          SupportedLocales.english
          ? type == "0"?'The student was successfully delivered to the school':'The student was successfully received from the school'
          : type == "0"?'تم تسليم الطالب للمدرسه بنجاح':'تم أستلام الطالب من المدرسه بنجاح', style: const TextStyle(
          color: color.Colors.white,
          fontWeight: FontWeight.bold
      ),
      ),
    ],),
        backgroundColor: color.Colors.green
    );
    isLoading = false;
    update();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  else {
    isLoading = false;
    update();
    final snackBar = SnackBar(content:
    Row(children: [
      const Icon(Icons.close, color: color.Colors.white,),
      const SizedBox(width: 10,),
      Text(Get
          .find<StorageService>()
          .activeLocale ==
          SupportedLocales.english
          ? data?.msg??""
          : data?.msgAr??"", style: const TextStyle(
          color: color.Colors.white,
          fontWeight: FontWeight.bold
      ),
      ),
    ],),
        backgroundColor: color.Colors.red
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  }
//Using pLat and pLng as dummy location
sendingKidToSchool(double pLng,double pLat,BuildContext context,String kidId){
  if( getDistance( pLng,pLat) <= 1000){
    sendingOrReceivingKid("1",kidId,context);
  }else{
    showDialog(context: context,
        builder: (context) {
      return AlertDialogue(alertTitle: errorKey.tr, alertText: sendingKidErrorKey.tr,alertIcon: "assets/icons/warningIcon.png",containerHeight:  Get.height*0.4);
    });
  }
}
receivingKidFromSchool(double pLng,double pLat,BuildContext context,String kidId){
  if( getDistance( pLng,pLat) <= 1000){
    sendingOrReceivingKid("0",kidId,context);
  }else{
    showDialog(context: context,
        builder: (context) {
      return AlertDialogue(alertTitle: errorKey.tr, alertText:receivingKidErrorKey.tr,alertIcon: "assets/icons/warningIcon.png",containerHeight:  Get.height*0.4);
    });
  }
}
//Calculating the distance between two points
  getDistance(double pLng,double pLat){
    var dLat = radians(pLat - position.latitude);
    var dLng = radians(pLng - position.longitude);
    var a = sin(dLat/2) * sin(dLat/2) + cos(radians(position.latitude))
        * cos(radians(pLat)) * sin(dLng/2) * sin(dLng/2);
    var c = 2 * atan2(sqrt(a), sqrt(1-a));
    var d = earthRadius * c;
    return d;//d is the distance in meters
  }
  getNextTap() {
    if (userTaps.length - 3 > chosenUserTapIndicator) {
      print(userTaps.length - 2);
      chosenUserTapIndicator = chosenUserTapIndicator + 1;
      update();
    }
  }
  choosingUserTap(String tapName) {
    chosenUserTap = tapName;
    if(chosenUserTap == parentTap6.tr){
      getPostTypes();
    }else  if(chosenUserTap == parentTap3.tr){
      getClassSchedules();
    }else  if(chosenUserTap == parentTap1.tr){
      getClassSchedules();
    }
    update();
  }
  getPreviousTap() {
    if (chosenUserTapIndicator > 0) {
      chosenUserTapIndicator = chosenUserTapIndicator - 1;
      update();
    }
  }
  getKidsData() async {
    kidsData = [];
    kidsData = await ParentServices.getKidsList();
    chosenKids = kidsData?[0];
    await Get.find<StorageService>().saveSchoolId("${kidsData?[0].school?.id??0}");

    getSchoolId();
    isLoading = false;
    update();
  }

  void _getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    Position res = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    position = LatLng(res.latitude, res.longitude);
    _createMarker();
  }
  _createMarker() {
    print("create Marker$position");
    add(position.latitude, position.longitude);
  }
  add(double lat, double lang) {
    print("_add$lang$lat");
    final String markerIdVal = 'marker_id_$_markerIdCounter';
    previousMarkerId = markerIdVal;
    _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(lat, lang),
    );
    position = LatLng(lat, lang);

    markers[markerId] = marker;
    mapIsLoading = false;
    update();
  }
  getSchoolId() async {

    schoolId = await SchoolServices.getSchoolsId("${chosenKids?.id??0}");
    update();
  }
  //posts---------------------------------------------------------------------------------
  getPostTypes() async {
    isLoadingPostsTypes = true;
    update();
   listPostTypes = await PostingServices.getSubjectsList("${schoolId?.school??0}");
   chosenPostType = listPostTypes?[0];
   getPostData();
    isLoadingPostsTypes = false;
    update();
  }
  choosingPostType(StudentShareModel? choosedPostType){
    chosenPostType = choosedPostType;
    postsListData = [];
    getPostData();
    update();
  }
  getPostData() async {
  postIsLoading = true;

  pageNumber = 1;
  update();
  peopleShareList = await PostingServices.getParentShareList("${schoolId?.school??0}", "${schoolId?.schoolIdModelClass??0}");
  postData = await PostingServices.getPostsList("${schoolId?.school??0}", "${schoolId?.schoolIdModelClass??0}", "$pageNumber","${chosenPostType?.id??0}");
  postsListData = postData?.posts;
  postIsLoading = false;
  update();
  }
  getMoreData() async {
    if(postData!.totalPages! > pageNumber ) {
      pageNumber++;
      isLoadingMoreDataForPosts= true;
      update();
      postData = await PostingServices.getPostsList("${schoolId?.id??0}", "${schoolId?.schoolIdModelClass??0}", "$pageNumber","${chosenPostType?.id??0}");
      for(Post post in postData!.posts!){
        postsListData?.add(post);
      }
      isLoadingMoreDataForPosts = false;
      update();
    }
  }
  //filtering posts----------------------------------------------------------------------------
  chooseUserType(String userType){
    chosenUserType = userType;
    chosenParent = null;
    chosenStudent = null;
    chosenTeacher = null;
    update();
  }
  choosedPostType(String postType){
    chosenPostsType = postType;
    update();
  }
  choosedTeacher(StudentShareModel choosedTeacher){
    chosenTeacher = choosedTeacher;
    update();
  }
  choosedParent(ParentShareModel choosedParent){
    chosenParent = choosedParent;
    update();
  }
  choosedStudent(StudentShareModel choosedStudent){
    chosenStudent = choosedStudent;
    update();
  }
  filteringPostsData() async {
    postIsLoading = true;
    filteringData = true;
    pageNumber = 1;
    update();
    peopleShareList = await PostingServices.getParentShareList("${schoolId?.school??0}", "${schoolId?.schoolIdModelClass??0}");
     postData = await PostingServices.getPostsListAfterFiltering("${schoolId?.school??0}", "${schoolId?.schoolIdModelClass??0}", "$pageNumber","${chosenPostType?.id??0}","${chosenUserType == userType2.tr?chosenTeacher?.id??0
         :chosenUserType == userType1.tr?chosenParent?.id??0:
     chosenUserType == userType3.tr?chosenStudent?.id??0:0}",
         chosenUserType==chooseUserKey.tr?"0":chosenUserType,
         chosenPostsType==choosePostType.tr?"0":chosenPostsType);
    postsListData = postData?.posts;
    Get.back();
    postIsLoading = false;
    update();
  }
  getMoreFilteredData() async {
    if(postData!.totalPages! > pageNumber ) {
      pageNumber++;
      isLoadingMoreDataForPosts= true;
      update();
      postData =  await PostingServices.getPostsListAfterFiltering("${schoolId?.school??0}", "${schoolId?.schoolIdModelClass??0}", "$pageNumber","${chosenPostType?.id??0}","${chosenUserType == userType2.tr?chosenTeacher?.id??0
          :chosenUserType == userType1.tr?chosenParent?.id??0:
      chosenUserType == userType3.tr?chosenStudent?.id??0:0}",
          chosenUserType==chooseUserKey.tr?"0":chosenUserType,
          chosenPostsType==choosePostType.tr?"0":chosenPostsType);
      for(Post post in postData!.posts!){
        postsListData?.add(post);
      }
      isLoadingMoreDataForPosts = false;
      update();
    }
  }
  clearAllTheFilters(){
    filteringData = false;
    chosenUserType = chooseUserKey.tr;
    chosenPostsType = choosePostType.tr;
    pageNumber = 1;
    chosenParent = null;
    chosenStudent = null;
    chosenTeacher = null;
    Get.back();
    getPostData();
  }
  //attendance table --------------------------------------------------------------------------
  getAttendanceTable() async {
    isAttendanceTableLoading = true;
    update();
    final newFormatter = DateFormat("dd-MM-yyyy");

    attendanceTable = await AttendanceServices.getStudentAttendanceTableList("${chosenKids?.school?.id??0}", "${chosenKids?.id??0}", newFormatter.format(selectedStartDateVal), newFormatter.format(selectedEndDateVal));
    isAttendanceTableLoading = false;
    update();
  }
  getFormatedDate( date) {
    const data = "27-10-2022 11:02:50";
    final format = DateFormat("dd-MM-yyyy HH:mm:ss");
    // final DateTime result = format.parse(date);
    print(date);
    // print(result);
    final newFormatter = DateFormat("EEEE: dd-MM-yyyy");
    return  newFormatter.format(date);
  }
  selectingStartDate(BuildContext context) async {

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day-8),
      firstDate: DateTime(DateTime.now().year-1),
      lastDate: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day-1),);
    update();
    if (pickedDate != null) {
      selectedStartDateVal = pickedDate;
      update();
    } else {}

  }
  selectingEndDate(BuildContext context) async {

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate:  DateTime.now(),
      firstDate: DateTime(selectedStartDateVal.year-1),
      lastDate: DateTime.now(),);
    update();
    if (pickedDate != null) {
      selectedEndDateVal = pickedDate;
      update();
    } else {}

  }
  formattingTimmeToAmAndPmFormat(String time){
    return DateFormat.jm().format(DateFormat("hh:mm:ss").parse(time));
  }
  getFormatedTableDate( date) {
    const data = "27-10-2022 11:02:50";
    final format = DateFormat("dd-MM-yyyy HH:mm:ss");
    // final DateTime result = format.parse(date);
    print(date);
    // print(result);
    final newFormatter = DateFormat("EEEE: dd-MM-yyyy");
    return  newFormatter.format(DateFormat("yyyy-MM-dd").parse(date));
  }
  Future<void> saveTheAttendanceTable(BuildContext context) {
    List<String> imagePaths = [];
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    String message = '';
    final RenderBox box = context.findRenderObject() as RenderBox;
    return Future.delayed(const Duration(milliseconds: 20), () async {
      RenderRepaintBoundary? boundary = previewAttendanceContainer.currentContext!
          .findRenderObject() as RenderRepaintBoundary?;
      ui.Image image = await boundary!.toImage();

      final directory = (await getApplicationDocumentsDirectory()).path;
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      File imgFile = File('$directory/attendance table${DateFormat('yMMMMEEEEd').format(DateTime.now())}.png');
      imagePaths.add(imgFile.path);
      imgFile.writeAsBytes(pngBytes).then((value) async {


        // Ask the user to save it
        final params = SaveFileDialogParams(sourceFilePath: imgFile.path);
        final finalPath = await FlutterFileDialog.saveFile(params: params);
        if (finalPath != null) {
          message =  Get.find<StorageService>().activeLocale ==
              SupportedLocales.english
              ?'تم حفظ جدول الحضور في المعرض':'attendance table saved to gallery';
          scaffoldMessenger.showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check,color: color.Colors.white,
                      size: 20,),
                    const SizedBox(width: 20,),
                    Text(
                      message,
                      style:  const TextStyle(
                        fontSize: 12,
                        color: color.Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                backgroundColor:color.Colors.green,
              ));
        }
      }).catchError((onError) {
        message = onError.toString();
        scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.close,color:color.Colors.white,
                    size: 20,),
                  const SizedBox(width: 20,),
                  Text(
                    message,
                    style:  const TextStyle(
                      fontSize: 12,
                      color: color.Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              backgroundColor:color.Colors.red,
            ));
      });
    });
  }
  Future<void> generateAttendanceStyledPdf(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    String message = '';

    final pdf = pw.Document();

    final  font = await rootBundle.load('assets/fonts/Bahij_TheSansArabic-Plain.ttf');
    final  ttf = pw.Font.ttf(font);
    final  fontRegular = await rootBundle.load('assets/fonts/Bahij TheSansArabic.ttf');
    final  ttfRegular = pw.Font.ttf(fontRegular);
    // Load images for logo and QR codes
    final logoImage =  pw.MemoryImage(
      (await rootBundle.load(Get.find<StorageService>().activeLocale ==
          SupportedLocales.english
          ? 'assets/images/appMultiColorLogoEnWithoutbackground.png'
          : 'assets/images/appMultiColorLogoArWithoutbackground.png',)).buffer.asUint8List(),
    ); // Replace with your logo image

    final appStoreQr = pw.MemoryImage(
      (await rootBundle.load('assets/images/apple-qr-code.png',)).buffer.asUint8List(),
    ); // Replace with your App Store QR code
    final googlePlayQr = pw.MemoryImage(
      (await rootBundle.load('assets/images/android-qr-code.png',)).buffer.asUint8List(),
    );
    final attendanceIcon = pw.MemoryImage(
      (await rootBundle.load("assets/icons/wrightIcon.png",)).buffer.asUint8List(),);
    final leaveIcon = pw.MemoryImage(
      (await rootBundle.load("assets/icons/wrongIcon.png",)).buffer.asUint8List(),);

    // Add page with the table
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return  pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // Title
              pw.Text(
                'جدول الحضور و الغياب',
                textDirection:pw.TextDirection.rtl,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontSize: 18,
                  color: PdfColors.blue800,
                  font: ttf,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'بدايه من: ${getFormatedDate(selectedStartDateVal)}',
                textDirection:pw.TextDirection.rtl,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontSize: 18,
                  color: PdfColors.blue800,
                  font: ttf,
                ),
              ), pw.SizedBox(height: 10),
              pw.Text(
                'ألى: ${getFormatedDate(selectedEndDateVal)}',
                textDirection:pw.TextDirection.rtl,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontSize: 18,
                  color: PdfColors.blue800,
                  font: ttf,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'للطالب: ${chosenKids?.name??""}',
                textDirection:pw.TextDirection.rtl,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontSize: 18,
                  color: PdfColors.blue800,
                  font: ttf,
                ),
              ),
              pw.SizedBox(height: 10), // Add spacing below the title

              // Table with rounded corners
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  borderRadius: pw.BorderRadius.circular(10),
                  color: PdfColors.blue800,
                  border: pw.Border.all(color: PdfColors.yellow, width: 2),
                ),
                child: pw.Column(
                  children: [
                    // Header Row
                    pw.Container(
                      decoration: const pw.BoxDecoration(
                        color: PdfColors.blue900,
                        borderRadius: pw.BorderRadius.only(
                          topLeft: pw.Radius.circular(8),
                          topRight: pw.Radius.circular(8),
                        ),
                      ),
                      child: pw.Row(
                        children: [
                          pw.Expanded(
                            child: pw.Container(
                              alignment: pw.Alignment.center,
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(
                                Get.find<StorageService>().activeLocale ==
                                    SupportedLocales.english
                                    ?'Day Date':"تاريخ اليوم",
                                textDirection:pw.TextDirection.rtl,
                                textAlign: pw.TextAlign.center,
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  color: PdfColors.white,
                                  font: ttf,
                                ),
                              ),
                            ),
                          ),
                          pw.Expanded(
                            child: pw.Container(
                              alignment: pw.Alignment.center,
                              padding: const pw.EdgeInsets.all(8),
                              child:pw.Image(attendanceIcon,
                                height:Get.height * 0.04,
                                width: Get.width * 0.05,),

                            ),
                          ),
                          pw.Expanded(
                            child: pw.Container(
                              alignment: pw.Alignment.center,
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(
                                Get.find<StorageService>().activeLocale ==
                                    SupportedLocales.english
                                    ?'attendance':'الحضور',
                                textDirection:pw.TextDirection.rtl,
                                textAlign: pw.TextAlign.center,
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  color: PdfColors.white,
                                  font: ttf,
                                ),
                              ),
                            ),
                          ), pw.Expanded(
                            child: pw.Container(
                              alignment: pw.Alignment.center,
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(
                                Get.find<StorageService>().activeLocale ==
                                    SupportedLocales.english
                                    ?'leave':'الأنصراف',
                                textDirection:pw.TextDirection.rtl,
                                textAlign: pw.TextAlign.center,
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  color: PdfColors.white,
                                  font: ttf,
                                ),
                              ),
                            ),
                          ),pw.Expanded(
                            child: pw.Container(
                              alignment: pw.Alignment.center,
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(
                                Get.find<StorageService>().activeLocale ==
                                    SupportedLocales.english
                                    ?'notes':'ملاحظات',
                                textDirection:pw.TextDirection.rtl,
                                textAlign: pw.TextAlign.center,
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  color: PdfColors.white,
                                  font: ttf,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Data Rows
                    ...attendanceTable!.map((row) {
                      return pw.Container(
                        decoration: pw.BoxDecoration(
                          color: PdfColors.blue700,
                          borderRadius: attendanceTable!.last == row
                              ? const pw.BorderRadius.only(
                            bottomLeft: pw.Radius.circular(8),
                            bottomRight: pw.Radius.circular(8),
                          )
                              : null,
                        ),
                        child: pw.Row(
                          children: [
                            pw.Expanded(
                              child: pw.Container(
                                color: PdfColors.blue700,

                                alignment: pw.Alignment.center,
                                padding: const pw.EdgeInsets.all(8),
                                child: pw.Text(
                                  "${getFormatedTableDate(row.day??0)}",
                                  textDirection:pw.TextDirection.rtl,
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                    fontSize: 10,
                                    color: PdfColors.white,
                                    font: ttfRegular,
                                  ),
                                ),
                              ),
                            ),
                            pw.Expanded(
                              child: pw.Container(
                                color: PdfColors.blue700,

                                alignment: pw.Alignment.center,
                                padding: const pw.EdgeInsets.all(8),
                                child:pw.Image((row.check??0)==1?attendanceIcon:leaveIcon,
                                  height:Get.height * 0.04,
                                  width: Get.width * 0.05,),

                              ),
                            ),
                            pw.Expanded(
                              child: pw.Container(
                                color: PdfColors.blue700,

                                alignment: pw.Alignment.center,
                                padding: const pw.EdgeInsets.all(8),
                                child: pw.Text(
                                  (row.check??0)==1?"${formattingTimmeToAmAndPmFormat(row.studentAttendanceModelIn??"")}":"",                                  textDirection:pw.TextDirection.rtl,
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                    fontSize: 10,
                                    color: PdfColors.white,
                                    font: ttfRegular,
                                  ),
                                ),
                              ),
                            ),
                            pw.Expanded(
                              child: pw.Container(
                                color: PdfColors.blue700,

                                alignment: pw.Alignment.center,
                                padding: const pw.EdgeInsets.all(8),
                                child: pw.Text(
                                  (row.check??0)==1?"${formattingTimmeToAmAndPmFormat(row.out??"")}":"",                                  textDirection:pw.TextDirection.rtl,
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                    fontSize: 10,
                                    color: PdfColors.white,
                                    font: ttfRegular,
                                  ),
                                ),
                              ),
                            ),
                            pw.Expanded(
                              child: pw.Container(
                                color: PdfColors.blue700,

                                alignment: pw.Alignment.center,
                                padding: const pw.EdgeInsets.all(8),
                                child: pw.Text(
                                  row.notes??"",
                                  textDirection:pw.TextDirection.rtl,
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                    fontSize: 10,
                                    color: PdfColors.white,
                                    font: ttfRegular,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              pw.SizedBox(height: 10), //
              pw.Container(

                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  borderRadius: pw.BorderRadius.circular(20),
                  color: PdfColors.white,
                  border: pw.Border.all(color: PdfColors.blue800, width: 2),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    // App Logo
                    pw.Image(logoImage, width: 50, height: 50),
                    // QR Codes
                    pw.Row(
                      children: [
                        pw.Column(
                          children: [
                            pw.Text(
                              'App Store',
                              style: const pw.TextStyle(
                                fontSize: 10,
                                color: PdfColors.blue800,
                              ),
                            ),
                            pw.Image(appStoreQr, width: 50, height: 50),
                          ],
                        ),
                        pw.SizedBox(width: 10),
                        pw.Column(
                          children: [
                            pw.Text(
                              'Google Play',
                              style: const pw.TextStyle(
                                fontSize: 10,
                                color: PdfColors.blue800,
                              ),
                            ),
                            pw.Image(googlePlayQr, width: 50, height: 50),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    // Save the PDF file to the device
    final directory = (await getApplicationDocumentsDirectory()).path;
    File file = File('$directory/attendance Table${DateFormat('yMMMMEEEEd').format(DateTime.now())}.pdf');

    file.writeAsBytes(await pdf.save()).then((value) async {
      // Ask the user to save it
      final params = SaveFileDialogParams(sourceFilePath: file.path);
      final finalPath = await FlutterFileDialog.saveFile(params: params);
      if (finalPath != null) {
        message = 'class table saved to Download';
        scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check,color: color.Colors.white,
                    size: 20,),
                  const SizedBox(width: 20,),
                  Text(
                    message,
                    style:  const TextStyle(
                      fontSize: 12,
                      color: color.Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              backgroundColor:color.Colors.green,
            ));
      }
    }).
    catchError((onError) {
      message = onError.toString();
      scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.close,color:color.Colors.white,
                  size: 20,),
                const SizedBox(width: 20,),
                Text(
                  message,
                  style:  const TextStyle(
                    fontSize: 12,
                    color: color.Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            backgroundColor:color.Colors.red,
          ));
    });


    print("PDF saved to ${file.path}");
  }
}
