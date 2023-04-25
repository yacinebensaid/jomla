import 'package:flutter/material.dart';

import 'loading_card.dart';

class LoadingRow extends StatelessWidget {
  const LoadingRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: const [
            ProductCardShimmer(),
            ProductCardShimmer(),
            ProductCardShimmer(),
            ProductCardShimmer(),
            ProductCardShimmer(),
          ],
        ));
  }
}
