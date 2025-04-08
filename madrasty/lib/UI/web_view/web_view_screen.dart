import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madrasty/Widgets/loader.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../Utils/Colors_File.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key, required this.webLink});

final  String webLink;
  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  final controller = WebViewController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (progress) {},
        onPageStarted: (String url) {},
        onPageFinished: (String url) {
          controller.runJavaScript('''
      var element = document.querySelector('#ast-mobile-header.ast-mobile-header-wrap[data-type="dropdown"]');
      if (element) {
        element.style.display = 'none';
      }
    ''');
          isLoading = false;
          setState(() {});
        },
        onWebResourceError: (WebResourceError error) {
          //Things to do when the page has error when loading
        },
      ))
      ..loadRequest(Uri.parse(widget.webLink));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            const SizedBox(
              width: 8,
            ),

            InkWell(
              onTap: () {
                Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: Get.height * 0.07,
                  width: Get.width * 0.11,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: kDarkBlueColor,
                    boxShadow: const [
                      BoxShadow(
                        color: kGrayColor,
                        blurRadius: 2,
                        offset: Offset(1, 1), // Shadow position
                      ),
                    ],
                  ),
                  child: const Center(
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      )),
                ),
              ),
            ),
          ],
          backgroundColor: kYellowColor,
          leading: InkWell(
            onTap: () {
            },
            child: const Padding(
                padding: EdgeInsets.all(13.0),
                child: SizedBox()
            ),
          ),
          title: Image.asset(
            "assets/images/appMultiColorLogoWithoutbackground.png",
            fit: BoxFit.fitHeight,
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.3,
          ),
          centerTitle: true,
        ),
        body: (isLoading)
            ? const Loader()
            : Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: WebViewWidget(
            controller: controller,
          ),
        ));
  }
}
