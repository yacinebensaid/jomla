import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:jomla/constants/const_routs.dart';

final List imagesPhone = [
  "assets/images/image1.jpg",
  "assets/images/image2.jpg",
  "assets/images/image3.jpg",
];
final List imagesWeb = [
  "assets/images/image1web.jpg",
  "assets/images/image2web.jpg",
  "assets/images/image3web.jpg",
];
final CarouselController _carouselController = CarouselController();
Widget buildCarousel(BuildContext context) {
  return Container(
    child: Stack(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: CarouselSlider.builder(
            carouselController: _carouselController,
            options: CarouselOptions(
                autoPlay: true, viewportFraction: 1, aspectRatio: 16 / 9),
            itemCount: imagesPhone.length,
            itemBuilder: (context, index, realIndex) {
              final image = imagesPhone[index];
              return buildImage(context, image, index);
            },
          ),
        ),
        if (kIsWeb)
          Positioned(
            top: MediaQuery.of(context).size.height / 2,
            left: 10,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: Offset(0, 1),
                    blurRadius: 10,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () {
                  _carouselController.previousPage();
                },
                icon: Icon(
                  Icons.arrow_back_ios_new_sharp,
                  size: 20.0,
                  color: Colors.grey[300],
                ),
              ),
            ),
          ),
        if (kIsWeb)
          Positioned(
            top: MediaQuery.of(context).size.height / 2,
            right: 10,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: Offset(0, 1),
                    blurRadius: 10,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () {
                  _carouselController.nextPage();
                },
                icon: Icon(
                  Icons.arrow_forward_ios_sharp,
                  size: 20.0,
                  color: Colors.grey[300],
                ),
              ),
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
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Image.asset(
            image,
            fit: BoxFit.fitWidth,
          ),
        ),
        onTap: () {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(indexPages[index]!, (route) => false);
        },
      ),
    );
