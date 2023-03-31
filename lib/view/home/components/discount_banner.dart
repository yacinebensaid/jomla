import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jomla/constants/routes.dart';
import 'package:jomla/size_config.dart';

final List images = [
  "assets/images/image1.jpg",
  "assets/images/image2.jpg",
  "assets/images/image3.jpg",
];

class HomeBanner extends StatelessWidget {
  const HomeBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth,
      child: CarouselSlider.builder(
        options: CarouselOptions(autoPlay: true, viewportFraction: 1),
        itemCount: images.length,
        itemBuilder: (context, index, realIndex) {
          final image = images[index];
          return buildImage(context, image, index);
        },
      ),
    );
  }
}

Map<int, String> indexPages = {
  0: saleRout,
  1: usingJomlaRout,
  2: tipsRout,
};
Map<int, String> buttonText = {
  0: 'checkout more 0',
  1: 'checkout more 1',
  2: 'checkout more 2',
};

Widget buildImage(BuildContext context, String image, int index) => Container(
    child: kIsWeb
        ? Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.asset(
                  image,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color(0x00000000),
                        Color(0xFF00235B),
                      ],
                      stops: [
                        0.87,
                        0.999999
                      ]),
                ),
              ),
              Positioned(
                bottom: getProportionateScreenHeight(200),
                left: getProportionateScreenWidth(100),
                child: FractionallySizedBox(
                  widthFactor: 0.19,
                  heightFactor: 0.07,
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        indexPages[index]!,
                        (route) => false,
                      );
                    },
                    child: Text(buttonText[index]!),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        : GestureDetector(
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(
                    image,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Color(0x00000000),
                          Color(0xFF00235B),
                        ],
                        stops: [
                          0.87,
                          0.999999
                        ]),
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  indexPages[index]!, (route) => false);
            }));
