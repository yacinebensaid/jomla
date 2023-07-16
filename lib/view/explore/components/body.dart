import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'categories.dart';
import 'markets.dart';
import 'search_explore.dart';

class Body extends StatelessWidget {
  Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          color: Color(0xFFF5F6F9),
          child: Column(
            children: [
              SizedBox(height: 5.h),
              SearchForExplore(),
              MarketsRow(),
              SizedBox(height: 5.h),
              Categories(),
            ],
          ),
        ),
      ),
    );
  }
}
