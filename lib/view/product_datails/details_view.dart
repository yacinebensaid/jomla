// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:jomla/view/products_card/product.dart';

import 'components/body.dart';
import 'components/custom_app_bar.dart';
import 'components/default_btn.dart';
import 'components/order.dart';

class DetailsScreen extends StatefulWidget {
  List following;
  Product product;
  final VoidCallback goToProfile;

  bool isAdmin;
  DetailsScreen({
    Key? key,
    required this.following,
    required this.product,
    required this.goToProfile,
    required this.isAdmin,
  }) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          isAdmin: widget.isAdmin,
          ref: widget.product.reference,
          onBackButtonPressed: () => Navigator.pop(context),
        ),
        body: Container(
          color: Color(0xFFF5F6F9),
          child: Body(
            goToProfile: widget.goToProfile,
            following: widget.following,
            product: widget.product,
            isAdmin: widget.isAdmin,
          ),
        ),
        bottomNavigationBar: Container(
          height: 75,
          child: Column(
            children: [
              Divider(
                thickness: 0.5,
                color: Colors.black,
                height: 0,
              ),
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
                width: 250.w,
                child: DefaultButton(
                  text: 'Make an order',
                  press: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return OrderProduct(
                          product: widget.product,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
