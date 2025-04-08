// ignore_for_file: avoid_print, prefer_is_empty, sized_box_for_whitespace, unused_local_variable, deprecated_member_use, use_build_context_synchronously, unnecessary_to_list_in_spreads

import 'dart:io';
import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart' hide StringTranslateExtension;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show ByteData, Uint8List;
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:get/get.dart';
import 'package:madrasty/Utils/Colors_File.dart';
import 'package:path_provider/path_provider.dart';
import '../../../Models/attendance_table_model.dart';
import '../../../Models/class_teacher_model.dart';
import '../../../Models/parent_share_model.dart';
import '../../../Models/post_model.dart';
import '../../../Models/posting_status_model.dart';
import '../../../Models/response_model.dart';
import '../../../Models/school_id_model.dart';
import '../../../Models/student_share_model.dart';
import '../../../Models/teacher_info_model.dart';
import '../../../Models/teacher_schedules_class_model.dart';
import '../../../Services/attendance_services.dart';
import '../../../Services/class_schedules_services.dart';
import '../../../Services/posting_services.dart';
import '../../../Services/teacher_services.dart';
import '../../../Utils/constant.dart';
import '../../../Utils/localization_services.dart';
import '../../../Utils/memory.dart';
import '../../../Utils/translation_key.dart';
import '../../../Widgets/alert_dialogue.dart';
import '../../../Widgets/custom_text_widget.dart';
import '../../../Widgets/loading_alert_dialogue.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import '../widget/teacher_sliding_filter_screen.dart';
class TeacherProfileController extends GetxController {
  late List<StudentShareModel>? peopleShareList;
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  var leaveTimeVal = TimeOfDay.fromDateTime(DateTime.now());
  var arrivalTimeVal = TimeOfDay.fromDateTime(DateTime.now());
  var selectedDateVal = DateTime.now();
  bool switchStudentValue = true;
  bool switchParentValue = true;
  TeacherInfoModel? teacherData;
  List<ClassTeacherModel>? teacherStages ;
  ClassTeacherModel? chosenStage;
  List<ClassTeacherModel>? teacherSubStage;
  ClassTeacherModel? chosenSubStage;
  List<ClassTeacherModel>? teacherClass;
  ClassTeacherModel? chosenClass;
  TeacherSchedulesClassModel? classScheduleData;
  bool isTeacherProfileDataIsLoading = true;
  bool isClassLoading = true;
  bool classSchedulesIsLoading = true;
  bool classSchedulesIsEmpty = false;
  bool attendanceSchedulesIsEmpty = false;
  bool isSendingRecommendation = false;
  bool schedulesIsLoadingTable = true;
  late TextEditingController textController1;
  late FocusNode text1FocusNode;
late PostingStatusModel? postStatusData;
  List<String> userTaps = [
    Get.find<StorageService>()
        .activeLocale ==
        SupportedLocales.english
        ? 'Attendance Report'
        :'تقرير الحضور والغياب',
    parentTap7.tr,
    parentTap3.tr,
    parentTap2.tr,
   parentTap6.tr,
  ];


