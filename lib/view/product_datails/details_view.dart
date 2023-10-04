// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:jomla/utilities/page_not_found.dart';
import 'package:jomla/utilities/reusable.dart';

import 'package:jomla/view/products_card/product.dart';

import 'components/body.dart';
import 'components/default_btn.dart';
import 'components/order.dart';

class DetailsScreen extends StatefulWidget {
  final Product? product;
  final String? ref;
  final String? affiId;

  const DetailsScreen({
    Key? key,
    required this.product,
    this.ref,
    this.affiId,
  }) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late Product product;
  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      product = widget.product!;
    }
    if (widget.affiId != null) {
      print(widget.affiId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.ref != null
        ? FutureBuilder(
            future: getProductsByReference(widget.ref!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                if (snapshot.data != null) {
                  Product _product = snapshot.data;
                  return Scaffold(
                    appBar: CustomAppBar(
                      ref: widget.ref!,
                      onBackButtonPressed: () => Navigator.pop(context),
                    ),
                    body: Container(
                      color: const Color(0xFFF5F6F9),
                      child: Body(
                        product: _product,
                      ),
                    ),
                    bottomNavigationBar: Container(
                      height: 75,
                      child: Column(
                        children: [
                          const Divider(
                            thickness: 0.5,
                            color: Colors.black,
                            height: 0,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: 250,
                            child: DefaultButton(
                              text: 'Make an order',
                              press: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return OrderProduct(
                                      product: _product,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const PageNotFound();
                }
              } else {
                return const PageNotFound();
              }
            },
          )
        : widget.product != null
            ? Scaffold(
                appBar: CustomAppBar(
                  ref: widget.product!.reference,
                  onBackButtonPressed: () => Navigator.pop(context),
                ),
                body: Container(
                  color: const Color(0xFFF5F6F9),
                  child: Body(
                    product: product,
                  ),
                ),
                bottomNavigationBar: Container(
                  height: 75,
                  child: Column(
                    children: [
                      const Divider(
                        thickness: 0.5,
                        color: Colors.black,
                        height: 0,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 250,
                        child: DefaultButton(
                          text: 'Make an order',
                          press: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return OrderProduct(
                                  product: product,
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const PageNotFound();
  }
}
