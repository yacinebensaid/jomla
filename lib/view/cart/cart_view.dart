// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:jomla/services/crud/pcf_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'components/body.dart';
import 'components/check_out_card.dart';

class CartScreen extends StatefulWidget {
  final List following;

  final VoidCallback goToProfile;
  final String userType;
  final bool isAdmin;
  CartScreen({
    Key? key,
    required this.following,
    required this.userType,
    required this.isAdmin,
    required this.goToProfile,
  }) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Stream<List<CartProduct>>? _cartProductsFuture;
  Future<void> _reloadCartProducts() async {
    setState(() {
      _cartProductsFuture = UserPCFService.getCart(); // Reload the future
    });
  }

  @override
  void initState() {
    super.initState();
    _reloadCartProducts();
  }

  List<String> allCheckedProducts = [];
  void passCheckedProducts(List<String> products) {
    setState(() {
      allCheckedProducts = products;
    });
  }

  Widget donthaveproduct() {
    return Center(
      child: Text(
        AppLocalizations.of(context)!.youdonthaveproducts,
        style: const TextStyle(
          fontSize: 24,
          color: Colors.grey,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<List<CartProduct>>(
          stream: _cartProductsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                  body: const Center(
                child: CircularProgressIndicator(),
              ));
            } else if (snapshot.hasData) {
              if (snapshot.data != null) {
                if (snapshot.data!.isNotEmpty) {
                  return Scaffold(
                      body: Body(
                        products: snapshot.data!,
                        reloadPage: _reloadCartProducts,
                        oncheckedProducts: passCheckedProducts,
                        goToProfile: widget.goToProfile,
                        following: widget.following,
                        isAdmin: widget.isAdmin,
                      ),
                      bottomNavigationBar: Container(
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
                          goToProfile: widget.goToProfile,
                          following: widget.following,
                          userType: widget.userType,
                          isAdmin: widget.isAdmin,
                        ),
                      ));
                } else {
                  return Scaffold(
                    body: donthaveproduct(),
                  );
                }
              } else {
                return Scaffold(
                  body: donthaveproduct(),
                );
              }
            } else {
              return Scaffold(
                body: donthaveproduct(),
              );
            }
          }),
    );
  }
}
