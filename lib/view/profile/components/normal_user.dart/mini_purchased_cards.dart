import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jomla/view/purchased/components/purchased.dart';

class MiniPurchasedCard extends StatelessWidget {
  const MiniPurchasedCard({super.key, required this.purchasedProd});
  final PurchasedProduct purchasedProd;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        border: Border.all(width: 0.5.w, color: Colors.grey),
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
                child: Image.network(purchasedProd.product.main_photo)),
          ),
          SizedBox(width: 10.w),
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Text(
              purchasedProd.product.product_name,
              style: TextStyle(color: Colors.black, fontSize: 16.w),
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
