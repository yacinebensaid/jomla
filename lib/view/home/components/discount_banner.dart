import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:jomla/constants/routes.dart';

import '../../../size_config.dart';

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
    return Container(
        // height: 90,
        width: double.infinity,
        margin: EdgeInsets.all(getProportionateScreenWidth(0)),
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20),
          vertical: getProportionateScreenWidth(15),
        ),
        child: CarouselSlider.builder(
          options: CarouselOptions(height: 100, autoPlay: true),
          itemCount: images.length,
          itemBuilder: (context, index, realIndex) {
            final image = images[index];
            return buildImage(context, image, index);
          },
        ));
  }
}

Map<int, String> indexPages = {
  0: saleRout,
  1: usingJomlaRout,
  2: tipsRout,
};

Widget buildImage(BuildContext context, String image, int index) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 10),
    color: Colors.grey,
    child: InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(indexPages[index]!, (route) => false);
      },
      child: Image.asset(
        image,
        fit: BoxFit.cover,
      ),
    ));
