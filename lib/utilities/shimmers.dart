import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class BuildShimmerEffect extends StatelessWidget {
  const BuildShimmerEffect({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        color: Colors.white,
      ),
    );
  }
}

Widget ShimmerColorOnlyCartWidget() {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      border: Border.all(
        color: Colors.grey,
        width: 0.3,
      ),
    ),
    padding: EdgeInsets.symmetric(horizontal: 10.w),
    child: Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          SizedBox(
            height: 8.h,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                ),
                SizedBox(width: 10),
                Container(
                  width: 200,
                  height: 20,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              border: Border.all(
                color: Colors.grey,
                width: 0.3,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
            child: Row(
              children: [
                Container(
                  width: 88,
                  height: 88,
                  color: Colors.white,
                ),
                SizedBox(width: 20),
                Container(
                  width: 100,
                  height: 20,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            width: 200,
            height: 20,
            color: Colors.white,
          ),
          SizedBox(
            height: 10.h,
          ),
        ],
      ),
    ),
  );
}
