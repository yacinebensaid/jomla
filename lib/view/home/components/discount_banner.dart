import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:jomla/constants/const_routs.dart';
import 'package:jomla/view/search/search.dart';
import '../../../constants/routes.dart';

final List images = [
  "assets/images/image1.jpg",
  "assets/images/image2.jpg",
  "assets/images/image3.jpg",
];
Widget buildCarousel(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.5),
          blurRadius: 10,
          offset: const Offset(0, 30), // changes position of shadow
        ),
      ],
    ),
    child: Stack(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: CarouselSlider.builder(
            options: CarouselOptions(autoPlay: true, viewportFraction: 1),
            itemCount: images.length,
            itemBuilder: (context, index, realIndex) {
              final image = images[index];
              return buildImage(context, image, index);
            },
          ),
        ),
      ],
    ),
  );
}

Map<int, String> indexPages = {
  0: RoutsConst.saleRout,
  1: RoutsConst.usingJomlaRout,
  2: RoutsConst.tipsRout,
};
Map<int, String> buttonText = {
  0: 'checkout more 0',
  1: 'checkout more 1',
  2: 'checkout more 2',
};
Widget buildImage(BuildContext context, String image, int index) => Container(
    child: GestureDetector(
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(
                image,
                fit: BoxFit.fitWidth,
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(indexPages[index]!, (route) => false);
        }));
