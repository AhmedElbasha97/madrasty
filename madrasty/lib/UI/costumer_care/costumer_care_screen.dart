import 'package:flutter/material.dart';
import 'package:flutter_tawkto/flutter_tawk.dart';
import 'package:get/get.dart';
import 'package:madrasty/UI/costumer_care/controller/costumer_care_controller.dart';

import '../../Utils/Colors_File.dart';
import '../../Utils/memory.dart';

class CostumerCareScreen extends StatelessWidget {
  const CostumerCareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  GetBuilder(
      init: CostumerCareController(),
      builder: (CostumerCareController controller) => Scaffold(
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
        body: Tawk(
          directChatLink: 'https://tawk.to/chat/67adb0753a842732607e2f40/1ijv7ij0l',
          visitor: TawkVisitor(
            name: "${controller.detectUserTypeTranslated(Get.find<StorageService>().getUserType)} : ${Get.find<StorageService>().getUserType == "TEACHER"||Get.find<StorageService>().getUserType == "SUPERVISOR"?
            controller.userData2?.name??"":controller.userData?.name??""}",

          ),

          onLinkTap: (String url) {
            controller.launchURLToWeb(url, context);
          },
          placeholder:  Center(
            child: Expanded(
              flex: 1,
              child: Container(

                color:const Color(0x80000000),
                child: Center(
                  child:Container(
                    height: MediaQuery.of(context).size.height*0.1 ,
                    width: MediaQuery.of(context).size.width*0.4 ,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      border: Border.all(width: 0.5, color: kYellowColor),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5, //soften the shadow
                          spreadRadius: 0, //extend the shadow
                          offset: Offset(
                            0.0, // Move to right 10  horizontally
                            3.0, // Move to bottom 5 Vertically
                          ),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          Localizations.localeOf(context).languageCode == "en" ?"Loading":"جاري التحميل",style: const TextStyle(color: kYellowColor),),
                        const SizedBox(width: 15,),
                        const CircularProgressIndicator(color: kYellowColor,)

                      ],
                    ),
                  ),
                ),
              ),
            )
          ),
        ),
      ),
    );

  }
}
