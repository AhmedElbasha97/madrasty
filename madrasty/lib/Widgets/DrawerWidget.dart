// ignore_for_file: file_names, library_private_types_in_public_api, use_build_context_synchronously, sized_box_for_whitespace, prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madrasty/Services/app_info_services.dart';
import 'package:madrasty/UI/home_screen/home_screen.dart';
import 'package:madrasty/UI/privacy_policy/privacy_policy_screen.dart';
import 'package:madrasty/Utils/Colors_File.dart';
import 'package:madrasty/Utils/translation_key.dart';
import 'package:madrasty/Widgets/social_links_loading_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Models/school_details_model.dart';
import '../Models/social_media_linnks_model.dart';
import '../Services/school_services.dart';
import '../UI/costumer_care/costumer_care_screen.dart';
import '../UI/profile_screen/profile_screen.dart';
import '../UI/school_details/school_details_screen.dart';
import '../UI/school_list/school_list_screen.dart';
import '../UI/terms_and_condition/terms_and_condition_screen.dart';
import '../Utils/localization_services.dart';
import '../Utils/memory.dart';
import 'drawer_loadding_widget.dart';
import 'drawer_tap_widget.dart';


class AppDrawers extends StatefulWidget {

  const AppDrawers({super.key, required this.scaffoldKey});
  final scaffoldKey ;

  @override
  _AppDrawersState createState() => _AppDrawersState();
}

class _AppDrawersState extends State<AppDrawers> {
  late SchoolDetailModel? schoolData;
  bool isLoading = true;
  bool isLoadingSocialLink = true;
  String userNameText = '';
  late SocialMediaLinksModel? socialLinkData;
  List<DrawerItem> data= Get
      .find<StorageService>()
      .getId != "0"?[
      DrawerItem(drawerWidget1.tr, "home_icon.png"),
     DrawerItem(drawerWidget2.tr, "profile_appdrawer_icon.png"),
     DrawerItem(drawerWidget3.tr, "school_icon.png"),
     DrawerItem(drawerWidget4.tr, "school_icon.png"),
     DrawerItem(drawerWidget6.tr, "Sign_out_icon.png"),
     DrawerItem(drawerWidget7.tr, "app_managment_icon.png"),
     DrawerItem(drawerWidget8.tr, "terms_and_condition_icon.png"),
     DrawerItem(drawerWidget9.tr, "privacy_policy_icon.png"),
]:[
    DrawerItem(drawerWidget1.tr, "home_icon.png"),

    DrawerItem(drawerWidget4.tr, "school_icon.png"),
    DrawerItem(drawerWidget6.tr, "Sign_out_icon.png"),
    DrawerItem(drawerWidget7.tr, "app_managment_icon.png"),
    DrawerItem(drawerWidget8.tr, "terms_and_condition_icon.png"),
    DrawerItem(drawerWidget9.tr, "privacy_policy_icon.png"),
  ];
  @override
  void initState() {
    super.initState();
    getSchoolData();
    getSocialLinks();
  }
  getSocialLinks() async {
    socialLinkData = await AppInfoServices.getSocialMediaLinks();
    isLoadingSocialLink = false;
    setState(() {

    });
  }
  getSchoolData() async {
    if(Get
        .find<StorageService>()
        .getSchoolId != "0") {
      schoolData = await SchoolServices.getSchoolsDetails(Get
          .find<StorageService>()
          .getSchoolId);
      data[2] = DrawerItem(schoolData?.name ?? "", "school_icon.png");
    }
    isLoading = false;
    setState(() {

    });
  }


