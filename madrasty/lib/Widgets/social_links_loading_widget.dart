import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../Utils/Colors_File.dart';

class SocialLinksLoadingWidget extends StatelessWidget {
  const SocialLinksLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InkWell(
          onTap: () {},
          child: Container(
            height: Get.height*0.04,
            width: Get.width*0.05,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFDFDDDF)

            ),

          ).animate(onPlay: (controller) => controller.repeat())
              .shimmer(duration: 1200.ms, color:  kBlueColor.withAlpha(55))
              .animate() // this wraps the previous Animate in another Animate
              .fadeIn(duration: 700.ms, curve: Curves.easeOutQuad)
              .slide(),
        ),
        InkWell(
          onTap: () {},
          child: Container(
            height: Get.height*0.04,
            width: Get.width*0.05,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFDFDDDF)

            ),

          ).animate(onPlay: (controller) => controller.repeat())
              .shimmer(duration: 1200.ms, color:  kBlueColor.withAlpha(55))
              .animate() // this wraps the previous Animate in another Animate
              .fadeIn(duration: 700.ms, curve: Curves.easeOutQuad)
              .slide(),
        ),
        InkWell(
          onTap: () {},
          child: Container(
            height: Get.height*0.04,
            width: Get.width*0.05,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFDFDDDF)

            ),

          ).animate(onPlay: (controller) => controller.repeat())
              .shimmer(duration: 1200.ms, color:  kBlueColor.withAlpha(55))
              .animate() // this wraps the previous Animate in another Animate
              .fadeIn(duration: 700.ms, curve: Curves.easeOutQuad)
              .slide(),
        ),
        InkWell(
          onTap: () {},
          child: Container(
            height: Get.height*0.04,
            width: Get.width*0.05,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFDFDDDF)

            ),

          ).animate(onPlay: (controller) => controller.repeat())
              .shimmer(duration: 1200.ms, color:  kBlueColor.withAlpha(55))
              .animate() // this wraps the previous Animate in another Animate
              .fadeIn(duration: 700.ms, curve: Curves.easeOutQuad)
              .slide(),
        ),
        InkWell(
          onTap: () {},
          child: Container(
            height: Get.height*0.04,
            width: Get.width*0.05,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFDFDDDF)

            ),

          ).animate(onPlay: (controller) => controller.repeat())
              .shimmer(duration: 1200.ms, color:  kBlueColor.withAlpha(55))
              .animate() // this wraps the previous Animate in another Animate
              .fadeIn(duration: 700.ms, curve: Curves.easeOutQuad)
              .slide(),
        ),
        InkWell(
          onTap: () {},
          child: Container(
            height: Get.height*0.04,
            width: Get.width*0.05,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFDFDDDF)

            ),

          ).animate(onPlay: (controller) => controller.repeat())
              .shimmer(duration: 1200.ms, color:  kBlueColor.withAlpha(55))
              .animate() // this wraps the previous Animate in another Animate
              .fadeIn(duration: 700.ms, curve: Curves.easeOutQuad)
              .slide(),
        ),
      ],
    );
  }
}
