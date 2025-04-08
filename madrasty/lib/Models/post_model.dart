// To parse this JSON data, do
//
//     final postModel = postModelFromJson(jsonString);

import 'dart:convert';

PostModel postModelFromJson(String str) => PostModel.fromJson(json.decode(str));

String postModelToJson(PostModel data) => json.encode(data.toJson());

class PostModel {
  int? totalPost;
  int? totalPages;
  int? currentPage;
  List<Post>? posts;

  PostModel({
    this.totalPost,
    this.totalPages,
    this.currentPage,
    this.posts,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    totalPost: json["total_post"],
    totalPages: json["total_pages"],
    currentPage: json["currentPage"],
    posts: json["posts"] == null ? [] : List<Post>.from(json["posts"]!.map((x) => Post.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total_post": totalPost,
    "total_pages": totalPages,
    "currentPage": currentPage,
    "posts": posts == null ? [] : List<Post>.from(posts!.map((x) => x.toJson())),
  };
}

class Post {
  int? id;
  User? user;
  String? text;
  String? type;
  List<String?>? images;
  int? userLike;
  int? likeCount;
  int? commentCount;
  String? date;

  Post({
    this.id,
    this.user,
    this.text,
    this.type,
    this.images,
    this.userLike,
    this.likeCount,
    this.commentCount,
    this.date,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    id: json["id"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    text: json["text"],
    type: json["type"],
    images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
    userLike: json["user_like"],
    likeCount: json["like_count"],
    commentCount: json["comment_count"],
    date: json["date"] ,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user?.toJson(),
    "text": text,
    "type": type,
    "images": images == null ? [] : List<String>.from(images!.map((x) => x)),
    "user_like": userLike,
    "like_count": likeCount,
    "comment_count": commentCount,
    "date": date,
  };
}

class User {
  int? id;
  String? name;
  String? type;

  User({
    this.id,
    this.name,
    this.type,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "type": type,
  };
}
