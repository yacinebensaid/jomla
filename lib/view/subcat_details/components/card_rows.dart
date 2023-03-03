import 'package:flutter/material.dart';
import '../../../constants/routes.dart';
import '../../../size_config.dart';
import '../../explore/components/section_title.dart';
import '../../product_datails/details_view.dart';
import '../../products_card/body.dart';
import '../../products_card/product.dart';
import '../../var_lib.dart' as vars;

class CardRows extends StatelessWidget {
  CardRows({
    Key? key,
    required this.maincat,
  }) : super(key: key);

  final String maincat;
  final _subCategories = vars.get_subCategoriesOption();

  Future<List<dynamic>> productGetter(String subcat) async {
    List<dynamic> products = await getProductsBySubCat(subcat);

    return products;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: _subCategories[maincat].length,
      separatorBuilder: (context, index) {
        return SizedBox(height: getProportionateScreenWidth(20));
      },
      itemBuilder: (context, index) {
        String subcat = _subCategories[maincat][index];
        return FutureBuilder<List<dynamic>>(
          future: productGetter(subcat),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<dynamic> products = snapshot.data!;
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
                      child: SectionTitle(title: subcat),
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
                                press: () => Navigator.pushNamed(
                                  context,
                                  detailsRout,
                                  arguments: ProductDetailsArguments(
                                    product: products[index],
                                  ),
                                ),
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
            } else if (snapshot.hasError) {
              return Text("");
            }
            return const Center(child: CircularProgressIndicator());
          },
        );
      },
    );
  }
}
