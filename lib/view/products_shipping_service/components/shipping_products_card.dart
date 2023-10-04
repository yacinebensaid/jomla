import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jomla/utilities/shimmers.dart';
import 'package:jomla/view/purchased/components/purchased.dart';
import '../../../../constants/constants.dart';
import '../../../../size_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PurchasedCard extends StatelessWidget {
  const PurchasedCard({
    super.key,
    required this.purchasedProd,
  });
  final PurchasedProduct purchasedProd;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Row(
        children: [
          SizedBox(
            width: 72,
            child: AspectRatio(
              aspectRatio: 0.88,
              child: Container(
                  padding: EdgeInsets.all(getProportionateScreenWidth(10)),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F6F9),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: CachedNetworkImage(
                    key: UniqueKey(),
                    imageUrl: purchasedProd.product.main_photo,
                    maxWidthDiskCache: 250,
                    fit: BoxFit.cover,
                    placeholder: (context, url) {
                      return const BuildShimmerEffect();
                    },
                    errorWidget: (context, url, error) {
                      return Image.network(
                        purchasedProd.product.main_photo,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return const BuildShimmerEffect();
                        },
                        errorBuilder: (_, __, ___) =>
                            const BuildShimmerEffect(),
                      );
                    },
                  )),
            ),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                purchasedProd.product.product_name,
                style: const TextStyle(color: Colors.black, fontSize: 16),
                maxLines: 2,
              ),
              const SizedBox(height: 10),
              Text.rich(
                TextSpan(
                  text: AppLocalizations.of(context)!.totalprice,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, color: kPrimaryColor),
                  children: [
                    TextSpan(
                        text: " \$${purchasedProd.product.total_price}",
                        style: Theme.of(context).textTheme.bodyText1),
                  ],
                ),
              ),
              Text.rich(
                TextSpan(
                  text: AppLocalizations.of(context)!.quantity,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, color: kPrimaryColor),
                  children: [
                    TextSpan(
                        text: " ${purchasedProd.product.quantity}",
                        style: Theme.of(context).textTheme.bodyText1),
                  ],
                ),
              ),
            ],
          )
        ],
      );
    });
  }
}
