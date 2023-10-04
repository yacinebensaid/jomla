import 'package:flutter/material.dart';
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
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                const SizedBox(
                  width: 40,
                ),
                const SizedBox(width: 10),
                Container(
                  width: 200,
                  height: 20,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
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
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Row(
              children: [
                Container(
                  width: 88,
                  height: 88,
                  color: Colors.white,
                ),
                const SizedBox(width: 20),
                Container(
                  width: 100,
                  height: 20,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: 200,
            height: 20,
            color: Colors.white,
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    ),
  );
}
