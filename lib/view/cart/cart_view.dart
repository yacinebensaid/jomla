// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:jomla/services/crud/pcf_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jomla/services/providers.dart';
import 'package:provider/provider.dart';

import 'components/body.dart';
import 'components/check_out_card.dart';

class CartScreen extends StatefulWidget {
  CartScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Map<String, CartProduct> allCheckedProducts = {};
  void passCheckedProducts(Map<String, CartProduct> products) {
    setState(() {
      allCheckedProducts = products;
    });
    context
        .read<CheckedCartProducts>()
        .updateCheckedProducts(newCheckedMap: allCheckedProducts);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Body(
            oncheckedProducts: passCheckedProducts,
          ),
          bottomNavigationBar:
              Provider.of<CheckedCartProducts>(context, listen: false)
                      .getChackeMap
                      .isNotEmpty
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 1,
                            offset: Offset(0, -1),
                          ),
                        ],
                      ),
                      child: CheckoutCard(
                        checkedProducts: allCheckedProducts,
                      ),
                    )
                  : SizedBox.shrink()),
    );
  }
}
