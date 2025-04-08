
// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:madrasty/Models/comment_model.dart';
import 'package:madrasty/Models/parent_share_model.dart';
import 'package:madrasty/Models/student_share_model.dart';

import '../Models/like_model.dart';
import '../Models/person_info_model.dart';
import '../Models/post_model.dart';
import '../Models/post_status_model.dart';
import '../Models/posting_status_model.dart';
import '../Models/response_model.dart';
import '../Utils/api_service.dart';
import '../Utils/memory.dart';
import '../Utils/services.dart';
import '../Utils/translation_key.dart';

class PostingServices {
  static ApiService api = ApiService();

  static Future<PostModel?>getPostsList(String schoolId,String classId,String page,String teacherId,) async {
    var data = await api.request(Services.getPostsEndPoint, "POST",queryParamters: {
      "school_id":schoolId,
      "class_id":classId,
      "teacher_id": Get
          .find<StorageService>()
          .getId=="TEACHER"?Get
          .find<StorageService>()
          .getId:teacherId,
      "user_type": Get
          .find<StorageService>()
          .getUserType,


      "page":page,
    });
    if (data != null) {

      return  PostModel.fromJson(data);
    }
    return null;
  }
  static Future<PostModel?>getPostsListAfterFiltering(String schoolId,String classId,String page,String teacherId,String filterUserId,String filterUserType,String filterPostType) async {
    Map<String, dynamic>? queryParametersWillBeSent = {
      "school_id":schoolId,
      "class_id":classId,
      "teacher_id": Get
          .find<StorageService>()
          .getId=="TEACHER"?Get
          .find<StorageService>()
          .getId:teacherId,
      "user_type": Get
          .find<StorageService>()
          .getUserType,

      "page":page,
    };
    if(filterUserId!="0"){
      queryParametersWillBeSent.addAll({"filter_user_id":filterUserId});
    }
    if(filterUserType!="0"){
      queryParametersWillBeSent.addAll({
        "filter_user_type":filterUserType == userType2.tr?"TEACHER":filterUserType == userType1.tr?"PARENT":filterUserType == userType3.tr?"STUDENT":"0",
        });
    }
    if(filterPostType!="0"){
      queryParametersWillBeSent.addAll({

        "filter_type":filterPostType == postType1.tr?"TXT":filterPostType == postType2.tr?"VID":filterPostType == postType3.tr?"IMG":filterPostType == postType4.tr?"FIL":"0",
      });
    }
    var data = await api.request(Services.getPostsEndPoint, "POST",queryParamters: queryParametersWillBeSent);
    if (data != null) {

      return  PostModel.fromJson(data);
    }
    return null;
  }
  static Future<Post?>getPost(String postId) async {
    var data = await api.request(Services.getPostDataEndPoint, "POST",queryParamters: {

      "teacher_id": Get
          .find<StorageService>()
          .getId,
      "user_type": Get
          .find<StorageService>()
          .getUserType,
      "post_id":postId,
    });
    if (data != null) {

      return  Post.fromJson(data);
    }
    return null;
  }
  static Future<PersonInfoModel?>getPersonInfoData() async {
    var data = await api.request(Services.getPersonDataEndPoint, "POST",queryParamters: {

      "user_id": Get
          .find<StorageService>()
          .getId,
      "type": Get
          .find<StorageService>()
          .getUserType,
    });
    if (data != null) {

      return  PersonInfoModel.fromJson(data);
    }
    return null;
  }
  static Future<List<ParentShareModel>?>getParentShareList(String schoolId,String classId) async {
    List<ParentShareModel>?parentsData = [];
    var data = await api.request(Services.getParentShareEndPoint, "POST",queryParamters: {
      "school_id":schoolId,
      "class_id":classId,
    });
    if (data != null) {
      for(var parentData  in data){
        parentsData.add(ParentShareModel.fromJson(parentData));
      }
      return parentsData;
    }
    return null;
  }
  static Future<List<StudentShareModel>?>getStudentShareList(String schoolId,String classId) async {
    List<StudentShareModel>?studentsData = [];
    var data = await api.request(Services.getStudentShareEndPoint, "POST",queryParamters: {
      "school_id":schoolId,
      "class_id":classId,
    });
    if (data != null) {
      for(var studentData  in data){
        studentsData.add(StudentShareModel.fromJson(studentData));
      }
      return studentsData;
    }
    return null;
  }
  static Future<List<StudentShareModel>?>getTeacherShareList(String schoolId) async {
    List<StudentShareModel>?studentsData = [];
    var data = await api.request(Services.getTeacherShareEndPoint, "POST",queryParamters: {
      "school_id":schoolId,

    });
    if (data != null) {
      for(var studentData  in data){
        studentsData.add(StudentShareModel.fromJson(studentData));
      }
      return studentsData;
    }
    return null;
  }

