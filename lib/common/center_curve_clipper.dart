import 'package:flutter/cupertino.dart';

class CenterCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final radius = size.width / 2; // Adjust this for the desired curve size
    final center = Offset(size.width / 2, size.height / 2);

    path.moveTo(0, size.height);
    path.lineTo(0, center.dy - radius);
    path.quadraticBezierTo(
        center.dx, center.dy - radius * 2, size.width, center.dy - radius);
    path.lineTo(size.width, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
