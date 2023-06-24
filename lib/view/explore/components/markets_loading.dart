import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingMarkets extends StatelessWidget {
  const LoadingMarkets({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 100.h,
            width: 100.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(180),
              color: Colors.grey[300],
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            height: 20.h,
            width: 120.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingMarketsRow extends StatelessWidget {
  const LoadingMarketsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: [
        SizedBox(
          width: 18.w,
        ),
        const LoadingMarkets(),
        SizedBox(
          width: 18.w,
        ),
        const LoadingMarkets(),
        SizedBox(
          width: 18.w,
        ),
        const LoadingMarkets(),
        SizedBox(
          width: 18.w,
        ),
        const LoadingMarkets(),
        SizedBox(
          width: 18.w,
        ),
        const LoadingMarkets(),
        SizedBox(
          width: 18.w,
        ),
        const LoadingMarkets(),
        SizedBox(
          width: 18.w,
        ),
      ]),
    );
  }
}