  static Future<ResponseModel?>addPost(String schoolId,String postText,List<String> classId,List<String> teacherId, List<File>? imagesFile,String postType) async {
    final multipartFile = imagesFile?.map((e) async {
      return dio.MultipartFile.fromFile(e.path);
    }).toList();
   String classIdData = "";
   String teacherIdData = "";
   for (String e in classId){
     if(e == classId.last){
       classIdData = "$classIdData$e";
     }else{
       classIdData = "$classIdData$e,";
     }
   }
   for (String e in teacherId){
     if(e == teacherId.last){
       teacherIdData = "$teacherIdData$e";
     }else{
       teacherIdData = "$teacherIdData$e,";
     }
   }
    final formData = dio.FormData.fromMap({
      "school_id": schoolId,
      "class_id": Get.find<StorageService>().getUserType == "TEACHER"?classIdData:classId[0],
      "post_type": postType,
      "teacher_id":Get.find<StorageService>().getUserType == "TEACHER"? [Get
          .find<StorageService>()
          .getId]:teacherIdData,
      "text":postText,
      "user_id": Get
          .find<StorageService>()
          .getId,
      "user_type": Get
          .find<StorageService>()
          .getUserType,

    });
    for (int i = 0; i < (imagesFile?.length??0); i++) {
      String fileName = imagesFile?[i].path
          .split('/')
          .last ?? "";
      formData.files.add(
        MapEntry(
          "imgs[]", // Key for the backend
          await dio.MultipartFile.fromFile(
              imagesFile?[i].path??"", filename: fileName),
        ),
      );
    }
    var data = await api.request(Services.addPostsEndPoint, "POST", data: formData);
    if (data != null) {
      return ResponseModel.fromJson(data);
    }
    return null;
  }
    static Future<LikeModel?>getUserLikedPostOrNot(String postId) async {

    var data = await api.request(Services.getUserLikedPostOrNotEndPoint, "POST",data: {
      "post_id":postId,
      "user_id":Get.find<StorageService>().getId,
      "user_type":Get.find<StorageService>().getUserType,
    });

    if (data != null) {
      return LikeModel.fromJson(data);
    }
    return null;
  }
  static Future<PostStatusModel?> checkPostAvailability(String postId) async {
    var data = await api.request(Services.checkPostAvailabilityEndPoint, "POST",data: {
    "post_id":postId,
    });
    if (data != null) {
      return PostStatusModel.fromJson(data);
    }
    return null;
  }
  static Future<ResponseModel?>addComment(String commentText,String postId,) async {

    var data = await api.request(Services.addCommentEndPoint, "POST",data: {
      "post_id":postId,
      "text":commentText,
      "user_id":Get.find<StorageService>().getId,
      "user_type":Get.find<StorageService>().getUserType,
    });
    if (data != null) {
      return ResponseModel.fromJson(data);
    }
    return null;
  }
  static Future<PostingStatusModel?>getPostingStatus(String classId) async {

    var data = await api.request(Services.getPostStatusEndPoint, "POST",data: {
      "class_id":classId,
      "teacher_id":Get.find<StorageService>().getId,
    });
    if (data != null) {
      return PostingStatusModel.fromJson(data);
    }
    return null;
  }
  static Future<List<CommentModel>?>getCommentsList(String postId,) async {
    List<CommentModel>?commentsData = [];

    var data = await api.request(Services.getCommentsListEndPoint, "POST",data: {
      "post_id":postId,

    });
    if (data != null) {
      for(var commentData  in data){
        commentsData.add(CommentModel.fromJson(commentData));
      }
      return commentsData;
    }
    return null;
  }
  static Future<ResponseModel?>likeOrDisLikePost(String postId,) async {
    var data = await api.request(Services.likeOrDislikePostEndPoint, "POST",data: {
      "post_id":postId,
      "user_id":Get.find<StorageService>().getId,
      "user_type":Get.find<StorageService>().getUserType,
    });
    if (data != null) {
      return ResponseModel.fromJson(data);
    }
    return null;
  }
  static Future<ResponseModel?>editPostingStatus(String parentStatus,String studentStatus,String classId) async {
    var data = await api.request(Services.editingPostStatusEndPoint, "POST",data: {
      "class_id":classId,
      "parents":parentStatus,
      "students":studentStatus,
      "teacher_id":Get.find<StorageService>().getId,
    });
    if (data != null) {
      return ResponseModel.fromJson(data);
    }
    return null;
  }
  static Future<ResponseModel?> reportingPost(String postId,String reportText) async {
    var data = await api.request(Services.reportingPostEndPoint, "POST",data: {
      "post_id":postId,
      "text":reportText,
      "user_id":Get.find<StorageService>().getId,
      "user_type":Get.find<StorageService>().getUserType,
    });
    if (data != null) {
      return ResponseModel.fromJson(data);
    }
    return null;
  }
  static Future<List<StudentShareModel>?>getSubjectsList(String schoolId,) async {
    List<StudentShareModel>?subjectsData = [];

    var data = await api.request(Services.getSubjectsListEndPoint, "POST",data: {
      "school_id":schoolId,

    });
    if (data != null) {
      for(var subjectData  in data){
        subjectsData.add(StudentShareModel.fromJson(subjectData));
      }
      return subjectsData;
    }
    return null;
  }
}