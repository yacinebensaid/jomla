// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:jomla/utilities/reusable.dart';
import '../../products_card/product.dart';

class NewProducts extends StatefulWidget {
  final Future<List<Product>> products;

  NewProducts({
    Key? key,
    required this.products,
  }) : super(key: key);

  @override
  State<NewProducts> createState() => _NewProductsState();
}

class _NewProductsState extends State<NewProducts> {
  late Future<List<Product>> _getProducts;
  @override
  void initState() {
    _getProducts = widget.products;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProductRows(getProducts: _getProducts, title: 'New');
  }
}