  List<String> days = [
    day1Key.tr,
    day2Key.tr,
    day3Key.tr,
    day4Key.tr,
    day5Key.tr
  ];
  List<DataRow> listOfRowsSchedules =[];
  List<Widget> listOfWidgetEditClass = [];
  List<TextEditingController> controllerOfTextFields = [];
  ScrollController scrollController = ScrollController();
  bool isVisible = false;
  String chosenUserType = "اختر نوع المستخدم";
  String chosenUserTap = 'تقرير الحضور والغياب';
  List<AttendanceTableModel>? attendanceTable = [];
  String chosenUserTap1 = '';
  int chosenUserTapIndicator = 0;
  int chosenUserTap1Indicator = 0;
  bool postIsLoading = true;
  late SchoolIdModel? schoolId;
  late PostModel? postData;
  late List<Post>? postsListData;
  Class? selectedPostType;
  GlobalKey previewContainer = GlobalKey();
  GlobalKey previewAttendanceContainer = GlobalKey();
  List<Class>? postsTypesListData=[

  ];
  String noteOfVacation = "";
  List<bool> canceledClass = [];
  bool  editingNotesIsLoading = false;
  bool  editingArrivalOrLeavingTimeIsLoading = false;
  bool  editingArrivalOrLeavingIsLoading = false;
  bool classIsLoading = true;
  bool subStageIsLoading = true;
  bool arrivalAndLeavingReportIsLoading = true;
  int pageNumber = 1;
  bool isLoadingMoreDataForPosts = false;
  bool filteringData = false;
  StudentShareModel? chosenTeacher;
  ParentShareModel? chosenParent;
  StudentShareModel? chosenStudent;
  List<StudentShareModel>? teacherList = [];
  List<ParentShareModel>? parentList = [];
  List<StudentShareModel>? studentList = [];
  List<String> userType = [
    chooseUserKey.tr,
    userType1.tr,
    userType2.tr,
    userType3.tr,
  ];
  String chosenUserFilterType = chooseUserKey.tr;
  List<String> postsTypes = [
    choosePostType.tr,
    postType1.tr,
    postType2.tr,
    postType3.tr,
    postType4.tr,
  ];
  String chosenPostsType = choosePostType.tr;
  @override
  onInit(){
    super.onInit();
    textController1 = TextEditingController();
    text1FocusNode = FocusNode();
    getTeacherData();
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
  //"${teacherData?.school??0}"  "${teacherData?.teacherInfoModelClass?[0]??0}"




  getSchedulesTable() async {
    attendanceSchedulesIsEmpty = false;
    schedulesIsLoadingTable = true;
    update();
    final newFormatter = DateFormat('yyyy-MM-dd');
    attendanceTable = await AttendanceServices.getAttendanceTableList("${teacherData?.school??0}",  "${chosenClass?.id??0}", newFormatter.format(selectedDateVal));
   if(attendanceTable?.isEmpty??true){
     attendanceSchedulesIsEmpty = true;
     update();
   }
    schedulesIsLoadingTable = false;
    update();
  }

  getTeacherData() async {
    teacherData = await TeacherServices.getTeacherInfoData();
    await Get.find<StorageService>().saveSchoolId("${teacherData?.school??0}");
    teacherStages = await TeacherServices.getStagesTeacher("${teacherData?.school??0}");
    peopleShareList = await PostingServices.getTeacherShareList("${teacherData?.school??0}");
    print(peopleShareList);
    postsTypesListData = teacherData?.teacherInfoModelClass;
    selectedPostType = teacherData?.teacherInfoModelClass?[0];
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
        noteOfVacation = "$noteOfVacation \n ${classScheduleData!.rows![index].day} : ${classScheduleData!.rows![index].classOfTheDay?.first[0].subject}";
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
                              Colors.black.withOpacity(0.5)),
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
                      '''${e[0].subject} \n ${e[0].classOfTheDayClass}''',
                      style: TextStyle(
                        shadows: <Shadow>[
                          Shadow(
                              offset: const Offset(0.5, 0.5),
                              blurRadius: 0.5,
                              color:
                              Colors.black.withOpacity(0.5)),
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
    classScheduleData = await ClassSSchedulesServices.getClassTableTeacherList("${teacherData?.school??0}",  "${chosenClass?.id??0}",);
    classScheduleData?.header?.removeAt(0);
    if(classScheduleData!=null){
      initiateClassTable();

    }else{
      classSchedulesIsEmpty = true;
    }
    classSchedulesIsLoading = false;
    update();
  }


//savin tables as image---------------------------------------------------------------
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
        if(classScheduleData?.rows?[i].classOfTheDay?[e][0].subject?.isNotEmpty??false) {
          row.add('''${classScheduleData?.rows?[i].classOfTheDay?[e][0].subject ??
              ""} \n ${classScheduleData?.rows?[i].classOfTheDay?[e][0].classOfTheDayClass ?? ""}''');
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


    print("PDF saved to ${file.path}");
  }

  //posts -------------------------------------------------------------------------------
  getFormatedDate( date) {
    const data = "27-10-2022 11:02:50";
    final format = DateFormat("dd-MM-yyyy HH:mm:ss");
    // final DateTime result = format.parse(date);
    print(date);
    // print(result);
    final newFormatter = DateFormat("EEEE: dd-MM-yyyy");
    return  newFormatter.format(date);
  }
  activeStudentPost(BuildContext context){

    if((postStatusData?.studentStatus??"0") == "0"){
      editPostStatus("1", "${postStatusData?.parentStatus??0}", "STUDENT", context);
    }else{
      editPostStatus("0", "${postStatusData?.parentStatus??0}", "STUDENT", context);
    }

    switchStudentValue = !switchStudentValue;
    update();
  }
  activeParentPost(BuildContext context){
    switchParentValue = !switchParentValue;

    if((postStatusData?.parentStatus??"0") == "0"){
      editPostStatus("${postStatusData?.studentStatus??0}", "1", "PARENT", context);
    }else{
      editPostStatus("${postStatusData?.studentStatus??0}", "0", "PARENT", context);
    }
    update();
  }
  getSchoolId() async {

    getPostData();
  }
  selectingPostType(Class? chosenPostType){
    selectedPostType = chosenPostType;
    getPostData();
    update();
  }
  Future<void>getPostData() async {
    postIsLoading = true;
    update();
    pageNumber = 1;
    postData = await PostingServices.getPostsList("${teacherData?.school??0}", "${selectedPostType?.id??0}", "$pageNumber","${teacherData?.id}");
    postStatusData = await PostingServices.getPostingStatus("${selectedPostType?.id??0}",);
    if((postStatusData?.studentStatus??"0") == "0"){
       switchStudentValue = false;

    }else{
      switchStudentValue = true;

    }
    if((postStatusData?.parentStatus??"0") == "0"){
       switchParentValue = false;

    }else{
      switchParentValue = true;

    }
    postsListData = postData?.posts;
    postIsLoading = false;
    update();
  }
  getMoreData() async {


    if(postData!.totalPages! > pageNumber ) {
      pageNumber++;
      isLoadingMoreDataForPosts= true;
      update();
      postData = await PostingServices.getPostsList("${teacherData?.school??0}", "${selectedPostType?.id??0}", "$pageNumber","${teacherData?.id}");
      for(Post post in postData!.posts!){
        postsListData?.add(post);
      }
      isLoadingMoreDataForPosts = false;
      update();
    }
  }
  editPostStatus(String studentStatus,String parentStatus,String type,BuildContext context) async {
    ResponseModel? data = await PostingServices.editPostingStatus(parentStatus, studentStatus, "${selectedPostType?.id??0}");
    if (data?.msg == "succeeded") {
      final snackBar = SnackBar(content:
      Row(children: [
        const Icon(Icons.check, color: Colors.white,),
        const SizedBox(width: 10,),
        Text(Get
            .find<StorageService>()
            .activeLocale ==
            SupportedLocales.english
            ? type == "PARENT"?parentStatus=="0"? "The father can't add posts now":"The father can't add posts now":studentStatus=="0"? "The son can't add posts now":"The son can't add posts now"
            :type == "PARENT"?parentStatus=="0"? 'لا ييستطيع الأب أضافه منشور من الأن':"يستطيع الأب أضافه منشورات الأن":studentStatus=="0"? 'لا ييستطيع الأبن أضافه منشور من الأن':"يستطيع الأبن أضافه منشورات الأن",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
        ),
        ),
      ],),
          backgroundColor: Colors.green
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      postStatusData = await PostingServices.getPostingStatus("${selectedPostType?.id??0}",);
      if((postStatusData?.studentStatus??"0") == "0"){
        switchStudentValue = false;

      }else{
        switchStudentValue = true;

      }
      if((postStatusData?.parentStatus??"0") == "0"){
        switchParentValue = false;

      }else{
        switchParentValue = true;

      }
      update();

    }
    else {

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

  //filtering posts----------------------------------------------------------------------------
  showFilteringScreen(BuildContext context, ) async {
    Navigator.of(context).push(createDrawerRoute());
    List<StudentShareModel>? teacherDataList =await PostingServices.getTeacherShareList("${schoolId?.school??0}");
    teacherList = [];
    for(StudentShareModel? teacher in teacherDataList??[] ) {


      if(teacher?.id ==teacherData?.id){
        teacherList?.add(teacher!);

      }
    }
    parentList =await PostingServices.getParentShareList("${schoolId?.school??0}","${schoolId?.schoolIdModelClass??0}");
    studentList =await PostingServices.getStudentShareList("${schoolId?.school??0}","${schoolId?.schoolIdModelClass??0}");
  }
  Route createDrawerRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const TeacherSlidingFilterScreen(),
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
  chooseFilterUserType(String userType){
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
    postData = await PostingServices.getPostsListAfterFiltering("${teacherData?.school??0}", "${selectedPostType?.id??0}", "$pageNumber","${teacherData?.id??0}","${chosenUserType == userType2.tr?chosenTeacher?.id??0
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
      postData =  await PostingServices.getPostsListAfterFiltering("${teacherData?.school??0}", "${selectedPostType?.id??0}", "$pageNumber","${teacherData?.id??0}","${chosenUserType == userType2.tr?chosenTeacher?.id??0
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
//user tabs func ------------------------------------------------------------------------------------------------------------------------
  chooseUserType(String userType){
    chosenUserType = userType;
    update();
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
    if(chosenUserTap == ( Get.find<StorageService>()
        .activeLocale ==
        SupportedLocales.english
        ? 'posts'
        :'المنشورات')){
      getPostData();
    }
    if(chosenUserTap == (Get.find<StorageService>()
        .activeLocale ==
        SupportedLocales.english
        ? 'Attendance Report'
        :'تقرير الحضور والغياب')) {
      chosenStage = null;
      chosenSubStage = null;
      chosenClass = null;
      attendanceTable = [];
    }
 if(chosenUserTap == ( parentTap3.tr)){
      chosenStage = null;
      chosenSubStage = null;
      chosenClass = null;
      classScheduleData = null;
    }
    update();
  }

  choosingUserTap1(String tapName) {
    chosenUserTap1 = tapName;
    update();
  }
  getPreviousTap() {
    if (chosenUserTapIndicator > 0) {
      chosenUserTapIndicator = chosenUserTapIndicator - 1;
      update();
    }
  }
  //scrolling func----------------------------------------------------------------------------
  goUpToTopOfSScreen(){
    scrollController.animateTo( //go to top of scroll
        0,  //scroll offset to go
        duration: const Duration(milliseconds: 500), //duration of scroll
        curve:Curves.fastOutSlowIn //scroll type
    );
    isVisible = false;
    update();
  }


//attendance table edit------------------------------------------------------------------------------------------
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
  TimeOfDay parseTimeOfDay(String timeString) {
    try {
      final parts = timeString.split(":"); // تقسيم النص إلى ساعات ودقائق وثوانٍ
      if (parts.length < 2) throw const FormatException("Invalid time format");

      final int hour = int.parse(parts[0]); // استخراج الساعات
      final int minute = int.parse(parts[1]); // استخراج الدقائق

      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      print("Error parsing time: $e");
      return const TimeOfDay(hour: 0, minute: 0); // قيمة افتراضية عند الخطأ
    }
  }
  selectingLeaveTime(BuildContext context,int index,String time) async {
    leaveTimeVal = parseTimeOfDay(time);
    final TimeOfDay? picked =  await showDialog(
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
            height: Get.height*0.65,

            padding: EdgeInsets.zero,
            child: Column(
                children:[
                  SizedBox(
                    height: Get.height*0.65,

                    child: TimePickerDialog(
                      initialTime: leaveTimeVal,
                    ),
                  ),


                ]),
          ),
        );

      },
    );
    if (picked != null) {
      leaveTimeVal = picked;
      choosingLeavingTime( context, index);
    }
  }

  choosingLeavingTime(BuildContext context,int index) async {
    await editArrivalOrLeavingTime(context,"${attendanceTable?[index].id??0}", leaveTimeVal, "1");
    update()
    ;
  }

  selectingArrivalTime(BuildContext context,int index,String time) async {
   arrivalTimeVal = parseTimeOfDay(time);

   final TimeOfDay? picked = await showDialog(
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
            height: Get.height*0.65,

            padding: EdgeInsets.zero,
            child: Column(
            children:[
              SizedBox(
                height: Get.height*0.65,

                child: TimePickerDialog(
                  initialTime: arrivalTimeVal,
                ),
              ),


            ]),
          ),
        );

      },
    );
   if (picked != null) {
       arrivalTimeVal = picked;
       choosingArrivalTime( context, index);
   }

print(arrivalTimeVal.toString());
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


    print("PDF saved to ${file.path}");
  }

  choosingArrivalTime(BuildContext context,int index) async {
    await editArrivalOrLeavingTime(context,"${attendanceTable?[index].id??0}", arrivalTimeVal, "0");
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
       Get.back();
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

  String formatTimeOfDay(TimeOfDay time) {
    final String hour = time.hour.toString().padLeft(2, '0'); // تحويل الساعات إلى رقمين
    final String minute = time.minute.toString().padLeft(2, '0'); // تحويل الدقائق إلى رقمين
    return "$hour:$minute";
  }
  editArrivalOrLeavingTime(BuildContext context,String studentId,TimeOfDay time,String arrivalOrLeaving) async {
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
      String selectedDate = DateFormat('yyyy-MM-dd').format(selectedDateVal);
      String selectedTime = formatTimeOfDay(time);
      ResponseModel? data = await AttendanceServices.editTimeAttendanceOfStudent(arrivalOrLeaving, studentId, selectedDate,selectedTime);
      if(data?.msg=="succeeded"){
        editingArrivalOrLeavingTimeIsLoading = false;
        Get.back();
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
                      child: Container(
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
                                  Container(
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
                                  Container(
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
//stags of education------------------------------------------------------------------------------------
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
  Future<void> saveTheAttendanceAndLeavingSheet(BuildContext context) {
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
