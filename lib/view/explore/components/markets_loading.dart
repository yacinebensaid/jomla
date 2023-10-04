import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

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
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(180),
              color: Colors.grey[300],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 20,
            width: 80,
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
    return const SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: [
        SizedBox(
          width: 18,
        ),
        LoadingMarkets(),
        SizedBox(
          width: 18,
        ),
        LoadingMarkets(),
        SizedBox(
          width: 18,
        ),
        LoadingMarkets(),
        SizedBox(
          width: 18,
        ),
        LoadingMarkets(),
        SizedBox(
          width: 18,
        ),
        LoadingMarkets(),
        SizedBox(
          width: 18,
        ),
        LoadingMarkets(),
        SizedBox(
          width: 18,
        ),
      ]),
    );
  }
}
