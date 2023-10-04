// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jomla/constants/const_routs.dart';
import '../../../size_config.dart';
import '../../var_lib.dart' as vars;

List mainCategories = vars.get_mainCategoryOptionEX();
Map<int, String> cateroriesInfo = vars.get_cateroriesInfo();

class Categories extends StatelessWidget {
  Categories({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: getProportionateScreenWidth(5)),
        SingleChildScrollView(
          child: SizedBox(
            width: SizeConfig.screenWidth,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: (mainCategories.length / 2).ceil(),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: getProportionateScreenWidth(20),
                    horizontal: getProportionateScreenWidth(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (index * 2 < mainCategories.length)
                        SpecialOfferCard(
                            image: cateroriesInfo[index * 2]!,
                            category: mainCategories[index * 2],
                            numOfBrands: 18,
                            press: () {
                              GoRouter.of(context).pushNamed(
                                RoutsConst.subcatRout,
                                pathParameters: {
                                  'sub_cat': mainCategories[index * 2]
                                },
                              );
                            }),
                      if (index * 2 + 1 < mainCategories.length)
                        SpecialOfferCard(
                            image: cateroriesInfo[index * 2 + 1]!,
                            category: mainCategories[index * 2 + 1],
                            numOfBrands: 18,
                            press: () {
                              GoRouter.of(context).pushNamed(
                                RoutsConst.subcatRout,
                                pathParameters: {
                                  'sub_cat': mainCategories[index * 2 + 1]
                                },
                              );
                            }),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({
    Key? key,
    required this.category,
    required this.image,
    required this.numOfBrands,
    required this.press,
  }) : super(key: key);

  final String category, image;
  final int numOfBrands;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: GestureDetector(
        onTap: press,
        child: SizedBox(
          width: SizeConfig.screenWidth * 0.4,
          height: getProportionateScreenWidth(100),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Image.asset(
                  image,
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF343434).withOpacity(0.5),
                        const Color(0xFF343434).withOpacity(0.15),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(15.0),
                    vertical: getProportionateScreenWidth(10),
                  ),
                  child: Text.rich(
                    TextSpan(
                      style: const TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: "$category\n",
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(18),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
