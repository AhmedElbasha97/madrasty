// ignore_for_file: unnecessary_to_list_in_spreads, use_build_context_synchronously, prefer_is_empty

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madrasty/UI/web_view/web_view_screen.dart';

import '../../../Models/attendance_table_model.dart';
import '../../../Models/class_schedules_model.dart';
import '../../../Models/class_teacher_model.dart';
import '../../../Models/response_model.dart';
import '../../../Models/student_share_model.dart';
import '../../../Models/teacher_info_model.dart';
import '../../../Services/attendance_services.dart';
import '../../../Services/class_schedules_services.dart';
import '../../../Services/teacher_services.dart';
import '../../../Utils/Colors_File.dart';
import '../../../Utils/constant.dart';
import '../../../Utils/localization_services.dart';
import '../../../Utils/memory.dart';
import '../../../Utils/translation_key.dart';
import '../../../Widgets/alert_dialogue.dart';
import '../../../Widgets/custom_text_widget.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart' hide StringTranslateExtension;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../Widgets/loading_alert_dialogue.dart';
class SupervisorProfileController extends GetxController{
  List<String> userTaps = [
    parentTap1.tr,
    parentTap3.tr,
    parentTap7.tr,
  ];
  int chosenUserTapIndicator = 0;
  String chosenUserTap = parentTap1.tr;
  late List<StudentShareModel>? peopleShareList;

  TeacherInfoModel? teacherData;
  List<ClassTeacherModel>? teacherStages ;
  ClassTeacherModel? chosenStage;
  List<ClassTeacherModel>? teacherSubStage;
  ClassTeacherModel? chosenSubStage;
  List<ClassTeacherModel>? teacherClass;
  ClassTeacherModel? chosenClass;
  ClassSchedulesModel? classScheduleData;
  bool isTeacherProfileDataIsLoading = true;
  bool isClassLoading = true;
  bool classSchedulesIsLoading = true;
  bool classSchedulesIsEmpty = false;
  List<DataRow> listOfRowsSchedules =[];
  List<AttendanceTableModel>? attendanceTable = [];
  Class? selectedPostType;
  GlobalKey previewContainer = GlobalKey();
  GlobalKey previewAttendanceContainer = GlobalKey();
  List<Class>? postsTypesListData=[
  ];
  String noteOfVacation = "";
  bool classIsLoading = true;
  bool subStageIsLoading = true;
  var leaveTimeVal = TimeOfDay.fromDateTime(DateTime.now());
  var arrivalTimeVal = TimeOfDay.fromDateTime(DateTime.now());
  var selectedDateVal = DateTime.now();


  bool attendanceSchedulesIsEmpty = false;
  bool isSendingRecommendation = false;
  bool schedulesIsLoadingTable = true;
  bool  editingNotesIsLoading = false;
  bool  editingArrivalOrLeavingTimeIsLoading = false;
  bool  editingArrivalOrLeavingIsLoading = false;


  @override
  onInit() {
    super.onInit();
    getSupervisorData();
  }
//taps function
  getNextTap() {
    if (userTaps.length - 3 > chosenUserTapIndicator) {
      chosenUserTapIndicator = chosenUserTapIndicator + 1;
      update();
    }
  }

  choosingUserTap(String tapName) {
    chosenUserTap = tapName;
    if(tapName ==  parentTap1.tr){
      chosenStage = null;
      chosenSubStage = null;
      chosenClass = null;
      attendanceTable = [];
    }
    if(tapName ==  parentTap3.tr){
      chosenStage = null;
      chosenSubStage = null;
      chosenClass = null;
      listOfRowsSchedules = [];
      classScheduleData = null;
    }
    update();
  }

  getPreviousTap() {
    if (chosenUserTapIndicator > 0) {
      chosenUserTapIndicator = chosenUserTapIndicator - 1;
      update();
    }
  }
//supervisor class table function
  //data for stages of school
  getSupervisorData() async {
    teacherData = await TeacherServices.getTeacherInfoData();
    await Get.find<StorageService>().saveSchoolId("${teacherData?.school??0}");

    teacherStages = await TeacherServices.getStagesTeacher("${teacherData?.school??0}");
    isTeacherProfileDataIsLoading = false;
    update();
  }

