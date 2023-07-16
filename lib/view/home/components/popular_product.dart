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
  late Future<List<Product>> _getProducts;
  @override
  void initState() {
    _getProducts = widget.products;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProductRows(getProducts: widget.products, title: 'Popular');
  }
}
