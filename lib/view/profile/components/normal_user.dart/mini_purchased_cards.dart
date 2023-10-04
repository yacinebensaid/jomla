import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jomla/utilities/shimmers.dart';
import 'package:jomla/view/products_card/product.dart';
import 'package:shimmer/shimmer.dart';

class MiniPurchasedCard extends StatelessWidget {
  final Product product;
  const MiniPurchasedCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        border: Border.all(width: 0.5, color: Colors.grey),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 85,
            child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6F9),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: CachedNetworkImage(
                  key: UniqueKey(),
                  imageUrl: product.main_photo,
                  maxWidthDiskCache: 250,
                  fit: BoxFit.cover,
                  placeholder: (context, url) {
                    return const BuildShimmerEffect();
                  },
                  errorWidget: (context, url, error) {
                    return Image.network(
                      product.main_photo,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return const BuildShimmerEffect();
                      },
                      errorBuilder: (_, __, ___) => const BuildShimmerEffect(),
                    );
                  },
                )),
          ),
          const SizedBox(width: 10),
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Text(
              product.product_name,
              style: const TextStyle(color: Colors.black, fontSize: 16),
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerLoadingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          border: Border.all(width: 0.5, color: Colors.grey),
        ),
        child: SizedBox(
          height: 85,
          child: Row(
            children: [
              SizedBox(
                width: 85,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300]!,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Container(
                  width: 100, // Adjust the width to match your design
                  height: 16, // Adjust the height to match your design
                  color: Colors.grey[300]!,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
