// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:jomla/view/products_card/loading_row.dart';

import '../../../size_config.dart';
import '../../explore/components/section_title.dart';
import '../../product_datails/details_view.dart';
import '../../products_card/body.dart';
import '../../products_card/product.dart';
import '../../var_lib.dart' as vars;

class CardRows extends StatefulWidget {
  final VoidCallback goToProfile;
  List following;
  bool isAdmin;
  CardRows({
    Key? key,
    required this.isAdmin,
    required this.following,
    required this.maincat,
    required this.goToProfile,
  }) : super(key: key);

  final String maincat;

  @override
  State<CardRows> createState() => _CardRowsState();
}

class _CardRowsState extends State<CardRows> {
  final _subCategories = vars.get_subCategoriesOption();

  Future<List<Product>> productGetter(String subcat) async {
    List<Product> products = await getProductsBySubCat(subcat);
    return products;
  }

  bool _isLoading = true;
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: _subCategories[widget.maincat].length,
      separatorBuilder: (context, index) {
        return SizedBox(height: getProportionateScreenWidth(20));
      },
      itemBuilder: (context, index) {
        String subcat = _subCategories[widget.maincat][index];
        return FutureBuilder<List<Product>>(
          future: productGetter(subcat),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingRow();
            } else if (snapshot.hasData) {
              List<Product> products = snapshot.data!;
              if (products.isEmpty) {
                return Container(); // Return an empty container if there are no products
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(20),
                      ),
                      child: SectionTitle(
                        title: subcat,
                        press: () {},
                      ),
                    ),
                    SizedBox(height: getProportionateScreenWidth(20)),
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ...List.generate(
                            products.length,
                            (index) {
                              return ProductCard(
                                product: products[index],
                                press: () => Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: ((context) => DetailsScreen(
                                              goToProfile: widget.goToProfile,
                                              following: widget.following,
                                              isAdmin: widget.isAdmin,
                                              product: products[index],
                                            )))),
                              );
                            },
                          ),
                          SizedBox(width: getProportionateScreenWidth(20)),
                        ],
                      ),
                    ),
                  ],
                );
              }
            } else {
              return SizedBox.shrink();
            }
          },
        );
      },
    );
  }
}
