// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:madrasty/Models/comment_model.dart';
import 'package:madrasty/UI/posts/widgets/comment_widget.dart';

import '../../../Utils/Colors_File.dart';

class ShowMoreCommentScreen extends StatefulWidget {
  const ShowMoreCommentScreen({super.key, this.comments});
  final List<CommentModel>? comments;

  @override
  State<ShowMoreCommentScreen> createState() => _ShowMoreCommentScreenState();
}

class _ShowMoreCommentScreenState extends State<ShowMoreCommentScreen> {
  ScrollController scrollController = ScrollController();

  bool isVisible = false;
  goUpToTopOfSScreen(){
    scrollController.animateTo( //go to top of scroll
        0,  //scroll offset to go
        duration: const Duration(milliseconds: 500), //duration of scroll
        curve:Curves.fastOutSlowIn //scroll type
    );
    isVisible = false;
    setState(() {
    });
  }
  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if ((scrollController.position.pixels ) == (scrollController.position.maxScrollExtent)) {
        print(scrollController.position.pixels);
        print(scrollController.position.maxScrollExtent);
      }
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (isVisible == true) {

          isVisible = false;
          setState(() {

          });
        }
      } else {
        if (scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (isVisible == false) {

            isVisible = true;
            setState(() {

            });
          }
        }
      }
    });
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

      body: Container(
        width: Get.width,
        decoration: const BoxDecoration(
          color: kYellowColor,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            width: Get.width,
            height: Get.height * 0.97,
            decoration: const BoxDecoration(
              color: kLightBlueColor,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30.0),
                  topLeft: Radius.circular(30.0)),
            ),
            child: Center(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children:  widget.comments!.map<Widget>((e){
                    return CommentWidget(commentData: e);
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
