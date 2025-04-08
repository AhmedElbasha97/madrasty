import 'dart:io';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:video_compress/video_compress.dart';
import '../Models/history_message_list_model.dart';
import '../Models/messages_list_model.dart';
import '../Models/post_status_model.dart';
import '../Models/response_model.dart';
import '../Utils/api_service.dart';
import '../Utils/memory.dart';
import '../Utils/services.dart';

class ChatServices{
  static ApiService api = ApiService();

  static Future<List<HistoryMessagesListModel>?>getHistoryChatListList() async {
    List<HistoryMessagesListModel>?chatHistoryList = [];
    var data = await api.request(Services.getChatHistoryListEndPoint, "POST",queryParamters: {
      "user_id": Get
          .find<StorageService>()
          .getId,
      "user_type": Get
          .find<StorageService>()
          .getUserType,
    });
    if (data != null) {
      for(var chatHistoryData  in data){
        chatHistoryList.add(HistoryMessagesListModel.fromJson(chatHistoryData));
      }
      return chatHistoryList;
    }
    return null;
  }

  static Future<List<HistoryMessagesListModel>?>getChatList() async {
    List<HistoryMessagesListModel>?chatList = [];
    var data = await api.request(Services.getChatListEndPoint, "POST",queryParamters: {
      "user_id": Get
          .find<StorageService>()
          .getId,
      "user_type": Get
          .find<StorageService>()
          .getUserType,
    });
    if (data != null) {
      for(var chatData  in data){
        chatList.add(HistoryMessagesListModel.fromJson(chatData));
      }
      return chatList;
    }
    return null;
  }

  static Future<List<MessagesListModel>?>getMessagesList(String receiverId,String receiverType,) async {
    List<MessagesListModel>?chatList = [];
    var data = await api.request(Services.getMessageListEndPoint, "POST",queryParamters: {
      "user2_id": Get
          .find<StorageService>()
          .getId,
      "user2_type": Get
          .find<StorageService>()
          .getUserType,
      "user1_id": receiverId,
      "user1_type":receiverType,
    });
    if (data != null) {
      for(var chatData  in data){
        chatList.add(MessagesListModel.fromJson(chatData));
      }
      return chatList;
    }
    return null;
  }

  static Future<ResponseModel?>sendMessage(String receiverId,String receiverType,String textMessage,File? messageFile,String msgType) async {


    File? compressedFile;

     if(msgType == "VID"){
       MediaInfo? mediaInfo = await VideoCompress.compressVideo(
         messageFile?.path??"",
      quality: VideoQuality.LowQuality,
      deleteOrigin: false, // It's false by default
    );
     compressedFile = File(mediaInfo?.file?.path??"");
     }

    final formData = dio.FormData.fromMap({
      "recip_id":receiverId,
      "recip_type":receiverType,
      "msg_text":textMessage,
      "msg_file":messageFile?.path.isEmpty??true?null:
      msgType == "VID"?await dio.MultipartFile.fromFile(compressedFile?.path??"", filename: messageFile?.path.split('/').last??""):
      await dio.MultipartFile.fromFile(messageFile?.path??"", filename: messageFile?.path.split('/').last??""),
      "msg_type": msgType,
      "sender_id":Get.find<StorageService>().getId,
      "sender_type":Get.find<StorageService>().getUserType,
    });
    var data = await api.request(Services.sendMessageEndPoint, "POST",data: formData);
    if (data != null) {
      return ResponseModel.fromJson(data);
    }
    return null;
  }
  static Future<PostStatusModel?>getFileStatus(String fileName) async {

    var data = await api.request(Services.getFileStatusEndPoint, "POST",data: {
      "file":fileName
    });
    if (data != null) {
      return PostStatusModel.fromJson(data);
    }
    return null;
  }
}