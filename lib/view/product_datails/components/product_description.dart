import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jomla/services/auth/auth_service.dart';
import 'package:jomla/services/crud/pcf_service.dart';
import 'package:jomla/services/crud/product_service.dart';
import 'package:jomla/services/crud/userdata_service.dart';
import 'package:jomla/services/providers.dart';
import 'package:jomla/utilities/reusable.dart';
import 'package:jomla/utilities/shimmers.dart';
import 'package:jomla/view/product_edit/product_edit.dart';
import 'package:provider/provider.dart';
import '../../../constants/constants.dart';
import '../../../size_config.dart';
import '../../products_card/product.dart';
import 'comments.dart';
import 'owner.dart';

class ProductDescription extends StatefulWidget {
  const ProductDescription({
    Key? key,
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
                const Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                  ),
                  child: Text(
                    'Variations',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 151, 151, 151),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
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
                              child: CachedNetworkImage(
                                key: UniqueKey(),
                                imageUrl: image,
                                maxWidthDiskCache: 250,
                                fit: BoxFit.cover,
                                placeholder: (context, url) {
                                  return const BuildShimmerEffect();
                                },
                                errorWidget: (context, url, error) {
                                  return Image.network(
                                    image,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return const BuildShimmerEffect();
                                    },
                                    errorBuilder: (_, __, ___) =>
                                        const BuildShimmerEffect(),
                                  );
                                },
                              ));
                        })),
                  ),
                ),
              ],
            );
          } else {
            return const SizedBox.shrink();
          }
        } else {
          return const SizedBox.shrink();
        }
      } else {
        return const SizedBox.shrink();
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget dropDownMenu(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) async {
        if (value == 'delete') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Delete Item"),
                content:
                    const Text("Are you sure you want to delete this item?"),
                actions: [
                  TextButton(
                    child: const Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text("Delete"),
                    onPressed: () {
                      DataService _dataServInstance = DataService();
                      _dataServInstance
                          .deleteOwnedProduct(widget.product.reference);
                      ProductService.deleteProduct(widget.product.reference);
                      // Perform the delete operation here
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else if (value == 'edit') {
          Navigator.of(context).push(MaterialPageRoute(
              builder: ((context) => EditProduct(
                    ref: widget.product.reference,
                  ))));
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'signal',
          child: Text('Signal Product'),
        ),
        ...Provider.of<UserDataInitializer>(context).getUserData != null
            ? Provider.of<UserDataInitializer>(context).getUserData!.isAdmin
                ? [
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ]
                : []
            : []
      ].toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.product.product_name,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              Column(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      height: 30,
                      width: 30,
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
                      if (kIsWeb) {
                        if (AuthService.firebase().currentUser != null) {
                          pressfav();
                        } else {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: const LoginDialog(
                                      guest: true,
                                    ));
                              });
                        }
                      } else {
                        final internetConnectionStatus =
                            Provider.of<InternetConnectionStatus>(context,
                                listen: false);
                        if (internetConnectionStatus ==
                            InternetConnectionStatus.connected) {
                          if (AuthService.firebase().currentUser != null) {
                            pressfav();
                          } else {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: const LoginDialog(
                                        guest: true,
                                      ));
                                });
                          }
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('you are not connected'),
                            behavior: SnackBarBehavior.floating,
                          ));
                        }
                      }
                    },
                  ),
                  Text(
                    '$likes',
                    style: const TextStyle(fontSize: 15),
                  )
                ],
              )
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        _buildPricingFields(pricingDetails: widget.product.price),
        const SizedBox(
          height: 10,
        ),
        _buildVariations(),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Row(
            children: [
              Text(
                'Description',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 151, 151, 151),
                ),
              ),
              Spacer(),
              dropDownMenu(context),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
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
        const SizedBox(
          height: 20,
        ),
        Center(
          child: Owner(
            uid: widget.product.owner,
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        Comments(
          reference: widget.product.reference,
        ),
        const SizedBox(
          height: 20,
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
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Existing code for the first container
          Container(
            height: 60,
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color.fromARGB(255, 218, 218, 218),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15), // Shadow color
                  spreadRadius: 1.5, // Spread radius
                  blurRadius: 5, // Blur radius
                  offset:
                      const Offset(0, 0.5), // Offset in the x and y direction
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'One Item',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  '$oneItemPrice da',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
          for (int i = 0; i < pricingDetails.length - 1; i++)
            if (i < 3) // Limit to a maximum of 3 items
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Container(
                  height: 60,
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    border: Border.all(
                      color: const Color.fromARGB(255, 218, 218, 218),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15), // Shadow color
                        spreadRadius: 1.5, // Spread radius
                        blurRadius: 5, // Blur radius
                        offset: const Offset(
                            0, 0.5), // Offset in the x and y direction
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'from ${pricingDetails[i + 1]['from']} Items',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '${pricingDetails[i + 1]['price']} da',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
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
