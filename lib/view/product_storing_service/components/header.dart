import 'package:flutter/material.dart';

Widget buildHeader() {
  return Container(
    child: AspectRatio(
      aspectRatio: 16 / 9,
      child: Image.asset(
        "assets/images/image1.jpg",
        fit: BoxFit.fitWidth,
      ),
    ),
  );
}
