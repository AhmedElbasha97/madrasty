import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../../../Utils/Colors_File.dart';

class LoadingChatListWidget extends StatelessWidget {
   LoadingChatListWidget({super.key});
 final List<bool> fakingMessages = [true,false,false,false,true,true,true,false,true,true];

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: fakingMessages.map((e){
        return InkWell(
            onTap: (){
            },
            child: SizedBox(
              height: Get.height*0.17,
              child:  Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFDFDDDF),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                                color: const Color(0xFFDFDDDF),
                                borderRadius: BorderRadius.circular(50)
                            ),
                          ).animate(onPlay: (controller) => controller.repeat())
                              .shimmer(duration: 1200.ms, color:   kBlueColor.withAlpha(55))
                              .animate() // this wraps the previous Animate in another Animate
                              .fadeIn(duration: 1200.ms, curve: Curves.easeOutQuad)
                              .slide(),
                          const SizedBox(width:10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 100,
                                height: 20,
                                decoration: BoxDecoration(
                                    color: const Color(0xFFDFDDDF),
                                    borderRadius: BorderRadius.circular(50)
                                ),
                              ).animate(onPlay: (controller) => controller.repeat())
                                  .shimmer(duration: 1200.ms, color:   kBlueColor.withAlpha(55))
                                  .animate() // this wraps the previous Animate in another Animate
                                  .fadeIn(duration: 1200.ms, curve: Curves.easeOutQuad)
                                  .slide(),
                              const SizedBox(height: 10,),
                              Container(
                                width: 200,
                                height: 20,
                                decoration: BoxDecoration(
                                    color: const Color(0xFFDFDDDF),
                                    borderRadius: BorderRadius.circular(50)
                                ),
                              ).animate(onPlay: (controller) => controller.repeat())
                                  .shimmer(duration: 1200.ms, color:   kBlueColor.withAlpha(55))
                                  .animate() // this wraps the previous Animate in another Animate
                                  .fadeIn(duration: 1200.ms, curve: Curves.easeOutQuad)
                                  .slide(),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    color: kDarkBlueColor,
                    height: 1,
                    thickness: 2,

                  ),
                ],
              ),
            )
        );
      }).toList(),

    ).animate(onPlay: (controller) => controller.repeat())
        .shimmer(duration: 1200.ms, color:   kBlueColor.withAlpha(55))
        .animate() // this wraps the previous Animate in another Animate
        .fadeIn(duration: 1200.ms, curve: Curves.easeOutQuad)
        .slide();
  }
}