  detectFunctionalityOfDrawerTap(String title) async {
    switch(title){
      case"كل المدارس":{
        Get.to(() => const SchoolListScreen(),
            transition: Transition.rightToLeftWithFade);
        widget.scaffoldKey.currentState?.openEndDrawer();
      }
      case"الرئيسية":{
        Get.to(() => const HomeScreen(),
            transition: Transition.rightToLeftWithFade);
        widget.scaffoldKey.currentState?.openEndDrawer();
      }
      case"حسابي":{
        Get.to(() => const ProfileScreen(),
            transition: Transition.rightToLeftWithFade);
        widget.scaffoldKey.currentState?.openEndDrawer();
      }

      case"All Schools":{
        Get.to(() => const SchoolListScreen(),
            transition: Transition.rightToLeftWithFade);
        widget.scaffoldKey.currentState?.openEndDrawer();
      }
      case"Home":{
        Get.to(() => const HomeScreen(),
            transition: Transition.rightToLeftWithFade);
        widget.scaffoldKey.currentState?.openEndDrawer();
      }
      case"Terms of Use":{
        Get.to(() => const TermsAndConditionScreen(),
            transition: Transition.rightToLeftWithFade);
        widget.scaffoldKey.currentState?.openEndDrawer();
      }
      case"Privacy Policy":{
        Get.to(() => const PrivacyPolicyScreen(),
            transition: Transition.rightToLeftWithFade);
        widget.scaffoldKey.currentState?.openEndDrawer();
      }

      case"شروط الإستخدام":{
        Get.to(() => const TermsAndConditionScreen(),
            transition: Transition.rightToLeftWithFade);
        widget.scaffoldKey.currentState?.openEndDrawer();
      }
      case"سياسة الخصوصية":{
        Get.to(() => const PrivacyPolicyScreen(),
            transition: Transition.rightToLeftWithFade);
        widget.scaffoldKey.currentState?.openEndDrawer();
      }
      case"My Account":{
        Get.to(() => const ProfileScreen(),
            transition: Transition.rightToLeftWithFade);
        widget.scaffoldKey.currentState?.openEndDrawer();
      }
      case"إدارة التطبيق":{
        Get.to(() => const CostumerCareScreen(),
            transition: Transition.rightToLeftWithFade);
        widget.scaffoldKey.currentState?.openEndDrawer();
      }
      case"Application Management":{
        Get.to(() => const CostumerCareScreen(),
            transition: Transition.rightToLeftWithFade);
        widget.scaffoldKey.currentState?.openEndDrawer();
      }

    case"تسجيل مدرسة جديدة":{
      launchURLToWeb("https://my-school-app.com/reg");

    }
      case"Register a new school":{
        launchURLToWeb("https://my-school-app.com/reg");
      }

    }
    if(title == (schoolData?.name??"")){
      Get.to(() =>  SchoolDetailsScreen(schoolId: Get
          .find<StorageService>()
          .getSchoolId),
          transition: Transition.rightToLeftWithFade);
      widget.scaffoldKey.currentState?.openEndDrawer();
    }
  }
  launchURLToWeb(String link) async {
    final Uri url = Uri.parse(link);
    if (!await launchUrl(url,mode:LaunchMode.externalNonBrowserApplication)) {
      throw Exception('Could not launch $url');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(

      backgroundColor: kLightBlueColor,
      child: ListView(
        children: [
          Stack(

              children:[
                Container(
                  height: Get.height*0.17,
                  width:Get.width,

                ),
                Positioned(
                  top:0,
                  right:0, child: Container(
          height: Get.height*0.25,
          width:Get.width*0.45,
          child:  const Padding(
            padding: EdgeInsets.fromLTRB(8.0,0,8.0,0),
            child: Column(
                crossAxisAlignment:CrossAxisAlignment.start,

                children:[

              ]
            ),
          )),),
                Positioned(
                  top:0,
                  left:0,
                  child: Container(
                    width:Get.width*0.9,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment:MainAxisAlignment.center,
                      crossAxisAlignment:CrossAxisAlignment.center,
                      children: [


                        Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          height: Get.height*0.18,
                          width: Get.width*0.3,
                          child: Image.asset(Get.find<StorageService>().activeLocale ==
                              SupportedLocales.english
                              ? "assets/images/appMultiColorLogoEnWithoutbackground.png"
                              : "assets/images/appMultiColorLogoArWithoutbackground.png",fit: BoxFit.fitWidth,),
                        ),
                      ],
                    ),
                  ),
                ),

              ]
          ),
          isLoading?const DrawerLoadingWidget():
          Column(
            children:data.map((e){
              return InkWell(
                onTap:(){
                  detectFunctionalityOfDrawerTap(e.title);
                },
                  child: DrawerTapWidget(title: e.title, iconPath: 'assets/icons/${e.iconName}',));

            }).toList(),
          ),
          const SizedBox(height: 10,),
          isLoadingSocialLink?const SocialLinksLoadingWidget():Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap:(){
                  launchURLToWeb(socialLinkData
                  ?.facebook??"");
                },
                child: SizedBox(
                  height: Get.height*0.04,
                  width: Get.width*0.05,
                  child: Image.asset("assets/icons/facebook_icon.png",fit: BoxFit.fitHeight,),
                ),
              ),
              InkWell(
                onTap:(){
                  launchURLToWeb(socialLinkData
                      ?.whatsApp??"");
                },
                child: SizedBox(
                  height: Get.height*0.04,
                  width: Get.width*0.05,
                  child: Image.asset("assets/icons/twitter_icon.png",fit: BoxFit.fitWidth,),
                ),
              ),
              InkWell(
                onTap:(){
                  launchURLToWeb(socialLinkData
                      ?.instagram??"");
                },
                child: SizedBox(
                  height: Get.height*0.04,
                  width: Get.width*0.05,
                  child: Image.asset("assets/icons/instgram_icon.png",fit: BoxFit.fitWidth,),
                ),
              ),
              InkWell(
                onTap:(){
                  launchURLToWeb(socialLinkData
                      ?.snapchat
                      ??"");
                },
                child: SizedBox(
                  height: Get.height*0.04,
                  width: Get.width*0.05,
                  child: Image.asset("assets/icons/linkedin_icon.png",fit: BoxFit.fitWidth,),
                ),
              ),
              InkWell(
                onTap:(){
                  launchURLToWeb(socialLinkData
                      ?.tiktok??"");
                },
                child: SizedBox(
                  height: Get.height*0.04,
                  width: Get.width*0.05,
                  child: Image.asset("assets/icons/tiktok_icon.png",fit: BoxFit.fitWidth,),
                ),
              ),
              InkWell(
                onTap:(){
                  launchURLToWeb(socialLinkData
                      ?.tiktok??"");
                },
                child: SizedBox(
                  height: Get.height*0.04,
                  width: Get.width*0.05,
                  child: Image.asset("assets/icons/youtube_icon.png",fit: BoxFit.fitWidth,),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
class DrawerItem {
  const DrawerItem(this.title, this.iconName);

  final String title;
  final String iconName;
}