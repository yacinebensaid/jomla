import 'dart:math' show min;

import 'package:flutter/material.dart';
import 'package:jomla/constants/routes.dart';
import 'package:jomla/services/crud/product_service.dart';
import 'package:jomla/view/product_datails/details_view.dart';
import 'package:jomla/view/products_card/product.dart';

class CustumSearchDeligate extends SearchDelegate {
  String? selectedMainCategory;
  String? selectedSubCategory;
  String? selectedOffer;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear)),
      IconButton(
          onPressed: () {
            // Show the filtering options
            showModalBottomSheet(
              context: context,
              builder: (_) {
                return StatefulBuilder(builder: (modalContext, modalSetState) {
                  return Container(
                    height: 300,
                    child: Column(
                      children: [
                        Text('Filtering options'),
                        // Add dropdowns for main category, sub-category, and offer
                        DropdownButtonFormField<String>(
                          value: selectedMainCategory,
                          items: ['Category A', 'Category B', 'Category C']
                              .map((value) => DropdownMenuItem(
                                  value: value, child: Text(value)))
                              .toList(),
                          onChanged: (value) {
                            modalSetState(() {
                              selectedMainCategory = value;
                            });
                          },
                          decoration:
                              InputDecoration(labelText: 'Main Category'),
                        ),
                        DropdownButtonFormField<String>(
                          value: selectedSubCategory,
                          items: [
                            'Sub-category A',
                            'Sub-category B',
                            'Sub-category C'
                          ]
                              .map((value) => DropdownMenuItem(
                                  value: value, child: Text(value)))
                              .toList(),
                          onChanged: (value) {
                            modalSetState(() {
                              selectedSubCategory = value;
                            });
                          },
                          decoration:
                              InputDecoration(labelText: 'Sub-Category'),
                        ),
                        DropdownButtonFormField<String>(
                          value: selectedOffer,
                          items: ['Offer A', 'Offer B', 'Offer C']
                              .map((value) => DropdownMenuItem(
                                  value: value, child: Text(value)))
                              .toList(),
                          onChanged: (value) {
                            modalSetState(() {
                              selectedOffer = value;
                            });
                          },
                          decoration: InputDecoration(labelText: 'Offer'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            showResults(context);
                          },
                          child: Text('Apply Filters'),
                        ),
                      ],
                    ),
                  );
                });
              },
            );
          },
          icon: Icon(Icons.filter_alt)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    Map<String, String> nameToReferenceMap = {};
    return FutureBuilder(
      future: ProductService.getAllProducts(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          List<String> productsName = [];
          for (Map product in snapshot.data!) {
            String productName = product['product_name'];
            String productReference = product['reference'];
            nameToReferenceMap[productName] = productReference;
            productsName.add(productName);
          }

          // Filter the list of product names based on the query text
          List<String> filteredProducts = productsName
              .where((productName) =>
                  productName.toLowerCase().contains(query.toLowerCase()))
              .toList();
          int maxitems = 10;
          return ListView.builder(
              itemCount: min(filteredProducts.length, maxitems),
              itemBuilder: (context, index) {
                String result = filteredProducts[index];
                return ListTile(
                  onTap: () async {
                    String reference = nameToReferenceMap[result]!;
                    Product product = await getProductsByReference(reference);
                    Navigator.pushNamed(context, detailsRout,
                        arguments: ProductDetailsArguments(product: product));
                  },
                  title: Text(result),
                );
              });
        } else {
          return Container();
        }
      }),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    Map<String, String> nameToReferenceMap = {};
    return FutureBuilder(
      future: ProductService.getAllProducts(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          List<String> productsName = [];
          for (Map product in snapshot.data!) {
            String productName = product['product_name'];
            String productReference = product['reference'];
            String productMainCat = product['main_category'];
            String productSubCat = product['sub_category'];
            String productOffer = product['offers'];
            nameToReferenceMap[productName] = productReference;
            productsName.add(productName);
          }
          // Filter the list of product names based on the query text
          List<String> filteredProducts = productsName
              .where((productName) =>
                  productName.toLowerCase().contains(query.toLowerCase()))
              .toList();
          int maxitems = 10;
          return ListView.builder(
              itemCount: min(filteredProducts.length, maxitems),
              itemBuilder: (context, index) {
                String result = filteredProducts[index];
                return ListTile(
                  onTap: () async {
                    String reference = nameToReferenceMap[result]!;
                    Product product = await getProductsByReference(reference);
                    Navigator.pushNamed(context, detailsRout,
                        arguments: ProductDetailsArguments(product: product));
                  },
                  title: Text(result),
                );
              });
        } else {
          return Container();
        }
      }),
    );
  }
}
