// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:jomla/utilities/reusable.dart';
import '../../products_card/product.dart';

class OnSaleProducts extends StatefulWidget {
  final Future<List<Product>> products;

  OnSaleProducts({Key? key, required this.products}) : super(key: key);

  @override
  State<OnSaleProducts> createState() => _OnSaleProductsState();
}

class _OnSaleProductsState extends State<OnSaleProducts> {
  late Future<List<Product>> _getProducts;
  @override
  void initState() {
    _getProducts = widget.products;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProductRows(getProducts: _getProducts, title: 'On Sale');
  }
}
