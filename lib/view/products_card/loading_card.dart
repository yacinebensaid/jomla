import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../constants/constants.dart';
import '../../size_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({
    Key? key,
    this.width = 140,
    this.aspectRetio = 1.02,
  }) : super(key: key);

  final double width, aspectRetio;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey,
            width: 0.3,
          ),
        ),
        child: Stack(children: [
          Padding(
            padding: EdgeInsets.all(7.0.w),
            child: SizedBox(
              width: getProportionateScreenWidth(width),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AspectRatio(
                        aspectRatio: aspectRetio,
                        child: Container(
                          decoration: BoxDecoration(
                            color: kSecondaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          // Here you can add a placeholder image or leave it blank
                          // child: Image.network('your_placeholder_image_url'),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        height: 16.h,
                        width: 80.w,
                        color: Colors.white,
                      ),
                      SizedBox(height: 5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 18.h,
                            width: 40.w,
                            color: Colors.white,
                          ),
                          Container(
                            height: 28.h,
                            width: 28.w,
                            decoration: BoxDecoration(
                              color: kSecondaryColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              height: getProportionateScreenWidth(16),
              width: getProportionateScreenWidth(60),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