  getTeacherSubStages() async {
    subStageIsLoading = true;
    update();
    teacherSubStage = await TeacherServices.getClassTeacherModelList("${teacherData?.school??0}", "${chosenStage?.id??0}");
    subStageIsLoading = false;
    update();
  }

  getTeacherClass() async {
    classIsLoading = true;
    update();
    teacherClass = await TeacherServices.getClassTeacherModelList("${teacherData?.school??0}", "${chosenSubStage?.id??0}");

    classIsLoading = false;
    update();
  }

  initiateClassTable(){


    for (int index =0; index < (classScheduleData?.rows?.length??0); index++){
      if( classScheduleData!.rows![index].classOfTheDay?.length == 1){
        noteOfVacation = "$noteOfVacation \n ${classScheduleData!.rows![index].day} : ${classScheduleData!.rows![index].classOfTheDay?.first.subject}";
      } else{
        listOfRowsSchedules.add(DataRow(
            cells: [

              DataCell(
                  Center(
                    child: CustomText(
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      classScheduleData?.rows?[index].day??"",
                      style: TextStyle(
                        shadows: <Shadow>[
                          Shadow(
                              offset: const Offset(0.5, 0.5),
                              blurRadius: 0.5,
                              color:
                              Colors.black.withValues(alpha:0.5)),
                        ],
                        fontSize: 13,
                        letterSpacing: 0,
                        fontFamily: Get
                            .find<StorageService>()
                            .activeLocale ==
                            SupportedLocales.english
                            ? fontFamilyEnglishName
                            : fontFamilyArabicName,
                        color: Colors.white,
                      ),
                    ),
                  )
              ),
              ...classScheduleData!.rows![index].classOfTheDay!.map((e) {
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
                              Colors.black.withValues(alpha:0.5)),
                        ],
                        fontSize: 13,
                        letterSpacing: 0,
                        fontFamily: Get
                            .find<StorageService>()
                            .activeLocale ==
                            SupportedLocales.english
                            ? fontFamilyEnglishName
                            : fontFamilyArabicName,
                        color: Colors.white,
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

  getClassScheduleData() async {
    classSchedulesIsEmpty = false;
    classSchedulesIsLoading = false;
    update();
    listOfRowsSchedules = [];
    classScheduleData = await ClassSSchedulesServices.getClassTableList("${teacherData?.school??0}",  "${chosenClass?.id??0}",);
    classScheduleData?.header?.removeAt(0);
    if(classScheduleData!=null){
      initiateClassTable();

    }else{
      classSchedulesIsEmpty = true;
    }
    classSchedulesIsLoading = false;
    update();
  }
  //saving class table as image or as pdf
  Future<void> saveTheClassSchedules(BuildContext context) {
    List<String> imagePaths = [];
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    String message = '';
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
          message =
          Get.find<StorageService>().activeLocale ==
              SupportedLocales.english?
          'schedules saved to gallery':"تم حفظ الجداول الدراسى في المعرض الصور";
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
  Future<void> generateStyledPdf(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    String message = '';

    final pdf = pw.Document();
    List<String>? headers = [];
    List<List<String>? >data = [];
    // Define table headers and data
    for(int i = 0; i<=(classScheduleData?.header?.length??0);i++){
      if(i==0){
        headers.add(Get.find<StorageService>().activeLocale ==
            SupportedLocales.english
            ?"day \n class ":'''الحصص \n اليوم''');
      }else{
        headers.add(classScheduleData!.header![i-1]);
      }
    }
    for(int i = 0; i<(classScheduleData?.rows?.length??0);i++){
      List<String> row = [];
      row.add(classScheduleData?.rows?[i].day??"");
      for(int e = 0; e < (classScheduleData?.rows?[i].classOfTheDay?.length??0)-1;e++){
        if(classScheduleData?.rows?[i].classOfTheDay?[e].subject?.isNotEmpty??false) {
          row.add('''${classScheduleData?.rows?[i].classOfTheDay?[e].subject ??
              ""} \n ${classScheduleData?.rows?[i].classOfTheDay?[e].teacher ?? ""}''');
        }else{
          row.add("");
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
                'الفصل: ${Get.find<StorageService>().activeLocale ==
                    SupportedLocales.english
                    ?chosenClass?.titleEn??"":chosenClass?.title??""}',
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
    }).
    catchError((onError) {
      message = onError.toString();
      scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.close,color:Colors.white,
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
  }
  //editing class table schedules
  editClassSchadulesTable(){
    Get.to(()=>WebViewScreen(webLink:"https://my-school-app.com/class_table?school_id=${teacherData?.school??0}&teacher_id=${teacherData?.id??0}&class_id=${chosenClass?.id??0}" ));
  }
  //choosing class from stages
  choosingStage(ClassTeacherModel? stage){
    chosenStage = stage;
    chosenSubStage = null;
    chosenClass = null;
    getTeacherSubStages();
    update();
  }

  choosingSubStage(ClassTeacherModel? subStage){
    chosenSubStage = subStage;
    chosenClass = null;
    getTeacherClass();
    update();
  }

  choosingClass(ClassTeacherModel? selectedClass){
    chosenClass = selectedClass;
    attendanceTable = [];
    update();
  }
  //attendance sheet functions
  getSchedulesTable() async {
    attendanceSchedulesIsEmpty = false;
    schedulesIsLoadingTable = true;
    update();
    final newFormatter = DateFormat("dd-MM-yyyy");
    attendanceTable = await AttendanceServices.getAttendanceTableList("${teacherData?.school??0}",  "${chosenClass?.id??0}", newFormatter.format(selectedDateVal));
    if(attendanceTable?.isEmpty??true){
      attendanceSchedulesIsEmpty = true;
      update();
    }
    schedulesIsLoadingTable = false;
    update();
  }

  selectingData(int index,BuildContext context){
    if(attendanceTable?[index].check == 1) {
      editArrivalOrLeaving(
          context, "${attendanceTable?[index].id ?? 0}", "remove");
      update();
    }else{
      editArrivalOrLeaving(
          context, "${attendanceTable?[index].id ?? 0}", "add");
      update();
    }
  }

  selectingLeaveTime(BuildContext context,int index) async {
    leaveTimeVal = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor:Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 25),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0,

          child: Container(
            decoration:  BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              image: const DecorationImage(
                  image: AssetImage("assets/images/backgroundImage.png"),
                  fit: BoxFit.cover),
            ),
            height: Get.height*0.92,

            padding: EdgeInsets.zero,
            child: Column(
                children:[
                  SizedBox(
                    height: Get.height*0.75,

                    child: TimePickerDialog(
                      initialTime: leaveTimeVal,
                      cancelText: "",
                      confirmText: "",
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: (){
                          choosingLeavingTime( context, index);
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 0),
                          child: Container(
                            constraints: BoxConstraints(
                              minHeight: Get.height * 0.06,
                            ),
                            width: Get.width * 0.3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
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
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: Get.width * 0.2,
                                      child: CustomText(
                                        textAlign: TextAlign.center,
                                        maxLines: 3,
                                        'OK',
                                        style: TextStyle(
                                          shadows: <Shadow>[
                                            Shadow(
                                                offset:
                                                const Offset(0.5, 0.5),
                                                blurRadius: 0.5,
                                                color: Colors.black
                                                    .withValues(alpha:0.5)),
                                          ],
                                          fontSize: 13,
                                          letterSpacing: 0,
                                          fontFamily:
                                          Get.find<StorageService>()
                                              .activeLocale ==
                                              SupportedLocales.english
                                              ? fontFamilyEnglishName
                                              : fontFamilyArabicName,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const Icon(Icons.check,
                                        color: Colors.white, size: 20),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.of(context).pop();

                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 0),
                          child: Container(
                            constraints: BoxConstraints(
                              minHeight: Get.height * 0.06,
                            ),
                            width: Get.width * 0.3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
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
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: Get.width * 0.2,
                                      child: CustomText(
                                        textAlign: TextAlign.center,
                                        maxLines: 3,
                                        'Cancel',
                                        style: TextStyle(
                                          shadows: <Shadow>[
                                            Shadow(
                                                offset:
                                                const Offset(0.5, 0.5),
                                                blurRadius: 0.5,
                                                color: Colors.black
                                                    .withValues(alpha:0.5)),
                                          ],
                                          fontSize: 13,
                                          letterSpacing: 0,
                                          fontFamily:
                                          Get.find<StorageService>()
                                              .activeLocale ==
                                              SupportedLocales.english
                                              ? fontFamilyEnglishName
                                              : fontFamilyArabicName,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const Icon(Icons.cancel_outlined,
                                        color: Colors.white, size: 20),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),

                ]),
          ),
        );

      },
    );

  }

  choosingLeavingTime(BuildContext context,int index) async {
    await editArrivalOrLeavingTime(context,"${attendanceTable?[index].id??0}", leaveTimeVal.format(context), "1");
    update()
    ;
  }

  selectingArrivalTime(BuildContext context,int index) async {
    leaveTimeVal = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor:Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 25),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0,

          child: Container(
            decoration:  BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              image: const DecorationImage(
                  image: AssetImage("assets/images/backgroundImage.png"),
                  fit: BoxFit.cover),
            ),
            height: Get.height*0.92,

            padding: EdgeInsets.zero,
            child: Column(
                children:[
                  SizedBox(
                    height: Get.height*0.75,

                    child: TimePickerDialog(
                      initialTime: arrivalTimeVal,
                      cancelText: "",
                      confirmText: "",
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: (){
                          choosingArrivalTime( context, index);
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 0),
                          child: Container(
                            constraints: BoxConstraints(
                              minHeight: Get.height * 0.06,
                            ),
                            width: Get.width * 0.3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
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
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: Get.width * 0.2,
                                      child: CustomText(
                                        textAlign: TextAlign.center,
                                        maxLines: 3,
                                        'OK',
                                        style: TextStyle(
                                          shadows: <Shadow>[
                                            Shadow(
                                                offset:
                                                const Offset(0.5, 0.5),
                                                blurRadius: 0.5,
                                                color: Colors.black
                                                    .withValues(alpha:0.5)),
                                          ],
                                          fontSize: 13,
                                          letterSpacing: 0,
                                          fontFamily:
                                          Get.find<StorageService>()
                                              .activeLocale ==
                                              SupportedLocales.english
                                              ? fontFamilyEnglishName
                                              : fontFamilyArabicName,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const Icon(Icons.check,
                                        color: Colors.white, size: 20),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.of(context).pop();

                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 0),
                          child: Container(
                            constraints: BoxConstraints(
                              minHeight: Get.height * 0.06,
                            ),
                            width: Get.width * 0.3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
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
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: Get.width * 0.2,
                                      child: CustomText(
                                        textAlign: TextAlign.center,
                                        maxLines: 3,
                                        'Cancel',
                                        style: TextStyle(
                                          shadows: <Shadow>[
                                            Shadow(
                                                offset:
                                                const Offset(0.5, 0.5),
                                                blurRadius: 0.5,
                                                color: Colors.black
                                                    .withValues(alpha:0.5)),
                                          ],
                                          fontSize: 13,
                                          letterSpacing: 0,
                                          fontFamily:
                                          Get.find<StorageService>()
                                              .activeLocale ==
                                              SupportedLocales.english
                                              ? fontFamilyEnglishName
                                              : fontFamilyArabicName,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const Icon(Icons.cancel_outlined,
                                        color: Colors.white, size: 20),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),

                ]),
          ),
        );

      },
    );

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
                'يوم: ${getFormatedDate(selectedDateVal)}',
                textDirection:pw.TextDirection.rtl,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontSize: 18,
                  color: PdfColors.blue800,
                  font: ttf,
                ),
              ), pw.SizedBox(height: 10),
              pw.Text(
                'الفصل: ${Get.find<StorageService>().activeLocale ==
                    SupportedLocales.english
                    ?chosenClass?.titleEn??"":chosenClass?.title??""}',
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
                                    ?'n':"م",
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
                              child: pw.Text(
                                Get.find<StorageService>().activeLocale ==
                                    SupportedLocales.english
                                    ?'student':"الطالب",
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
                                  "${row.id??0}",
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
                                child: pw.Text(
                                  "${row.name??0}",
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
                                  (row.check??0)==1?"${formattingTimmeToAmAndPmFormat(row.timeIn??"")}":"",                                  textDirection:pw.TextDirection.rtl,
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
                                  (row.check??0)==1?"${formattingTimmeToAmAndPmFormat(row.timeOut??"")}":"",                                  textDirection:pw.TextDirection.rtl,
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
    }).
    catchError((onError) {
      message = onError.toString();
      scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.close,color:Colors.white,
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
  }

  choosingArrivalTime(BuildContext context,int index) async {
    await editArrivalOrLeavingTime(context,"${attendanceTable?[index].id??0}", leaveTimeVal.format(context), "0");
    update();
  }

  selectingDate(BuildContext context) async {

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime.now(),);
    update();
    if (pickedDate != null) {
      selectedDateVal = pickedDate;
      update();
    } else {}

  }

  editNotesForReportArrival(BuildContext context,String studentId,String notes) async {
    showDialog(context: context,
        builder: (context) {
          return const LoadingAlertDialogue();
        });

    if(editingNotesIsLoading){
      showDialog(context: context,
          builder: (context) {
            return const LoadingAlertDialogue();
          });
    }else{
      editingNotesIsLoading = true;
      update();
      String selectedDate = DateFormat('yyyy-MM-dd').format(selectedDateVal);
      ResponseModel? data = await AttendanceServices.editNotesAttendanceOfStudent(notes, studentId, selectedDate);
      if(data?.msg=="succeeded"){
        editingNotesIsLoading = false;
        await getSchedulesTable();
        update();
      }else{
        editingNotesIsLoading = false;
        update();
        Get.back();
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

  editArrivalOrLeavingTime(BuildContext context,String studentId,String time,String arrivalOrLeaving) async {
    showDialog(context: context,
        builder: (context) {
          return const LoadingAlertDialogue();
        });

    if(editingArrivalOrLeavingTimeIsLoading){
      showDialog(context: context,
          builder: (context) {
            return const LoadingAlertDialogue();
          });
    }else{
      editingArrivalOrLeavingTimeIsLoading = true;
      update();
      String selectedDate = DateFormat('dd-MM-yyyy').format(selectedDateVal);
      ResponseModel? data = await AttendanceServices.editTimeAttendanceOfStudent(arrivalOrLeaving, studentId, selectedDate,time);
      if(data?.msg=="succeeded"){
        editingArrivalOrLeavingTimeIsLoading = false;
        getSchedulesTable();
        update();
      }else{
        editingArrivalOrLeavingTimeIsLoading = false;
        update();
        Get.back();
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

  editArrivalOrLeaving(BuildContext context,String studentId,String arrivalOrLeaving) async {
    showDialog(context: context,
        builder: (context) {
          return const LoadingAlertDialogue();
        });

    if(editingArrivalOrLeavingIsLoading){
      showDialog(context: context,
          builder: (context) {
            return const LoadingAlertDialogue();
          });
    }else{
      editingArrivalOrLeavingIsLoading = true;
      update();
      String selectedDate = DateFormat('yyyy-MM-dd').format(selectedDateVal);
      ResponseModel? data = await AttendanceServices.editAttendanceOfStudent(arrivalOrLeaving, studentId, selectedDate);
      if(data?.msg=="succeeded"){
        Get.back();
        editingArrivalOrLeavingIsLoading = false;
        await getSchedulesTable();
        update();
      }else{
        editingArrivalOrLeavingIsLoading = false;
        Get.back();
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

  formattingTimmeToAmAndPmFormat(String time){
    return DateFormat.jm().format(DateFormat("hh:mm:ss").parse(time));
  }

  showEditingNotes(BuildContext context,int index) async {
    TextEditingController msgController = TextEditingController();
    msgController.text = attendanceTable?[index].notes??"";
    FocusNode msgNode = FocusNode();
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor:Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 25),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0,

          child: Container(
            decoration:  BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              image: const DecorationImage(
                  image: AssetImage("assets/images/backgroundImage.png"),
                  fit: BoxFit.cover),
            ),
            height: Get.height*0.4,

            padding: EdgeInsets.zero,
            child: Column(
                children:[
                  const SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: kLightBlueColor,
                        boxShadow: const [
                          BoxShadow(
                            color: kGrayColor,
                            blurRadius: 2,
                            offset: Offset(1, 1), // Shadow position
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all( 8.0,),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextFormField(
                            maxLines: 4,
                            focusNode: msgNode,
                            controller: msgController,
                            keyboardType: TextInputType.multiline,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.message_rounded),
                              counterText: "",
                              hintText: "ملاحظات",
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFF184e7a), width: 2.0),
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFF184e7a), width: 1.0),
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            validator: (value) {
                              if (value!.length < 1) {
                                return ;
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: (){
                          addNewNotes( index,msgController.text,context);

                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 0),
                          child: Container(
                            constraints: BoxConstraints(
                              minHeight: Get.height * 0.06,
                            ),
                            width: Get.width * 0.3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
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
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: Get.width * 0.2,
                                      child: CustomText(
                                        textAlign: TextAlign.center,
                                        maxLines: 3,
                                        'OK',
                                        style: TextStyle(
                                          shadows: <Shadow>[
                                            Shadow(
                                                offset:
                                                const Offset(0.5, 0.5),
                                                blurRadius: 0.5,
                                                color: Colors.black
                                                    .withValues(alpha:0.5)),
                                          ],
                                          fontSize: 13,
                                          letterSpacing: 0,
                                          fontFamily:
                                          Get.find<StorageService>()
                                              .activeLocale ==
                                              SupportedLocales.english
                                              ? fontFamilyEnglishName
                                              : fontFamilyArabicName,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const Icon(Icons.check,
                                        color: Colors.white, size: 20),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.of(context).pop();

                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 0),
                          child: Container(
                            constraints: BoxConstraints(
                              minHeight: Get.height * 0.06,
                            ),
                            width: Get.width * 0.3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
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
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: Get.width * 0.2,
                                      child: CustomText(
                                        textAlign: TextAlign.center,
                                        maxLines: 3,
                                        'Cancel',
                                        style: TextStyle(
                                          shadows: <Shadow>[
                                            Shadow(
                                                offset:
                                                const Offset(0.5, 0.5),
                                                blurRadius: 0.5,
                                                color: Colors.black
                                                    .withValues(alpha:0.5)),
                                          ],
                                          fontSize: 13,
                                          letterSpacing: 0,
                                          fontFamily:
                                          Get.find<StorageService>()
                                              .activeLocale ==
                                              SupportedLocales.english
                                              ? fontFamilyEnglishName
                                              : fontFamilyArabicName,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const Icon(Icons.cancel_outlined,
                                        color: Colors.white, size: 20),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),

                ]),
          ),
        );

      },
    );
  }

  addNewNotes(int index,String addedText,BuildContext context) async {
    await editNotesForReportArrival(context,  "${attendanceTable?[index].id??0}", addedText);
    update();
  }

  getFormatedDate( date) {
    final newFormatter = DateFormat("EEEE: dd-MM-yyyy");
    return  newFormatter.format(date);
  }

  Future<void> saveTheAttendanceAndLeavingSheet(BuildContext context) {
    List<String> imagePaths = [];
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    String message = '';
    return Future.delayed(const Duration(milliseconds: 20), () async {
      RenderRepaintBoundary? boundary = previewAttendanceContainer.currentContext!
          .findRenderObject() as RenderRepaintBoundary?;
      ui.Image image = await boundary!.toImage();

      final directory = (await getApplicationDocumentsDirectory()).path;
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      File imgFile = File('$directory/attendance and leaving sheet${DateFormat('yMMMMEEEEd').format(DateTime.now())}.png');
      imagePaths.add(imgFile.path);
      imgFile.writeAsBytes(pngBytes).then((value) async {


        // Ask the user to save it
        final params = SaveFileDialogParams(sourceFilePath: imgFile.path);
        final finalPath = await FlutterFileDialog.saveFile(params: params);
        if (finalPath != null) {
          message =
          Get.find<StorageService>().activeLocale ==
              SupportedLocales.english?
          'attendance and leaving sheet saved to gallery':"تم حفظ الجدول الحضور والغياب في المعرض الصور";
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


}