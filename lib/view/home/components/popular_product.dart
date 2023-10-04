// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:jomla/utilities/reusable.dart';

import '../../products_card/product.dart';

class PopularProducts extends StatefulWidget {
  final Future<List<Product>> products;
  const PopularProducts({
    Key? key,
    required this.products,
  }) : super(key: key);

  @override
  _PopularProductsState createState() => _PopularProductsState();
}

class _PopularProductsState extends State<PopularProducts> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: ProductRows(getProducts: widget.products, title: 'Hot sell'));
  }
}
