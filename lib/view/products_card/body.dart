import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jomla/services/crud/pcf_service.dart';
import '../../constants/constants.dart';
import '../../size_config.dart';
import 'product.dart';
import 'package:jomla/utilities/shimmers.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    Key? key,
    this.width = 140,
    this.aspectRetio = 1.02,
    required this.product,
    required this.press,
  }) : super(key: key);

  final double width, aspectRetio;
  final Product product;
  final GestureTapCallback press;

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late bool _isfav;

  @override
  void initState() {
    _isfav = widget.product.isFavourite;
    super.initState();
  }

  void pressfav() async {
    if (_isfav) {
      UserPCFService.deletefromfav(widget.product.reference);
    } else {
      await UserPCFService.addToFav(reference: widget.product.reference);
    }
    setState(() {
      _isfav = !_isfav;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(
          color: Colors.grey,
          width: 0.3,
        ),
      ),
      child: Stack(children: [
        Padding(
          padding: const EdgeInsets.all(7.0),
          child: GestureDetector(
            onTap: widget.press,
            child: SizedBox(
              width: getProportionateScreenWidth(widget.width),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AspectRatio(
                        aspectRatio: 1.02,
                        child: Container(
                            padding:
                                EdgeInsets.all(getProportionateScreenWidth(0)),
                            decoration: BoxDecoration(
                              color: kSecondaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: CachedNetworkImage(
                              key: UniqueKey(),
                              imageUrl: widget.product.main_photo,
                              height: 60,
                              width: 60,
                              maxWidthDiskCache: 250,
                              fit: BoxFit.cover,
                              placeholder: (context, url) {
                                return BuildShimmerEffect();
                              },
                              errorWidget: (context, url, error) {
                                return Image.network(
                                  widget.product.main_photo,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return BuildShimmerEffect();
                                  },
                                  errorBuilder: (_, __, ___) =>
                                      BuildShimmerEffect(),
                                );
                              },
                            )),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.product.product_name,
                        style: const TextStyle(color: Colors.black),
                        maxLines: 2,
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          padding:
                              EdgeInsets.all(getProportionateScreenWidth(8)),
                          height: getProportionateScreenWidth(28),
                          width: getProportionateScreenWidth(28),
                          decoration: BoxDecoration(
                            color: _isfav
                                ? kPrimaryColor.withOpacity(0.15)
                                : kSecondaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            "assets/icons/Heart Icon_2.svg",
                            color: _isfav
                                ? const Color(0xFFFF4848)
                                : const Color(0xFFDBDEE4),
                          ),
                        ),
                        onTap: () {
                          pressfav();
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        if (widget.product.offers ==
            'On Sale') // Check if the product has an offer
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                widget.product.offers!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: getProportionateScreenWidth(12),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        if (widget.product.offers == 'Free Shipping')
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                widget.product.offers!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: getProportionateScreenWidth(12),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        if (widget.product.offers == 'Free Storage')
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 5, 98, 173),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                widget.product.offers!,
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: getProportionateScreenWidth(12),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ]),
    );
  }
}
