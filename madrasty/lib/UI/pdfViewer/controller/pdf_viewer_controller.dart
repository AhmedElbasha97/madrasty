// ignore_for_file: prefer_interpolation_to_compose_strings, use_build_context_synchronously, sized_box_for_whitespace, avoid_print, annotate_overrides, depend_on_referenced_packages

import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:dio/dio.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:madrasty/Utils/translation_key.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Widgets/alert_dialogue.dart';

class PdfViewerController extends GetxController {
  bool isLoading = true;
  int currentPage = 0;
  late PDFViewController pdfViewController;
  int totalPages = 0;
  bool isReady = false;
  String localPth = "";
  String errorMessage = '';
  var filePath = Get.arguments[0];
  var fileTitle = Get.arguments[1];
  final BuildContext context;

  PdfViewerController(this.context);

  Future<void> onInit() async {
    print(filePath);
    super.onInit();
    loadPdf() ;
  }
  loadPdf() async {
    try {

      isLoading = true;
      update();
      final data = await http.get(Uri.parse(filePath)).then((res) => res.bodyBytes);
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/my_file.pdf');
      await file.writeAsBytes(data);
      localPth ='${directory.path}/my_file.pdf';
      isLoading = false;
      update();
    } catch (e) {
        errorMessage = e.toString();

    }
  }



  stopLoading() {
    isLoading = false;
    update();
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
            newPath += "/" + folder;
          } else {
            break;
          }
        }
        newPath = newPath + "/madrasty_App";
        directory = Directory(newPath);

        File saveFile = File(directory.path + "/$fileTitle");
        if (kDebugMode) {
          print(saveFile.path);
        }
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
        if (await directory.exists()) {
          await Dio().download(
            filePath,
            saveFile.path,
          );
        }
        final snackBar = SnackBar(

          content: Container(
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
                    const Text('اسم الملف:'),
                    Text(fileTitle ?? "",),
                  ],
                ),
                const Text("تم تحميله في ملف مساره هو:",
                  textDirection: TextDirection.rtl,),

                Text(newPath,),

              ],
            ),
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  launchURL(context) async {
    if (!await launchUrl(
        Uri.parse(filePath ?? ""), mode: LaunchMode.externalApplication)) {
      AlertDialogue(alertTitle: error.tr,
        alertText: "Can't download file right now",
        alertIcon: 'assets/icons/warningIcon.png',);
      throw 'Could not launch $filePath';
    }
  }
}


