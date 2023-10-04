import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jomla/services/crud/pcf_service.dart';
import 'package:jomla/services/crud/product_service.dart';
import 'package:jomla/utilities/shimmers.dart';
import 'package:jomla/view/product_datails/details_view.dart';
import 'package:jomla/view/products_card/product.dart';
import 'package:provider/provider.dart';

class CartCard extends StatefulWidget {
  final bool? finalCheckout;
  const CartCard({
    Key? key,
    required this.product,
    this.finalCheckout,
  }) : super(key: key);

  final CartProduct product;

  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  CacheManager cachManager = CacheManager(Config('CachedImages',
      stalePeriod: const Duration(days: 7), maxNrOfCacheObjects: 100));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
          future: ProductService.getProductDataByReference(
              widget.product.reference),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ShimmerColorOnlyCartWidget();
            } else if (snapshot.hasData && snapshot.data != null) {
              Product productSnapshot = snapshot.data!;
              if (productSnapshot.variations != null) {
                if (productSnapshot.variations!.isNotEmpty) {
                  if (productSnapshot.variations![0]['color_details'] != null &&
                      productSnapshot.variations![0]['size_details'] == null) {
                    return ColorOnlyCartWidget(
                        productSnapshot: productSnapshot);
                  } else if (productSnapshot.variations![0]['color_details'] ==
                          null &&
                      productSnapshot.variations![0]['size_details'] != null) {
                    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    return SizeOnlyCartWidget(productSnapshot: productSnapshot);
                  } else if (productSnapshot.variations![0]['color_details'] !=
                          null &&
                      productSnapshot.variations![0]['size_details'] != null) {
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
                int maxqua = productSnapshot.available_quantity!;
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
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            if (widget.finalCheckout == null)
                              const SizedBox(
                                width: 40,
                              ),
                            Text(
                              productSnapshot.product_name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            if (widget.finalCheckout == null) const Spacer(),
                            if (widget.finalCheckout == null)
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Delete order'),
                                          content: const Text(
                                              'Do you confirm deleting this order?'),
                                          actions: [
                                            TextButton(
                                              child: const Text('Cancel'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: const Text('Confirm'),
                                              onPressed: () {
                                                UserPCFService.delete_from_cart(
                                                    widget.product.reference);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                },
                                icon: const Icon(
                                  Icons.clear,
                                  size: 18,
                                ),
                              )
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Image_widget(image: productSnapshot.main_photo),
                          const SizedBox(width: 20),
                          Text(
                            'Quantity:',
                            style: const TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 247, 132, 0),
                                fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            '${quantity}',
                            style: const TextStyle(fontSize: 17),
                          ),
                          if (widget.finalCheckout == null) const Spacer(),
                          if (widget.finalCheckout == null)
                            IconButton(
                                onPressed: () {
                                  final internetConnectionStatus =
                                      Provider.of<InternetConnectionStatus>(
                                          context,
                                          listen: false);
                                  if (internetConnectionStatus ==
                                      InternetConnectionStatus.connected) {
                                    int _quantity = quantity;
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(
                                            builder: (context, setState) {
                                          return AlertDialog(
                                            title: const Text('Edit'),
                                            content: Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.remove,
                                                  ),
                                                  onPressed: () {
                                                    if (_quantity != 1) {
                                                      setState(() {
                                                        _quantity =
                                                            _quantity - 1;
                                                      });
                                                    }
                                                  },
                                                ),
                                                Text(
                                                  '${_quantity}',
                                                  style: const TextStyle(
                                                      fontSize: 17),
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.add,
                                                  ),
                                                  onPressed: () {
                                                    if (_quantity < maxqua) {
                                                      setState(() {
                                                        _quantity =
                                                            _quantity + 1;
                                                      });
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                child: const Text('Cancel'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: const Text('Save'),
                                                onPressed: () {
                                                  final internetConnectionStatus =
                                                      Provider.of<
                                                              InternetConnectionStatus>(
                                                          context,
                                                          listen: false);
                                                  if (internetConnectionStatus ==
                                                      InternetConnectionStatus
                                                          .connected) {
                                                    UserPCFService
                                                        .modifyProductInCart(
                                                            productSnapshot
                                                                .reference,
                                                            null,
                                                            _quantity,
                                                            null);
                                                    // Perform the edit action here
                                                    Navigator.of(context).pop();
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                      content: Text(
                                                          'you are not connected'),
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                    ));
                                                  }
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                      },
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text('you are not connected'),
                                      behavior: SnackBarBehavior.floating,
                                    ));
                                  }
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  size: 17,
                                )),
                        ],
                      ),
                      if (quantity > maxqua)
                        maxqua != 0
                            ? Text(
                                'Maximum quantity: ${maxqua} !',
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w900),
                              )
                            : const Text(
                                'Out of Stock !',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w900),
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
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
            children: [
              const TextSpan(
                  text: "/piece",
                  style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 247, 132, 0),
                      fontWeight: FontWeight.w900)),
            ],
          ),
        ),
        const Spacer(),
        Text.rich(
          TextSpan(
            text: 'Price:',
            style: const TextStyle(
                color: Color.fromARGB(255, 247, 132, 0),
                fontWeight: FontWeight.w900,
                fontSize: 18),
            children: [
              TextSpan(
                  text: " ${widget.product.total_price}",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  )),
              const TextSpan(
                  text: " Da",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  )),
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
      child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F6F9),
            borderRadius: BorderRadius.circular(15),
          ),
          child: CachedNetworkImage(
            key: UniqueKey(),
            imageUrl: image,
            height: 60,
            width: 60,
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
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                if (widget.finalCheckout == null)
                  const SizedBox(
                    width: 40,
                  ),
                Text(
                  productSnapshot.product_name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                if (widget.finalCheckout == null) const Spacer(),
                if (widget.finalCheckout == null)
                  IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Delete order'),
                              content: const Text(
                                  'Do you confirm deleting this order?'),
                              actions: [
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Confirm'),
                                  onPressed: () {
                                    UserPCFService.delete_from_cart(
                                        widget.product.reference);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
                    },
                    icon: const Icon(
                      Icons.clear,
                      size: 18,
                    ),
                  )
              ],
            ),
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.product.variations!.length,
              itemBuilder: ((context, index) {
                int quantity = widget.product.variations![index]['quantity'];
                int maxqua = 0;
                for (Map vari in productSnapshot.variations!) {
                  if (widget.product.variations![index]['image'] ==
                      vari['color_details']['image']) {
                    maxqua = int.parse(vari['color_details']['quantity']);
                    break;
                  }
                }
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey,
                          width: 0.3,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      child: Row(
                        children: [
                          Image_widget(
                              image: widget.product.variations![index]
                                  ['image']),
                          const SizedBox(width: 20),
                          Text(
                            'Quantity:',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 247, 132, 0),
                                fontSize: 18),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            '${quantity}',
                            style: const TextStyle(fontSize: 17),
                          ),
                          if (widget.finalCheckout == null) const Spacer(),
                          if (widget.finalCheckout == null)
                            IconButton(
                              onPressed: () {
                                final internetConnectionStatus =
                                    Provider.of<InternetConnectionStatus>(
                                        context,
                                        listen: false);
                                if (internetConnectionStatus ==
                                    InternetConnectionStatus.connected) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      int _quantity = quantity;

                                      return StatefulBuilder(
                                          builder: (context, setState) {
                                        return AlertDialog(
                                          title: const Text('Edit'),
                                          content: Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.remove),
                                                onPressed: () {
                                                  if (_quantity != 1) {
                                                    setState(() {
                                                      _quantity = _quantity - 1;
                                                    });
                                                  }
                                                },
                                              ),
                                              Text(
                                                '${_quantity}',
                                                style: const TextStyle(
                                                    fontSize: 17),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.add),
                                                onPressed: () {
                                                  if (_quantity < maxqua) {
                                                    setState(() {
                                                      _quantity = _quantity + 1;
                                                    });
                                                  }
                                                },
                                              ),
                                              const Spacer(),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    UserPCFService
                                                        .delete_variation(
                                                            type: 'color',
                                                            index: index,
                                                            reference: widget
                                                                .product
                                                                .reference,
                                                            size: null);
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Delete'))
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              child: const Text('Cancel'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: const Text('Save'),
                                              onPressed: () {
                                                final internetConnectionStatus =
                                                    Provider.of<
                                                            InternetConnectionStatus>(
                                                        context,
                                                        listen: false);
                                                if (internetConnectionStatus ==
                                                    InternetConnectionStatus
                                                        .connected) {
                                                  UserPCFService
                                                      .modifyProductInCart(
                                                          productSnapshot
                                                              .reference,
                                                          null,
                                                          _quantity,
                                                          index);
                                                  // Perform the edit action here
                                                  Navigator.of(context).pop();
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                          const SnackBar(
                                                    content: Text(
                                                        'you are not connected'),
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                  ));
                                                }
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                    },
                                  );
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('you are not connected'),
                                    behavior: SnackBarBehavior.floating,
                                  ));
                                }
                              },
                              icon: const Icon(
                                Icons.edit,
                                size: 17,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (quantity > maxqua)
                      maxqua != 0
                          ? Text(
                              'Maximum quantity: ${maxqua} !',
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w900),
                            )
                          : const Text(
                              'Out of Stock !',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w900),
                            ),
                  ],
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

      int _quantity = quantity;
      int maxqua = int.parse(productSnapshot.variations![0]['size_details']
          ['size_quantity'][size]);

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
                  if (widget.finalCheckout == null) const Spacer(),
                  Row(
                    children: [
                      Text(
                        '${quantity}',
                        style: const TextStyle(fontSize: 17),
                      ),
                      if (widget.finalCheckout == null)
                        IconButton(
                            onPressed: () {
                              final internetConnectionStatus =
                                  Provider.of<InternetConnectionStatus>(context,
                                      listen: false);
                              if (internetConnectionStatus ==
                                  InternetConnectionStatus.connected) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(
                                        builder: (context, setState) {
                                      return AlertDialog(
                                        title: const Text('Edit'),
                                        content: Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.remove,
                                              ),
                                              onPressed: () {
                                                if (_quantity != 1) {
                                                  setState(() {
                                                    _quantity = _quantity - 1;
                                                  });
                                                }
                                              },
                                            ),
                                            Text(
                                              '${_quantity}',
                                              style:
                                                  const TextStyle(fontSize: 17),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.add,
                                              ),
                                              onPressed: () {
                                                if (_quantity < maxqua) {
                                                  setState(() {
                                                    _quantity = _quantity + 1;
                                                  });
                                                }
                                              },
                                            ),
                                            const Spacer(),
                                            ElevatedButton(
                                                onPressed: () {
                                                  UserPCFService
                                                      .delete_variation(
                                                          type: 'color',
                                                          index: 0,
                                                          reference: widget
                                                              .product
                                                              .reference,
                                                          size: size);
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Delete'))
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            child: const Text('Cancel'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('Edit'),
                                            onPressed: () {
                                              final internetConnectionStatus =
                                                  Provider.of<
                                                          InternetConnectionStatus>(
                                                      context,
                                                      listen: false);
                                              if (internetConnectionStatus ==
                                                  InternetConnectionStatus
                                                      .connected) {
                                                UserPCFService
                                                    .modifyProductInCart(
                                                        productSnapshot
                                                            .reference,
                                                        size,
                                                        _quantity,
                                                        null);
                                                // Perform the edit action here
                                                Navigator.of(context).pop();
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                  content: Text(
                                                      'you are not connected'),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                ));
                                              }
                                            },
                                          ),
                                        ],
                                      );
                                    });
                                  },
                                );
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text('you are not connected'),
                                  behavior: SnackBarBehavior.floating,
                                ));
                              }
                            },
                            icon: const Icon(
                              Icons.edit,
                              size: 17,
                            ))
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (quantity > maxqua)
            maxqua != 0
                ? Text(
                    'Maximum quantity: ${maxqua} !',
                    style: const TextStyle(color: Colors.red),
                  )
                : const Text(
                    'Out of Stock !',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                        fontWeight: FontWeight.w900),
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
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                if (widget.finalCheckout == null)
                  const SizedBox(
                    width: 40,
                  ),
                Text(
                  productSnapshot.product_name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                if (widget.finalCheckout == null) const Spacer(),
                if (widget.finalCheckout == null)
                  IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Delete order'),
                              content: const Text(
                                  'Do you confirm deleting this order?'),
                              actions: [
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Confirm'),
                                  onPressed: () {
                                    UserPCFService.delete_from_cart(
                                        widget.product.reference);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
                    },
                    icon: const Icon(
                      Icons.clear,
                      size: 18,
                    ),
                  )
              ],
            ),
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
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                if (widget.finalCheckout == null)
                  const SizedBox(
                    width: 40,
                  ),
                Text(
                  productSnapshot.product_name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                if (widget.finalCheckout == null) const Spacer(),
                if (widget.finalCheckout == null)
                  IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Delete order'),
                              content: const Text(
                                  'Do you confirm deleting this order?'),
                              actions: [
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Confirm'),
                                  onPressed: () {
                                    UserPCFService.delete_from_cart(
                                        widget.product.reference);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
                    },
                    icon: const Icon(
                      Icons.clear,
                      size: 18,
                    ),
                  )
              ],
            ),
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
                  int maxqua = 0;
                  for (Map vari in productSnapshot.variations!) {
                    if (widget.product.variations![index]['image'] ==
                        vari['color_details']['image']) {
                      maxqua = int.parse(
                          vari['size_details']['size_quantity'][size]);
                      break;
                    }
                  }
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
                              if (widget.finalCheckout == null)
                                IconButton(
                                    onPressed: () {
                                      final internetConnectionStatus =
                                          Provider.of<InternetConnectionStatus>(
                                              context,
                                              listen: false);
                                      if (internetConnectionStatus ==
                                          InternetConnectionStatus.connected) {
                                        int _quantity = quantity;

                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return StatefulBuilder(
                                                builder: (context, setState) {
                                              return AlertDialog(
                                                title: const Text('Edit'),
                                                content: Row(
                                                  children: [
                                                    IconButton(
                                                      icon: const Icon(
                                                        Icons.remove,
                                                      ),
                                                      onPressed: () {
                                                        if (_quantity != 1) {
                                                          setState(() {
                                                            _quantity =
                                                                _quantity - 1;
                                                          });
                                                        }
                                                      },
                                                    ),
                                                    Text(
                                                      '${_quantity}',
                                                      style: const TextStyle(
                                                          fontSize: 17),
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(
                                                        Icons.add,
                                                      ),
                                                      onPressed: () {
                                                        if (_quantity <
                                                            maxqua) {
                                                          setState(() {
                                                            _quantity =
                                                                _quantity + 1;
                                                          });
                                                        }
                                                      },
                                                    ),
                                                    const Spacer(),
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          UserPCFService
                                                              .delete_variation(
                                                                  type: 'color',
                                                                  index: index,
                                                                  reference: widget
                                                                      .product
                                                                      .reference,
                                                                  size: size);
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                            'Delete'))
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(
                                                    child: const Text('Cancel'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: const Text('Edit'),
                                                    onPressed: () {
                                                      final internetConnectionStatus =
                                                          Provider.of<
                                                                  InternetConnectionStatus>(
                                                              context,
                                                              listen: false);
                                                      if (internetConnectionStatus ==
                                                          InternetConnectionStatus
                                                              .connected) {
                                                        UserPCFService
                                                            .modifyProductInCart(
                                                                productSnapshot
                                                                    .reference,
                                                                size,
                                                                _quantity,
                                                                index);
                                                        // Perform the edit action here
                                                        Navigator.of(context)
                                                            .pop();
                                                      } else {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                const SnackBar(
                                                          content: Text(
                                                              'you are not connected'),
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                        ));
                                                      }
                                                    },
                                                  ),
                                                ],
                                              );
                                            });
                                          },
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content:
                                              Text('you are not connected'),
                                          behavior: SnackBarBehavior.floating,
                                        ));
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      size: 17,
                                    )),
                            ],
                          ),
                        ),
                      ),
                      if (quantity > maxqua)
                        maxqua != 0
                            ? Text(
                                'Maximum quantity: ${maxqua} !',
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w900),
                              )
                            : const Text(
                                'Out of Stock !',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w900),
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
