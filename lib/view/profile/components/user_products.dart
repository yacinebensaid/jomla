import 'package:flutter/material.dart';
import 'package:jomla/services/crud/product_service.dart';
import 'package:jomla/utilities/reusable.dart';

import 'package:jomla/view/products_card/product.dart';

class UserProducts extends StatefulWidget {
  String uid;
  UserProducts({Key? key, required this.uid}) : super(key: key);

  @override
  State<UserProducts> createState() => _UserProductsState();
}

class _UserProductsState extends State<UserProducts> {
  late Future<List<Product>> _getProducts;
  @override
  void initState() {
    _getProducts = ProductService.searchProductByUser(widget.uid);
    super.initState();
  }

  Future<void> _refreshProducts() async {
    setState(() {
      _getProducts = ProductService.searchProductByUser(widget.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProductsColumn(productsList: _getProducts, context: context);
  }
}
