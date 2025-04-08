
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';

import '../../Utils/Colors_File.dart';
import '../../Widgets/loader.dart';
import 'controller/pdf_viewer_controller.dart';

class PdfViewer extends StatefulWidget {
  const PdfViewer({super.key});

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init:  PdfViewerController(context),
    builder: (PdfViewerController controller) =>
    Scaffold(
    appBar: AppBar(
    iconTheme:  const IconThemeData(color: kBlueColor),
    backgroundColor: kLightBlueColor,
    ),
      body: controller.isLoading ?
      const Loader():
      PDFView(
        filePath: controller.localPth,
        fitEachPage: true,
        fitPolicy: FitPolicy.BOTH,
        onRender: (_pages) {
          setState(() {
            controller.totalPages = _pages!;
          });
        },
        onError: (error) {
          setState(() {
            controller.errorMessage = error.toString();
          });
        },
        onPageError: (page, error) {
          setState(() {
            controller.errorMessage = '$error';
          });
        },
        onViewCreated: (PDFViewController vc) {
          setState(() {
            controller.pdfViewController = vc;
          });
        },
      ),


      floatingActionButton:  Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: (){
            controller.saveFile();
          },
          child: Container(
            width: Get.width*0.17,
            height: Get.height*0.08,
            decoration: BoxDecoration(
              border: Border.all( color:kLightBlueColor,width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha:0.1),
                  offset: const Offset(
                    0.0,
                    0.0,
                  ),
                  blurRadius: 13.0,
                  spreadRadius: 2.0,
                ), //BoxShadow
                BoxShadow(
                  color: Colors.white.withValues(alpha:0.2),
                  offset: const Offset(0.0, 0.0),
                  blurRadius: 0.0,
                  spreadRadius: 0.0,
                ), //BoxShadow
              ],
              color: kDarkBlueColor
              ,shape: BoxShape.circle,
            ),
            child:  const Center(
              child:  Icon(
                Icons.download,
                weight: 30,
                color: kLightBlueColor,
              ),
            ),
          ),
        ),
      ),
    ),
    );
  }
}
