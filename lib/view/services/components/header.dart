import 'package:flutter/material.dart';

Widget buildHeader() {
  return Container(
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.5),
          blurRadius: 10,
          offset: const Offset(0, 30), // changes position of shadow
        ),
      ],
    ),
    child: AspectRatio(
      aspectRatio: 16 / 9,
      child: Image.asset(
        "assets/images/image1.jpg",
        fit: BoxFit.fitWidth,
      ),
    ),
  );
}
