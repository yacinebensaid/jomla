import 'package:flutter/material.dart';
import 'package:jomla/services/auth/auth_service.dart';
import 'package:jomla/services/crud/userdata_service.dart';

import '../products_card/product.dart';
import 'components/body.dart';
import 'components/custom_app_bar.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductDetailsArguments agrs =
        ModalRoute.of(context)?.settings.arguments as ProductDetailsArguments;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F9),
      appBar: CustomAppBar(
          ref: agrs.product.reference,
          onBackButtonPressed: () => Navigator.pop(context),
          userUID: userUID!),
      body: Body(product: agrs.product),
    );
  }
}

class ProductDetailsArguments {
  final Product product;

  ProductDetailsArguments({required this.product});
}
