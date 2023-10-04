// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jomla/constants/const_routs.dart';

class Services extends StatelessWidget {
  const Services({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Start working now!',
                style: TextStyle(fontSize: 18, color: Colors.black),
              )),
          const SizedBox(height: 10),
          !kIsWeb
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SpecialOfferCard(
                        image: "assets/images/services/stock.jpg",
                        category: "Online\nMarket",
                        press: () {
                          GoRouter.of(context)
                              .pushNamed(RoutsConst.onlineMarket);
                        },
                      ),
                      SpecialOfferCard(
                        image: "assets/images/services/shipping_serv.jpeg",
                        category: "Dropshipping\nService",
                        press: () {
                          GoRouter.of(context)
                              .pushNamed(RoutsConst.dropshipRout);
                        },
                      ),
                      SpecialOfferCard(
                        image: "assets/images/services/affiliate-marketing.jpg",
                        category: "Affiliate\nMarketing",
                        press: () {
                          GoRouter.of(context).pushNamed(RoutsConst.affiRout);
                        },
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      SpecialOfferCard(
                        image: "assets/images/services/stock.jpg",
                        category: "Online\nMarket",
                        press: () {
                          GoRouter.of(context)
                              .pushNamed(RoutsConst.onlineMarket);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SpecialOfferCard(
                        image: "assets/images/services/shipping_serv.jpeg",
                        category: "Dropshipping\nService",
                        press: () {
                          GoRouter.of(context)
                              .pushNamed(RoutsConst.dropshipRout);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SpecialOfferCard(
                        image: "assets/images/services/affiliate-marketing.jpg",
                        category: "Affiliate\nMarketing",
                        press: () {
                          GoRouter.of(context).pushNamed(RoutsConst.affiRout);
                        },
                      ),
                    ],
                  ),
                ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({
    Key? key,
    required this.category,
    required this.image,
    required this.press,
  }) : super(key: key);

  final String category, image;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: kIsWeb ? 10 : 20, right: kIsWeb ? 10 : 0),
      child: GestureDetector(
        onTap: press,
        child: SizedBox(
          width: 242,
          height: 120,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: AssetImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
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
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  child: Text.rich(
                    TextSpan(
                      style: const TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: "$category\n",
                          style: TextStyle(
                            fontSize: 18,
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
