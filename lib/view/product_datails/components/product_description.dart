import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jomla/services/crud/pcf_service.dart';
import '../../../constants/constants.dart';
import '../../../size_config.dart';
import '../../products_card/product.dart';
import 'comments.dart';
import 'owner.dart';

class ProductDescription extends StatefulWidget {
  final VoidCallback goToProfile;
  List following;
  bool isAdmin;
  ProductDescription({
    Key? key,
    required this.goToProfile,
    required this.following,
    required this.isAdmin,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  late int _quantity;
  late bool _isfav;
  late int likes;
  bool _added = false;

  @override
  void initState() {
    super.initState();
    likes = widget.product.likers.length;
    _isfav = widget.product.isFavourite;
  }

  String getQuantity() {
    return _quantity.toString();
  }

  void pressfav() async {
    if (_isfav) {
      UserPCFService.deletefromfav(widget.product.reference);
      setState(() {
        likes = likes - 1;
      });
    } else {
      await UserPCFService.addToFav(reference: widget.product.reference);
      setState(() {
        likes = likes + 1;
      });
    }
    setState(() {
      _isfav = !_isfav;
    });
  }

  Widget _buildVariations() {
    if (widget.product.available_quantity == null) {
      if (widget.product.variations != null) {
        if (widget.product.variations!.isNotEmpty) {
          if (widget.product.variations![0]['color_details'] != null) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                  ),
                  child: Text(
                    'Variations',
                    style: TextStyle(
                      fontSize: 20.w,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(255, 151, 151, 151),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: SizedBox(
                    width: SizeConfig.screenWidth,
                    height: 60,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.product.variations!.length,
                        itemBuilder: ((context, index) {
                          String image = widget.product.variations![index]
                              ['color_details']['image'];
                          int color = int.parse(widget.product
                              .variations![index]['color_details']['color']);
                          return Container(
                            margin: const EdgeInsets.only(right: 15),
                            padding: const EdgeInsets.all(8),
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Color(color).withOpacity(1),
                              ),
                            ),
                            child: Image.network(
                              image,
                            ),
                          );
                        })),
                  ),
                ),
              ],
            );
          } else {
            return SizedBox.shrink();
          }
        } else {
          return SizedBox.shrink();
        }
      } else {
        return SizedBox.shrink();
      }
    } else {
      return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 10.h,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.product.product_name,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              Column(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      height: 30.h,
                      width: 30.w,
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
                  ),
                  Text(
                    '$likes',
                    style: TextStyle(fontSize: 15.w),
                  )
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        _buildPricingFields(pricingDetails: widget.product.price),
        SizedBox(
          height: 10.h,
        ),
        _buildVariations(),
        SizedBox(
          height: 20.h,
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
          ),
          child: Text(
            'Description',
            style: TextStyle(
              fontSize: 20.w,
              fontWeight: FontWeight.w500,
              color: const Color.fromARGB(255, 151, 151, 151),
            ),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 30,
            right: 20,
          ),
          child: Text(
            widget.product.description,
            style: TextStyle(
                fontSize: getProportionateScreenWidth(18),
                color: Colors.black,
                height: 1.4),
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Center(
          child: Owner(
            goToProfile: widget.goToProfile,
            following: widget.following,
            uid: widget.product.owner,
            isAdmin: widget.isAdmin,
          ),
        ),
        SizedBox(
          height: 40.h,
        ),
        Comments(
          reference: widget.product.reference,
          isAdmin: widget.isAdmin,
        ),
        SizedBox(
          height: 20.h,
        )
      ]),
    );
  }
}

Widget _buildPricingFields({
  required List pricingDetails,
}) {
  String oneItemPrice = pricingDetails[0]['price'];

  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 10.w),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Existing code for the first container
          Container(
            height: 60.w,
            padding: EdgeInsets.all(7.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Color.fromARGB(255, 218, 218, 218),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15), // Shadow color
                  spreadRadius: 1.5, // Spread radius
                  blurRadius: 5, // Blur radius
                  offset: Offset(0, 0.5), // Offset in the x and y direction
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'One Item',
                  style: TextStyle(fontSize: 16.w, fontWeight: FontWeight.w500),
                ),
                Text(
                  '$oneItemPrice da',
                  style: TextStyle(fontSize: 16.w, fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
          for (int i = 0; i < pricingDetails.length - 1; i++)
            if (i < 3) // Limit to a maximum of 3 items
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Container(
                  height: 60.w,
                  padding: EdgeInsets.all(7.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    border: Border.all(
                      color: Color.fromARGB(255, 218, 218, 218),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15), // Shadow color
                        spreadRadius: 1.5, // Spread radius
                        blurRadius: 5, // Blur radius
                        offset:
                            Offset(0, 0.5), // Offset in the x and y direction
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'from ${pricingDetails[i + 1]['from']} Items',
                        style: TextStyle(
                            fontSize: 16.w, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '${pricingDetails[i + 1]['price']} da',
                        style: TextStyle(
                            fontSize: 16.w, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              ),
        ],
      ),
    ),
  );
}
