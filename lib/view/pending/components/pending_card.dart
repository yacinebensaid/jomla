import 'package:flutter/material.dart';
import '../../../constants/constants.dart';
import '../../../size_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'pending.dart';

class PendingCard extends StatelessWidget {
  const PendingCard({super.key, required this.pendingProd});
  final PendingProduct pendingProd;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 88,
          child: AspectRatio(
            aspectRatio: 0.88,
            child: Container(
                padding: EdgeInsets.all(getProportionateScreenWidth(10)),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6F9),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Image.network(pendingProd.product.main_photo)),
          ),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pendingProd.product.product_name,
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
                      text: " \$${pendingProd.product.total_price}",
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
                      text: " ${pendingProd.product.quantity}",
                      style: Theme.of(context).textTheme.bodyText1),
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}
