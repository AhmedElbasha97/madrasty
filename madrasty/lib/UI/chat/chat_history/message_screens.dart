import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madrasty/Utils/Colors_File.dart';
import '../../../Utils/constant.dart';
import '../../../Utils/localization_services.dart';
import '../../../Utils/memory.dart';
import '../../../Widgets/custom_text_widget.dart';
import '../new_chat/new_chat_screen.dart';
import 'controller/chat_controller.dart';
import 'widget/history_chat_cell.dart';
import 'widget/loading_chat_list_widget.dart';

class MessageScreens extends StatelessWidget {
  const MessageScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ChatController(),
      builder: (ChatController controller) => controller.showNewChatScreen?const NewChatScreen() :SizedBox(
        height: Get.height*0.72,
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: controller.scrollController,
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      PopupMenuButton<String>(
                        constraints: BoxConstraints(
                          maxWidth: Get.width * 0.65,
                          minWidth: Get.width * 0.65,
                        ),
                        itemBuilder: (context) =>
                            controller.filterTaps.map((e) {
                              return PopupMenuItem(
                                value: e,
                                textStyle: TextStyle(
                                    color: kDarkBlueColor,
                                    fontFamily:
                                    Get.find<StorageService>().activeLocale ==
                                        SupportedLocales.english
                                        ? fontFamilyEnglishName
                                        : fontFamilyArabicName,
                                    fontWeight: FontWeight.w700),
                                onTap: () {
                                  controller.choosingFilterTap(e);
                                },
                                child: SizedBox(
                                  width: Get.width * 0.45,
                                  child: Column(
                                    children: [
                                      CustomText(
                                        e,
                                        style: TextStyle(
                                            color: kLightBlueColor,
                                            fontFamily: Get.find<StorageService>()
                                                .activeLocale ==
                                                SupportedLocales.english
                                                ? fontFamilyEnglishName
                                                : fontFamilyArabicName,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      e == controller.filterTaps.last
                                          ? const SizedBox()
                                          : const Divider(
                                        color: kLightBlueColor,
                                        height: 1,
                                        thickness: 1,
                                        endIndent: 0,
                                        indent: 0,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                        color: kDarkBlueColor,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 0),
                          child: Container(
                            constraints: BoxConstraints(
                              minHeight: Get.height * 0.06,
                            ),
                            width: Get.width * 0.7,
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
                                      width: Get.width * 0.6,
                                      child: CustomText(
                                        textAlign: TextAlign.center,
                                        maxLines: 3,
                                        controller.chosenTypeFilterName==""?Get.find<StorageService>()
                                            .activeLocale ==
                                            SupportedLocales.english
                                            ?"Choose who you want to talk to":"أختر من تريد التحجث أليه":controller.chosenTypeFilterName,
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
                                    const Icon(Icons.arrow_downward_sharp,
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
                          controller.clearFilter();
                        },
                        child: Container(
                          height:Get.height * 0.06,
                          decoration: BoxDecoration(
                            border: Border.all(color: kBlackColor,width: 1,),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomText(
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                Get.find<StorageService>()
                                    .activeLocale ==
                                    SupportedLocales.english
                                    ?"Clear the filter":"أمسح التصفيه",
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
                                  color: kBlackColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                    children: [
                      Container(
                        height: Get.height*0.06,
                        width: Get.width*0.7,
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
                        child: TextField(
                          controller: controller.searchController,
                          onSubmitted: (e) {
                            controller.searchingChatHistory();
                          },
                          keyboardType: TextInputType.name,
                          style:  TextStyle(
                              fontFamily: Get.find<StorageService>()
                                  .activeLocale ==
                                  SupportedLocales.english
                                  ? fontFamilyEnglishName
                                  : fontFamilyArabicName,
                              color:kDarkBlueColor,
                              fontWeight: FontWeight.w800,
                              fontSize: 13),
                          decoration: InputDecoration(
                            labelText: Get.find<StorageService>()
                                .activeLocale ==
                                SupportedLocales.english
                                ? 'Search':"أبحث",

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: InkWell(
                              onTap: (){
                                controller.searchingChatHistory();
                              },
                              child: Container(
                                width: Get.width*0.2,
                                height: Get.height*0.01,
                                decoration: const BoxDecoration(
                                  color: kDarkBlueColor,
                                  borderRadius: BorderRadius.only(
                                    topLeft:  Radius.circular(10.0),
                                    bottomLeft:  Radius.circular(10.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomText(
                                  Get.find<StorageService>()
                                      .activeLocale ==
                                      SupportedLocales.english
                                      ? 'Search':"أبحث",
                                          style:  TextStyle(
                                              fontFamily: Get.find<StorageService>()
                                                  .activeLocale ==
                                                  SupportedLocales.english
                                                  ? fontFamilyEnglishName
                                                  : fontFamilyArabicName,
                                              color:Colors.white,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 11)
                                      ),
                                      const SizedBox(width: 2,),
                                      const Icon(Icons.search,color: Colors.white,)

                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          controller.clearSearch();
                        },
                        child: Container(
                          height:Get.height * 0.06,
                          width: Get.width*0.265,
                          decoration: BoxDecoration(
                            border: Border.all(color: kBlackColor,width: 1,),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomText(
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                Get.find<StorageService>()
                                    .activeLocale ==
                                    SupportedLocales.english
                                    ?"Clear the search":"أمسح البحث",
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
                                  color: kBlackColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                  const SizedBox(height: 5,),
                  controller.chatHistoryIsLoading?LoadingChatListWidget():controller.isSearchActive?controller.searchedChatHistoryList?.isEmpty??false?Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/no_search_data.png",height: Get.width*0.65,),
                      CustomText(Get.find<StorageService>()
                          .activeLocale ==
                          SupportedLocales.english
                          ?"no user with this name: ${controller.searchController.text}":"  لا يوجد مستخدم بهذا الاسم:${controller.searchController.text}",style:   TextStyle(color: kDarkBlueColor, fontFamily: Get.find<StorageService>()
                          .activeLocale ==
                          SupportedLocales.english
                          ? fontFamilyEnglishName
                          : fontFamilyArabicName,fontWeight: FontWeight.bold,fontSize: 30),textAlign: TextAlign.center,),
                      const SizedBox(height: 30,),

                      InkWell(
                        onTap: (){controller.clearSearch();},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Container(
                            height: 50,
                            width: 200,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: kDarkBlueColor,
                                  width: 2.0,
                                  style: BorderStyle.solid
                              ),
                              borderRadius: BorderRadius.circular(10),

                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:  [CustomText(
                                    Get.find<StorageService>()
                                        .activeLocale ==
                                        SupportedLocales.english
                                        ?"Clear the search":"أمسح البحث",
                                    style:  TextStyle(
                                        fontFamily: Get.find<StorageService>()
                                            .activeLocale ==
                                            SupportedLocales.english
                                            ? fontFamilyEnglishName
                                            : fontFamilyArabicName,
                                        color:kDarkBlueColor,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 15)
                                ),
                                  const SizedBox(width: 10,),
                                  const Icon(Icons.clear,color: kDarkBlueColor,)
                                ],

                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                      :Column(
                    children: controller.searchedChatHistoryList!.map((e){
                      return  HistoryChatUserCard(press: () async {
                        controller.goToMessageScreen(e.type??"", "${e.id??0}",e.name??"");

                      },chat: e,);
                    }).toList(),
                  ):controller.isFilterActive?controller.filteredChatHistoryList?.isEmpty??false?
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/No data-cuate.png",height: Get.width*0.65,),
                      CustomText(Get.find<StorageService>()
                          .activeLocale ==
                          SupportedLocales.english
                          ?"there's no ${controller.chosenTypeFilterName} you can chat with him now":" لا يوجد  ${controller.chosenTypeFilterName} يمكنك الدردشة معه الآن",style:   TextStyle(color: kDarkBlueColor, fontFamily: Get.find<StorageService>()
                          .activeLocale ==
                          SupportedLocales.english
                          ? fontFamilyEnglishName
                          : fontFamilyArabicName,fontWeight: FontWeight.bold,fontSize: 30),textAlign: TextAlign.center,),
                      const SizedBox(height: 30,),

                      InkWell(
                        onTap: (){controller.clearSearch();},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Container(
                            height: 50,
                            width: 200,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: kDarkBlueColor,
                                  width: 2.0,
                                  style: BorderStyle.solid
                              ),
                              borderRadius: BorderRadius.circular(10),

                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:  [Text(
                                    Get.find<StorageService>()
                                        .activeLocale ==
                                        SupportedLocales.english
                                        ?"Clear the filter":"أمسح التصفيه",
                                    style:  TextStyle(
                                        fontFamily: Get.find<StorageService>()
                                            .activeLocale ==
                                            SupportedLocales.english
                                            ? fontFamilyEnglishName
                                            : fontFamilyArabicName,
                                        color:kDarkBlueColor,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 20)
                                ),
                                  const SizedBox(width: 10,),
                                  const Icon(Icons.clear,color: kDarkBlueColor,)
                                ],

                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ):Column(
                    children: controller.filteredChatHistoryList!.map((e){
                      return  HistoryChatUserCard(press: () async {
                        controller.goToMessageScreen(e.type??"", "${e.id??0}",e.name??"");

                      }, chat: e,);
                    }).toList(),
                  ):Column(
                    children: controller.chatHistoryList!.map((e){
                      return  HistoryChatUserCard(press: () async {
                        controller.goToMessageScreen(e.type??"", "${e.id??0}",e.name??"");
                      },chat: e,);
                    }).toList(),
                  )
                ],
              ),
            ),

            Positioned(
              bottom: 10,
              left: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Visibility(
                  visible: controller.isVisible,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: (){
                        controller.goUpToTopOfSScreen();
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
                            Icons.arrow_upward_sharp,
                            weight: 30,
                            color: kLightBlueColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: (){
                        controller.showingNewScreenChat();
                        Get.delete<ChatController>();
                      },
                      child: Container(
                        width: Get.width*0.32,
                        height: Get.height*0.09,
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
                            borderRadius: BorderRadius.circular(30),

                            color: kDarkBlueColor
                        ),
                        child:  Center(
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.chat,
                                weight: 30,
                                color: kLightBlueColor,
                              ),
                              const SizedBox(width: 10,),
                              CustomText(
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                Get.find<StorageService>()
                                    .activeLocale ==
                                    SupportedLocales.english
                                    ?"new chat":"دردشة جديدة",
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),


                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
