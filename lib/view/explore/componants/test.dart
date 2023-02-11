import 'package:flutter/material.dart';

import '../../../size_config.dart';
import 'section_title.dart';

class Categories extends StatelessWidget {
  const Categories({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Center(
          child: SectionTitle(
            title: "Categories",
          ),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        SingleChildScrollView(
          child: SizedBox(
            width: SizeConfig.screenWidth,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          right: getProportionateScreenWidth(10)),
                      child: SpecialOfferCard(
                        image:
                            "assets/images/front-view-relaxation-indoors-products-basket.jpg",
                        category: "Beauty",
                        numOfBrands: 18,
                        press: () {},
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: getProportionateScreenWidth(10)),
                      child: SpecialOfferCard(
                        image:
                            "assets/images/beautiful-set-professional-makeup-cosmetics-dark-table.jpg",
                        category: "Fashion",
                        numOfBrands: 24,
                        press: () {},
                      ),
                    ),
                    SizedBox(width: getProportionateScreenWidth(0)),
                  ],
                ),
                const Divider(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          right: getProportionateScreenWidth(10)),
                      child: SpecialOfferCard(
                        image:
                            "assets/images/front-view-relaxation-indoors-products-basket.jpg",
                        category: "Beauty",
                        numOfBrands: 18,
                        press: () {},
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: getProportionateScreenWidth(10)),
                      child: SpecialOfferCard(
                        image:
                            "assets/images/beautiful-set-professional-makeup-cosmetics-dark-table.jpg",
                        category: "Fashion",
                        numOfBrands: 24,
                        press: () {},
                      ),
                    ),
                    SizedBox(width: getProportionateScreenWidth(0)),
                  ],
                ),
                const Divider(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          right: getProportionateScreenWidth(10)),
                      child: SpecialOfferCard(
                        image:
                            "assets/images/front-view-relaxation-indoors-products-basket.jpg",
                        category: "Beauty",
                        numOfBrands: 18,
                        press: () {},
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: getProportionateScreenWidth(10)),
                      child: SpecialOfferCard(
                        image:
                            "assets/images/beautiful-set-professional-makeup-cosmetics-dark-table.jpg",
                        category: "Fashion",
                        numOfBrands: 24,
                        press: () {},
                      ),
                    ),
                    SizedBox(width: getProportionateScreenWidth(0)),
                  ],
                ),
                const Divider(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          right: getProportionateScreenWidth(10)),
                      child: SpecialOfferCard(
                        image:
                            "assets/images/front-view-relaxation-indoors-products-basket.jpg",
                        category: "Beauty",
                        numOfBrands: 18,
                        press: () {},
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: getProportionateScreenWidth(10)),
                      child: SpecialOfferCard(
                        image:
                            "assets/images/beautiful-set-professional-makeup-cosmetics-dark-table.jpg",
                        category: "Fashion",
                        numOfBrands: 24,
                        press: () {},
                      ),
                    ),
                    SizedBox(width: getProportionateScreenWidth(0)),
                  ],
                ),
                const Divider(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          right: getProportionateScreenWidth(10)),
                      child: SpecialOfferCard(
                        image:
                            "assets/images/front-view-relaxation-indoors-products-basket.jpg",
                        category: "Beauty",
                        numOfBrands: 18,
                        press: () {},
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: getProportionateScreenWidth(10)),
                      child: SpecialOfferCard(
                        image:
                            "assets/images/beautiful-set-professional-makeup-cosmetics-dark-table.jpg",
                        category: "Fashion",
                        numOfBrands: 24,
                        press: () {},
                      ),
                    ),
                    SizedBox(width: getProportionateScreenWidth(0)),
                  ],
                ),
                const Divider(
                  height: 15,
                ),
              ],
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
                        const Color(0xFF343434).withOpacity(0.4),
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
                        TextSpan(text: "$numOfBrands Brands")
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
