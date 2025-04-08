import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../Utils/Colors_File.dart';

class DrawerLoadingWidget extends StatelessWidget {
  const DrawerLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    height: Get.height*0.06,
                    width: Get.width*0.07,
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
                const SizedBox(
                  width: 10,
                ),
                Container(
                  height: Get.height * 0.02,
                  width: Get.width * 0.4,
                  decoration:   BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color:  const Color(0xFFDFDDDF),
                    boxShadow: const [
                      BoxShadow(
                        color: kGrayColor,
                        blurRadius: 2,
                        offset:
                        Offset(1, 1), // Shadow position
                      ),
                    ],

                  ),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            const Divider(
              color: kYellowColor,
              height: 1,
              thickness: 2,
              endIndent: 30,
              indent: 30,
            ),
          ],
        ).animate(onPlay: (controller) => controller.repeat())
            .shimmer(duration: 1200.ms, color:  kBlueColor.withAlpha(55))
            .animate() // this wraps the previous Animate in another Animate
            .fadeIn(duration: 700.ms, curve: Curves.easeOutQuad)
            .slide(),
        const SizedBox(height: 10,),Column(
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    height: Get.height*0.06,
                    width: Get.width*0.07,
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
                const SizedBox(
                  width: 10,
                ),
                Container(
                  height: Get.height * 0.02,
                  width: Get.width * 0.4,
                  decoration:   BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color:  const Color(0xFFDFDDDF),
                    boxShadow: const [
                      BoxShadow(
                        color: kGrayColor,
                        blurRadius: 2,
                        offset:
                        Offset(1, 1), // Shadow position
                      ),
                    ],

                  ),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            const Divider(
              color: kYellowColor,
              height: 1,
              thickness: 2,
              endIndent: 30,
              indent: 30,
            ),
          ],
        ).animate(onPlay: (controller) => controller.repeat())
            .shimmer(duration: 1200.ms, color:  kBlueColor.withAlpha(55))
            .animate() // this wraps the previous Animate in another Animate
            .fadeIn(duration: 700.ms, curve: Curves.easeOutQuad)
            .slide(),
        const SizedBox(height: 10,),Column(
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    height: Get.height*0.06,
                    width: Get.width*0.07,
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
                const SizedBox(
                  width: 10,
                ),
                Container(
                  height: Get.height * 0.02,
                  width: Get.width * 0.4,
                  decoration:   BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color:  const Color(0xFFDFDDDF),
                    boxShadow: const [
                      BoxShadow(
                        color: kGrayColor,
                        blurRadius: 2,
                        offset:
                        Offset(1, 1), // Shadow position
                      ),
                    ],

                  ),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            const Divider(
              color: kYellowColor,
              height: 1,
              thickness: 2,
              endIndent: 30,
              indent: 30,
            ),
          ],
        ).animate(onPlay: (controller) => controller.repeat())
            .shimmer(duration: 1200.ms, color:  kBlueColor.withAlpha(55))
            .animate() // this wraps the previous Animate in another Animate
            .fadeIn(duration: 700.ms, curve: Curves.easeOutQuad)
            .slide(),
        const SizedBox(height: 10,),Column(
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    height: Get.height*0.06,
                    width: Get.width*0.07,
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
                const SizedBox(
                  width: 10,
                ),
                Container(
                  height: Get.height * 0.02,
                  width: Get.width * 0.4,
                  decoration:   BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color:  const Color(0xFFDFDDDF),
                    boxShadow: const [
                      BoxShadow(
                        color: kGrayColor,
                        blurRadius: 2,
                        offset:
                        Offset(1, 1), // Shadow position
                      ),
                    ],

                  ),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            const Divider(
              color: kYellowColor,
              height: 1,
              thickness: 2,
              endIndent: 30,
              indent: 30,
            ),
          ],
        ).animate(onPlay: (controller) => controller.repeat())
            .shimmer(duration: 1200.ms, color:  kBlueColor.withAlpha(55))
            .animate() // this wraps the previous Animate in another Animate
            .fadeIn(duration: 700.ms, curve: Curves.easeOutQuad)
            .slide(),
        const SizedBox(height: 10,),Column(
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    height: Get.height*0.06,
                    width: Get.width*0.07,
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
                const SizedBox(
                  width: 10,
                ),
                Container(
                  height: Get.height * 0.02,
                  width: Get.width * 0.4,
                  decoration:   BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color:  const Color(0xFFDFDDDF),
                    boxShadow: const [
                      BoxShadow(
                        color: kGrayColor,
                        blurRadius: 2,
                        offset:
                        Offset(1, 1), // Shadow position
                      ),
                    ],

                  ),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            const Divider(
              color: kYellowColor,
              height: 1,
              thickness: 2,
              endIndent: 30,
              indent: 30,
            ),
          ],
        ).animate(onPlay: (controller) => controller.repeat())
            .shimmer(duration: 1200.ms, color:  kBlueColor.withAlpha(55))
            .animate() // this wraps the previous Animate in another Animate
            .fadeIn(duration: 700.ms, curve: Curves.easeOutQuad)
            .slide(),
        const SizedBox(height: 10,),Column(
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    height: Get.height*0.06,
                    width: Get.width*0.07,
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
                const SizedBox(
                  width: 10,
                ),
                Container(
                  height: Get.height * 0.02,
                  width: Get.width * 0.4,
                  decoration:   BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color:  const Color(0xFFDFDDDF),
                    boxShadow: const [
                      BoxShadow(
                        color: kGrayColor,
                        blurRadius: 2,
                        offset:
                        Offset(1, 1), // Shadow position
                      ),
                    ],

                  ),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            const Divider(
              color: kYellowColor,
              height: 1,
              thickness: 2,
              endIndent: 30,
              indent: 30,
            ),
          ],
        ).animate(onPlay: (controller) => controller.repeat())
            .shimmer(duration: 1200.ms, color:  kBlueColor.withAlpha(55))
            .animate() // this wraps the previous Animate in another Animate
            .fadeIn(duration: 700.ms, curve: Curves.easeOutQuad)
            .slide(),
        const SizedBox(height: 10,),

      ],
    );
  }
}
