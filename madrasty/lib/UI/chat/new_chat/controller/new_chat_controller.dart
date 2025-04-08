import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:madrasty/UI/chat/message_list/chating_screen.dart';

import '../../../../Models/history_message_list_model.dart';
import '../../../../Services/chat_services.dart';
import '../../../../Utils/memory.dart';
import '../../../../Utils/translation_key.dart';

class NewChatController extends GetxController{
  bool chatHistoryIsLoading = true;
  bool isSearchActive = false;
  bool isFilterActive = false;
  String chosenType = "";
  String chosenTypeFilterName = "";
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  bool showHistoryChatScreen = false;
  List<String> filterTaps = [
  ];
  late TextEditingController searchController;
  late List<HistoryMessagesListModel>? newChatList;
  List<HistoryMessagesListModel>?filteredNewChatList = [];
  List<HistoryMessagesListModel>?searchedNewChatList = [];
  ScrollController scrollController = ScrollController();
  bool isVisible = false;
  @override
  void onInit() {
    super.onInit();
    searchController = TextEditingController();
    getNewChat();
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

  showingHistoryScreenChat(){
    showHistoryChatScreen = !showHistoryChatScreen;
    update();
  }

  getNewChat() async {
    newChatList = await ChatServices.getChatList();
    chatHistoryIsLoading = false;
    update();
  }

  filteringNewChat(String filteredTypeChosen){
    filteredNewChatList = [];
    isFilterActive = true;
    if(searchedNewChatList?.isNotEmpty??false) {
      isSearchActive = false;
      for(var i=0;i<(searchedNewChatList?.length??0);i++){
        if((searchedNewChatList?[i].type?.toLowerCase()??"") == filteredTypeChosen.toLowerCase()){
          filteredNewChatList?.add(searchedNewChatList![i]);
        }
      }
    }else{
      for(var i=0;i<(newChatList?.length??0);i++){

        if((newChatList?[i].type?.toLowerCase()??"") == filteredTypeChosen.toLowerCase()){
          filteredNewChatList?.add(newChatList![i]);
        }
      }
    }
    update();
  }

  searchingNewChat(){
    searchedNewChatList = [];
    isSearchActive = true;
    if(filteredNewChatList?.isNotEmpty??false) {
      isFilterActive = false;
      for(var i=0;i<(filteredNewChatList?.length??0);i++){
        if((filteredNewChatList?[i].name?.toLowerCase()??"").contains(searchController.text.toLowerCase())){
          searchedNewChatList?.add(filteredNewChatList![i]);
        }
      }
    }else{
      for(var i=0;i<(newChatList?.length??0);i++){
        if(("${newChatList?[i].name?.toLowerCase()}").contains(searchController.text.toLowerCase())){
          searchedNewChatList?.add(newChatList![i]);
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
    filteringNewChat(chosenType);
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
    searchedNewChatList = [];
    searchController.clear();
    if(filteredNewChatList?.isNotEmpty??false){
      choosingFilterTap(chosenType);
    }
    update();
  }

  clearFilter(){
    isFilterActive = false;
    filteredNewChatList = [];
    chosenType = "";
    chosenTypeFilterName = "";
    if(searchedNewChatList?.isNotEmpty??false){
      searchingNewChat();
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