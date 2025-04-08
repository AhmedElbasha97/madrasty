import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:madrasty/Services/chat_services.dart';

import '../../../../Models/history_message_list_model.dart';
import '../../../../Utils/memory.dart';
import '../../../../Utils/translation_key.dart';
import '../../message_list/chating_screen.dart';

class ChatController extends GetxController{
  bool chatHistoryIsLoading = true;
  bool isSearchActive = false;
  bool isFilterActive = false;
  String chosenType = "";
  String chosenTypeFilterName = "";
  bool showNewChatScreen = false;
  List<String> filterTaps = [
 ];
 late TextEditingController searchController;
 late List<HistoryMessagesListModel>? chatHistoryList;
 List<HistoryMessagesListModel>?filteredChatHistoryList = [];
 List<HistoryMessagesListModel>?searchedChatHistoryList = [];
  ScrollController scrollController = ScrollController();
  bool isVisible = false;
 @override
  void onInit() {
    super.onInit();
    searchController = TextEditingController();
    getChatHistory();
    fillingFilterTaps();
    scrollController.addListener(() {
      if ((scrollController.position.pixels ) == (scrollController.position.maxScrollExtent)) {

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
  goUpToTopOfSScreen(){
    scrollController.animateTo( //go to top of scroll
        0,  //scroll offset to go
        duration: const Duration(milliseconds: 500), //duration of scroll
        curve:Curves.fastOutSlowIn //scroll type
    );
    isVisible = false;
    update();
  }
  showingNewScreenChat(){
   showNewChatScreen = !showNewChatScreen;
   update();
  }
  getChatHistory() async {
    chatHistoryList = await ChatServices.getHistoryChatListList();
    chatHistoryIsLoading = false;
    update();
  }

  filteringChatHistory(String filteredTypeChosen){
    filteredChatHistoryList = [];
    isFilterActive = true;
    if(searchedChatHistoryList?.isNotEmpty??false) {
      isSearchActive = false;
      for(var i=0;i<(searchedChatHistoryList?.length??0);i++){
        if((searchedChatHistoryList?[i].type?.toLowerCase()??"") == filteredTypeChosen.toLowerCase()){
          filteredChatHistoryList?.add(searchedChatHistoryList![i]);
        }
      }
    }else{
      for(var i=0;i<(chatHistoryList?.length??0);i++){
        if((chatHistoryList?[i].type?.toLowerCase()??"") == filteredTypeChosen.toLowerCase()){
          filteredChatHistoryList?.add(chatHistoryList![i]);
        }
      }
    }
    update();
  }

  searchingChatHistory(){
   searchedChatHistoryList = [];
    isSearchActive = true;
    if(filteredChatHistoryList?.isNotEmpty??false) {
      isFilterActive = false;
      for(var i=0;i<(filteredChatHistoryList?.length??0);i++){
        if((filteredChatHistoryList?[i].name?.toLowerCase()??"").contains(searchController.text.toLowerCase())){
          searchedChatHistoryList?.add(filteredChatHistoryList![i]);
        }
      }
    }else{
      for(var i=0;i<(chatHistoryList?.length??0);i++){
        if(("${chatHistoryList?[i].name?.toLowerCase()}").contains(searchController.text.toLowerCase())){
          searchedChatHistoryList?.add(chatHistoryList![i]);
        }
      }

    }
    update();
  }

  choosingFilterTap(String chosenTap){
    chosenTap == userType2.tr?{chosenType="TEACHER",chosenTypeFilterName = chosenTap}
        :chosenTap == userType1.tr?{chosenType="PARENT",chosenTypeFilterName = chosenTap}
        :chosenTap == userType3.tr?{chosenType="STUDENT",chosenTypeFilterName = chosenTap}
        :chosenTap == userType4.tr?{chosenType="SUPERVISOR",chosenTypeFilterName = chosenTap}
        :chosenTap == userType5.tr?{chosenType="DRIVER",chosenTypeFilterName = chosenTap}:"";
    filteringChatHistory(chosenType);
  }

  fillingFilterTaps(){
    String userType = Get.find<StorageService>().getUserType;
    switch(userType){
      case "TEACHER":{
        filterTaps =[
          userType1.tr,
          userType2.tr,
          userType3.tr,
          userType4.tr,

        ];
        update();
      }
      break;
      case "PARENT":{
        filterTaps =[
          userType1.tr,
          userType2.tr,
          userType5.tr,
          userType4.tr,

        ];
        update();
      }
      break;
      case "STUDENT":{
        filterTaps =[
          userType2.tr,
          userType5.tr,
          userType4.tr,

        ];
        update();
      }
      break;
      case "SUPERVISOR":{
        filterTaps =[
          userType1.tr,
          userType2.tr,
          userType3.tr,
          userType5.tr,
        ];
        update();
      }
      break;
      case "DRIVER":{
        filterTaps =[
          userType1.tr,
          userType3.tr,
        ];
        update();
      }
      break;
    }
  }

  clearSearch(){
    isSearchActive = false;
    searchedChatHistoryList = [];
    searchController.clear();
    if(filteredChatHistoryList?.isNotEmpty??false){
      choosingFilterTap(chosenType);
    }
    update();
  }

  clearFilter(){
    isFilterActive = false;
    filteredChatHistoryList = [];
     chosenType = "";
     chosenTypeFilterName = "";
    if(searchedChatHistoryList?.isNotEmpty??false){
      searchingChatHistory();
    }
    update();
  }

  String detectUserTypeTranslated(String userType){
   String userTypeTranslated = "";
   switch(userType){
     case "TEACHER":{
       userTypeTranslated =userType2.tr;
       update();
     }
     break;
     case "PARENT":{
       userTypeTranslated =userType1.tr;
       update();
     }
     break;
     case "STUDENT":{
       userTypeTranslated = userType3.tr;
       update();
     }
     break;
     case "DRIVER":{
       userTypeTranslated = userType5.tr;
       update();
     }
     break;
     case "SUPERVISOR":{
       userTypeTranslated = userType4.tr;
       update();
     }
     break;
   }

   return userTypeTranslated;

  }
  goToMessageScreen(String receiverType,String receiverId,String receiverName){
    Get.to(ChattingScreen(receiverId: receiverId, receiverType: receiverType, receiverName: receiverName,));
  }
}
