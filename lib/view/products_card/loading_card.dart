import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../constants/constants.dart';
import '../../size_config.dart';

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
            padding: const EdgeInsets.all(7.0),
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
                          padding:
                              EdgeInsets.all(getProportionateScreenWidth(0)),
                          decoration: BoxDecoration(
                            color: kSecondaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          // Here you can add a placeholder image or leave it blank
                          // child: Image.network('your_placeholder_image_url'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: getProportionateScreenWidth(16),
                        width: getProportionateScreenWidth(80),
                        color: Colors.white,
                      ),
                      const SizedBox(height: 5),
                      Container(
                        height: getProportionateScreenWidth(16),
                        width: getProportionateScreenWidth(60),
                        color: Colors.white,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: getProportionateScreenWidth(18),
                            width: getProportionateScreenWidth(40),
                            color: Colors.white,
                          ),
                          Container(
                            height: getProportionateScreenWidth(28),
                            width: getProportionateScreenWidth(28),
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
