import 'package:flutter/material.dart';

class InvertedTrianglePainter extends CustomPainter {
  Color colorOfIndicator;

  InvertedTrianglePainter(this.colorOfIndicator);

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    final double bluntHeight =
        height * 0.3; // Adjust the blunt height as per your requirement
    final double bluntOffset =
        width * 0.05; // Adjust the blunt offset as per your requirement

    final path = Path();
    path.moveTo(0, 0); // Top left corner

    path.lineTo(width, 0); // Top right corner
    path.lineTo(width / 2 + bluntOffset, bluntHeight); // Top blunt corner
    path.quadraticBezierTo(
      width / 2,
      bluntHeight * 1.06,
      width / 2 - bluntOffset,
      bluntHeight,
    ); // Curve the tip of the triangle
    path.lineTo(0, 0); // Top left corner
    path.close();

    final paint = Paint()..color = colorOfIndicator;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
