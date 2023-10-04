import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jomla/services/crud/pcf_service.dart';
import 'package:jomla/services/crud/product_service.dart';
import 'package:jomla/utilities/shimmers.dart';
import 'package:jomla/view/product_datails/details_view.dart';
import 'package:jomla/view/products_card/product.dart';
import '../../../constants/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PendingCard extends StatefulWidget {
  PendingCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  final CartProduct product;

  @override
  State<PendingCard> createState() => _PendingCardState();
}

class _PendingCardState extends State<PendingCard> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : FutureBuilder(
              future: ProductService.getProductDataByReference(
                  widget.product.reference),
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ShimmerColorOnlyCartWidget();
                } else if (snapshot.hasData && snapshot.data != null) {
                  Product productSnapshot = snapshot.data!;
                  if (productSnapshot.variations != null) {
                    if (productSnapshot.variations!.isNotEmpty) {
                      if (productSnapshot.variations![0]['color_details'] !=
                              null &&
                          productSnapshot.variations![0]['size_details'] ==
                              null) {
                        return ColorOnlyCartWidget(
                            productSnapshot: productSnapshot);
                      } else if (productSnapshot.variations![0]
                                  ['color_details'] ==
                              null &&
                          productSnapshot.variations![0]['size_details'] !=
                              null) {
                        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                        return SizeOnlyCartWidget(
                            productSnapshot: productSnapshot);
                      } else if (productSnapshot.variations![0]
                                  ['color_details'] !=
                              null &&
                          productSnapshot.variations![0]['size_details'] !=
                              null) {
                        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                        return ColorAndSizeCartWidget(
                            productSnapshot: productSnapshot);
                      } else {
                        return const SizedBox.shrink();
                      }
                    } else {
                      return const SizedBox.shrink();
                    }
                  } else {
                    /////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    int quantity = widget.product.total_quantity.toInt();
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey,
                          width: 0.3,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              productSnapshot.product_name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Image_widget(image: productSnapshot.main_photo),
                              const SizedBox(width: 20),
                              Text(
                                AppLocalizations.of(context)!.quantity,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: kPrimaryColor,
                                    fontSize: 18),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Spacer(),
                              Text(
                                '${quantity}',
                                style: const TextStyle(fontSize: 17),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Price(),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    );
                  }
                } else {
                  return const SizedBox.shrink();
                }
              })),
    );
  }

  Widget Price() {
    return Row(
      children: [
        Text.rich(
          TextSpan(
            text:
                '${widget.product.total_price / widget.product.total_quantity} da',
            style: const TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
            children: [
              const TextSpan(
                  text: "/piece",
                  style: TextStyle(fontSize: 18, color: kPrimaryColor)),
            ],
          ),
        ),
        const Spacer(),
        Text.rich(
          TextSpan(
            text: 'Price:',
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: kPrimaryColor,
                fontSize: 18),
            children: [
              TextSpan(
                  text: " ${widget.product.total_price}",
                  style: const TextStyle(fontSize: 18, color: Colors.black)),
              const TextSpan(
                  text: " Da",
                  style: TextStyle(fontSize: 18, color: Colors.black)),
            ],
          ),
        ),
      ],
    );
  }

  Widget Image_widget({required String image}) {
    return GestureDetector(
      onTap: () async {
        Product product =
            await getProductsByReference(widget.product.reference);
        Navigator.of(context).push(MaterialPageRoute(
            builder: ((context) => DetailsScreen(
                  product: product,
                  ref: null,
                ))));
      },
      child: SizedBox(
        width: 80,
        height: 80,
        child: AspectRatio(
          aspectRatio: 0.80,
          child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6F9),
                borderRadius: BorderRadius.circular(15),
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
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return const BuildShimmerEffect();
                    },
                    errorBuilder: (_, __, ___) => const BuildShimmerEffect(),
                  );
                },
              )),
        ),
      ),
    );
  }

  Widget ColorOnlyCartWidget({required productSnapshot}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(
          color: Colors.grey,
          width: 0.3,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              productSnapshot.product_name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.product.variations!.length,
              itemBuilder: ((context, index) {
                int quantity = widget.product.variations![index]['quantity'];
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey,
                      width: 0.3,
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Row(
                    children: [
                      Image_widget(
                          image: widget.product.variations![index]['image']),
                      const SizedBox(width: 20),
                      Text(
                        AppLocalizations.of(context)!.quantity,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: kPrimaryColor,
                            fontSize: 18),
                      ),
                      const Spacer(),
                      Text(
                        '${quantity}',
                        style: const TextStyle(fontSize: 17),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                );
              })),
          const SizedBox(
            height: 10,
          ),
          Price(),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget SizeOnlyCartWidget({required Product productSnapshot}) {
    Map<String, dynamic> sizesQuantity = widget.product.variations![0]['sizes'];
    List<Widget> sizeWidgets = sizesQuantity.entries.map((entry) {
      String size = entry.key;
      int quantity = entry.value;

      return Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[100],
            ),
            child: SizedBox(
              height: 60,
              child: Row(
                children: [
                  Text(
                    size,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const Spacer(),
                  Text(
                    '${quantity}',
                    style: const TextStyle(fontSize: 17),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          )
        ],
      );
    }).toList();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(
          color: Colors.grey,
          width: 0.3,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              productSnapshot.product_name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image_widget(image: productSnapshot.main_photo),
              const SizedBox(width: 20),
              Flexible(
                child: Column(children: sizeWidgets),
              ), // Display sizes and quantities here
            ],
          ),
          Price(),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget ColorAndSizeCartWidget({required Product productSnapshot}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(
          color: Colors.grey,
          width: 0.3,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              productSnapshot.product_name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.product.variations!.length,
              itemBuilder: ((context, index) {
                Map<String, dynamic> sizesQuantity =
                    widget.product.variations![index]['sizes'];
                List<Widget> sizeWidgets = sizesQuantity.entries.map((entry) {
                  String size = entry.key;
                  int quantity = entry.value;

                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[100],
                        ),
                        child: SizedBox(
                          height: 60,
                          child: Row(
                            children: [
                              Text(
                                size,
                                style: const TextStyle(fontSize: 18),
                              ),
                              const Spacer(),
                              Text(
                                '${quantity}',
                                style: const TextStyle(fontSize: 17),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      )
                    ],
                  );
                }).toList();
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey,
                      width: 0.3,
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image_widget(
                          image: widget.product.variations![index]['image']),
                      const SizedBox(width: 20),
                      ////////////////////////////////////////////////////
                      Flexible(
                        child: Column(children: sizeWidgets),
                      ), // Display sizes and quantities here
                    ],
                  ),
                );
              })),
          const SizedBox(
            height: 10,
          ),
          Price(),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
