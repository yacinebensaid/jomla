import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jomla/constants/constants.dart';
import 'package:jomla/services/auth/auth_service.dart';
import 'package:jomla/services/crud/pcf_service.dart';
import 'package:jomla/size_config.dart';
import 'package:jomla/utilities/reusable.dart';
import 'package:jomla/utilities/shimmers.dart';
import 'package:jomla/view/products_card/product.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'default_btn.dart';

class OrderProduct extends StatefulWidget {
  final Product product;
  const OrderProduct({super.key, required this.product});

  @override
  State<OrderProduct> createState() => _OrderProductState();
}

class _OrderProductState extends State<OrderProduct> {
  bool _added = false;
  int _index = 0;
  int selectedImage = 0;
  int chosenQuantity = 0;
  Map<String, int> chosenQuantities = {};
  Map<String, dynamic> order = {};
  int _quantity = 0;
  int totalPrice = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: _buildVariations()),
          const SizedBox(
            height: 10,
          ),
          _added
              ? AddedToCartButton()
              : Container(
                  width: 250,
                  child: DefaultButton(
                    text: AppLocalizations.of(context)!.addtocart,
                    press: () {
                      if (kIsWeb) {
                        if (AuthService.firebase().currentUser != null) {
                          if (widget.product.available_quantity == null) {
                            if (widget.product.variations != null) {
                              if (widget.product.variations!.isNotEmpty) {
                                if (widget.product.variations![0]
                                            ['color_details'] !=
                                        null &&
                                    widget.product.variations![0]
                                            ['size_details'] ==
                                        null) {
                                  ////////////////////////////////////////////////
                                  if (_quantity != 0) {
                                    setState(() {
                                      _added = true;
                                    });
                                    order['image'] = widget
                                            .product.variations![selectedImage]
                                        ['color_details']['image'];
                                    order['color_name'] = widget
                                            .product.variations![selectedImage]
                                        ['color_details']['color_name'];
                                    order['sizes'] = null;
                                    order['quantity'] = _quantity;
                                    order['total_price'] = totalPrice;
                                    order['reference'] =
                                        widget.product.reference;
                                    UserPCFService.addToCart(order: order);
                                    setState(() {
                                      chosenQuantity = 0;
                                      chosenQuantities = {};
                                      order = {};
                                      _quantity = 0;
                                      totalPrice = 0;
                                    });
                                    Future.delayed(
                                            const Duration(milliseconds: 2000))
                                        .then((value) => setState(() {
                                              _added = false;
                                            }));
                                  }
                                } else if (widget.product.variations![0]
                                            ['color_details'] ==
                                        null &&
                                    widget.product.variations![0]
                                            ['size_details'] !=
                                        null) {
                                  ////////////////////////////////////////////////
                                  bool quantitiesValid = false;
                                  widget
                                      .product
                                      .variations![0]['size_details']
                                          ['size_quantity']
                                      .forEach((size, maxQuantity) {
                                    if (chosenQuantities.isNotEmpty &&
                                        chosenQuantities != {} &&
                                        chosenQuantities[size] != 0) {
                                      quantitiesValid = true;
                                    }
                                  });

                                  if (quantitiesValid) {
                                    setState(() {
                                      _added = true;
                                    });
                                    order['image'] = null;
                                    order['color_name'] = null;
                                    Map<String, int> selectedSizes = {};
                                    widget
                                        .product
                                        .variations![0]['size_details']
                                            ['size_quantity']
                                        .forEach((size, maxQuantity) {
                                      if (chosenQuantities[size] != null &&
                                          chosenQuantities[size]! > 0) {
                                        selectedSizes[size] =
                                            chosenQuantities[size]!;
                                        _quantity =
                                            _quantity + chosenQuantities[size]!;
                                      }
                                    });
                                    order['sizes'] = selectedSizes;
                                    order['quantity'] = null;
                                    order['total_price'] = null;
                                    order['reference'] =
                                        widget.product.reference;
                                    UserPCFService.addToCart(order: order);

                                    setState(() {
                                      chosenQuantity = 0;
                                      chosenQuantities = {};
                                      order = {};
                                      _quantity = 0;
                                      totalPrice = 0;
                                    });
                                    Future.delayed(
                                            const Duration(milliseconds: 2000))
                                        .then((value) => setState(() {
                                              _added = false;
                                            }));
                                  }
                                } else if (widget.product.variations![0]
                                            ['color_details'] !=
                                        null &&
                                    widget.product.variations![0]
                                            ['size_details'] !=
                                        null) {
                                  ////////////////////////////////////////////////
                                  bool quantitiesValid = false;
                                  widget
                                      .product
                                      .variations![0]['size_details']
                                          ['size_quantity']
                                      .forEach((size, maxQuantity) {
                                    if (chosenQuantities.isNotEmpty &&
                                        chosenQuantities != {} &&
                                        chosenQuantities[size] != 0) {
                                      quantitiesValid = true;
                                    }
                                  });

                                  if (quantitiesValid) {
                                    setState(() {
                                      _added = true;
                                    });

                                    // Store the order details
                                    order['image'] = widget
                                            .product.variations![selectedImage]
                                        ['color_details']['image'];
                                    order['color_name'] = widget
                                            .product.variations![selectedImage]
                                        ['color_details']['color_name'];

                                    Map<String, int> selectedSizes = {};
                                    widget
                                        .product
                                        .variations![selectedImage]
                                            ['size_details']['size_quantity']
                                        .forEach((size, maxQuantity) {
                                      if (chosenQuantities[size] != null &&
                                          chosenQuantities[size]! > 0) {
                                        selectedSizes[size] = chosenQuantities[
                                            size]!; //////////////<<<<<<<<<<<<<<
                                        _quantity =
                                            _quantity + chosenQuantities[size]!;
                                      }
                                    });
                                    order['sizes'] = selectedSizes;
                                    order['quantity'] = _quantity;
                                    order['total_price'] = null;
                                    order['reference'] =
                                        widget.product.reference;
                                    UserPCFService.addToCart(order: order);

                                    setState(() {
                                      chosenQuantity = 0;
                                      chosenQuantities = {};
                                      order = {};
                                      _quantity = 0;
                                      totalPrice = 0;
                                    });
                                    Future.delayed(
                                            const Duration(milliseconds: 2000))
                                        .then((value) => setState(() {
                                              _added = false;
                                            }));
                                  }
                                } else {}
                              } else {}
                            } else {}
                          } else {
                            if (_quantity != 0) {
                              setState(() {
                                _added = true;
                              });
                              order['image'] = null;
                              order['color_name'] = null;
                              order['sizes'] = null;
                              order['quantity'] = _quantity;
                              order['total_price'] = totalPrice;
                              order['reference'] = widget.product.reference;

                              print(order);
                              UserPCFService.addToCart(order: order);
                              setState(() {
                                chosenQuantity = 0;
                                chosenQuantities = {};
                                order = {};
                                _quantity = 0;
                                totalPrice = 0;
                              });
                              Future.delayed(const Duration(milliseconds: 2000))
                                  .then((value) => setState(() {
                                        _added = false;
                                      }));
                            }

                            ///////////////////////////////////////////===<<<<<
                          }
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
                            if (widget.product.available_quantity == null) {
                              if (widget.product.variations != null) {
                                if (widget.product.variations!.isNotEmpty) {
                                  if (widget.product.variations![0]
                                              ['color_details'] !=
                                          null &&
                                      widget.product.variations![0]
                                              ['size_details'] ==
                                          null) {
                                    ////////////////////////////////////////////////
                                    if (_quantity != 0) {
                                      setState(() {
                                        _added = true;
                                      });
                                      order['image'] = widget.product
                                              .variations![selectedImage]
                                          ['color_details']['image'];
                                      order['color_name'] = widget.product
                                              .variations![selectedImage]
                                          ['color_details']['color_name'];
                                      order['sizes'] = null;
                                      order['quantity'] = _quantity;
                                      order['total_price'] = totalPrice;
                                      order['reference'] =
                                          widget.product.reference;
                                      UserPCFService.addToCart(order: order);
                                      setState(() {
                                        chosenQuantity = 0;
                                        chosenQuantities = {};
                                        order = {};
                                        _quantity = 0;
                                        totalPrice = 0;
                                      });
                                      Future.delayed(const Duration(
                                              milliseconds: 2000))
                                          .then((value) => setState(() {
                                                _added = false;
                                              }));
                                    }
                                  } else if (widget.product.variations![0]
                                              ['color_details'] ==
                                          null &&
                                      widget.product.variations![0]
                                              ['size_details'] !=
                                          null) {
                                    ////////////////////////////////////////////////
                                    bool quantitiesValid = false;
                                    widget
                                        .product
                                        .variations![0]['size_details']
                                            ['size_quantity']
                                        .forEach((size, maxQuantity) {
                                      if (chosenQuantities.isNotEmpty &&
                                          chosenQuantities != {} &&
                                          chosenQuantities[size] != 0) {
                                        quantitiesValid = true;
                                      }
                                    });

                                    if (quantitiesValid) {
                                      setState(() {
                                        _added = true;
                                      });
                                      order['image'] = null;
                                      order['color_name'] = null;
                                      Map<String, int> selectedSizes = {};
                                      widget
                                          .product
                                          .variations![0]['size_details']
                                              ['size_quantity']
                                          .forEach((size, maxQuantity) {
                                        if (chosenQuantities[size] != null &&
                                            chosenQuantities[size]! > 0) {
                                          selectedSizes[size] =
                                              chosenQuantities[size]!;
                                          _quantity = _quantity +
                                              chosenQuantities[size]!;
                                        }
                                      });
                                      order['sizes'] = selectedSizes;
                                      order['quantity'] = null;
                                      order['total_price'] = null;
                                      order['reference'] =
                                          widget.product.reference;
                                      UserPCFService.addToCart(order: order);

                                      setState(() {
                                        chosenQuantity = 0;
                                        chosenQuantities = {};
                                        order = {};
                                        _quantity = 0;
                                        totalPrice = 0;
                                      });
                                      Future.delayed(const Duration(
                                              milliseconds: 2000))
                                          .then((value) => setState(() {
                                                _added = false;
                                              }));
                                    }
                                  } else if (widget.product.variations![0]
                                              ['color_details'] !=
                                          null &&
                                      widget.product.variations![0]
                                              ['size_details'] !=
                                          null) {
                                    ////////////////////////////////////////////////
                                    bool quantitiesValid = false;
                                    widget
                                        .product
                                        .variations![0]['size_details']
                                            ['size_quantity']
                                        .forEach((size, maxQuantity) {
                                      if (chosenQuantities.isNotEmpty &&
                                          chosenQuantities != {} &&
                                          chosenQuantities[size] != 0) {
                                        quantitiesValid = true;
                                      }
                                    });

                                    if (quantitiesValid) {
                                      setState(() {
                                        _added = true;
                                      });

                                      // Store the order details
                                      order['image'] = widget.product
                                              .variations![selectedImage]
                                          ['color_details']['image'];
                                      order['color_name'] = widget.product
                                              .variations![selectedImage]
                                          ['color_details']['color_name'];

                                      Map<String, int> selectedSizes = {};
                                      widget
                                          .product
                                          .variations![selectedImage]
                                              ['size_details']['size_quantity']
                                          .forEach((size, maxQuantity) {
                                        if (chosenQuantities[size] != null &&
                                            chosenQuantities[size]! > 0) {
                                          selectedSizes[size] = chosenQuantities[
                                              size]!; //////////////<<<<<<<<<<<<<<
                                          _quantity = _quantity +
                                              chosenQuantities[size]!;
                                        }
                                      });
                                      order['sizes'] = selectedSizes;
                                      order['quantity'] = _quantity;
                                      order['total_price'] = null;
                                      order['reference'] =
                                          widget.product.reference;
                                      UserPCFService.addToCart(order: order);

                                      setState(() {
                                        chosenQuantity = 0;
                                        chosenQuantities = {};
                                        order = {};
                                        _quantity = 0;
                                        totalPrice = 0;
                                      });
                                      Future.delayed(const Duration(
                                              milliseconds: 2000))
                                          .then((value) => setState(() {
                                                _added = false;
                                              }));
                                    }
                                  } else {}
                                } else {}
                              } else {}
                            } else {
                              if (_quantity != 0) {
                                setState(() {
                                  _added = true;
                                });
                                order['image'] = null;
                                order['color_name'] = null;
                                order['sizes'] = null;
                                order['quantity'] = _quantity;
                                order['total_price'] = totalPrice;
                                order['reference'] = widget.product.reference;

                                print(order);
                                UserPCFService.addToCart(order: order);
                                setState(() {
                                  chosenQuantity = 0;
                                  chosenQuantities = {};
                                  order = {};
                                  _quantity = 0;
                                  totalPrice = 0;
                                });
                                Future.delayed(
                                        const Duration(milliseconds: 2000))
                                    .then((value) => setState(() {
                                          _added = false;
                                        }));
                              }

                              ///////////////////////////////////////////===<<<<<
                            }
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
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return const AlertDialog(
                                content: Text(
                                  'You are not connected to the internet.',
                                  style: TextStyle(fontSize: 18),
                                ),
                              );
                            },
                          );
                          Future.delayed(const Duration(seconds: 3), () {
                            Navigator.of(context)
                                .pop(); // Close the dialog after 3 seconds
                          });
                        }
                      }
                    },
                  ),
                ),
          const SizedBox(
            height: 25,
          )
        ],
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////////

  Widget _buildColorImages({required bool withSizeOrNot}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        withSizeOrNot
            ? Padding(
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
                        int color = int.parse(widget.product.variations![index]
                            ['color_details']['color']);

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedImage = index;
                            });
                          },
                          child: Container(
                              margin: const EdgeInsets.only(right: 15),
                              padding: const EdgeInsets.all(8),
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Color(color).withOpacity(
                                      selectedImage == index ? 1 : 0),
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
                              )),
                        );
                      })),
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SizedBox(
                  height: 140,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.product.variations!.length,
                            itemBuilder: ((context, index) {
                              String image = widget.product.variations![index]
                                  ['color_details']['image'];
                              int color = int.parse(
                                  widget.product.variations![index]
                                      ['color_details']['color']);

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedImage = index;
                                    _index = index;
                                    _quantity = 0;
                                    totalPrice = 0;
                                  });
                                },
                                child: Container(
                                    margin: const EdgeInsets.only(right: 15),
                                    padding: const EdgeInsets.all(8),
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Color(color).withOpacity(
                                            selectedImage == index ? 1 : 0),
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
                                              ImageChunkEvent?
                                                  loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return const BuildShimmerEffect();
                                          },
                                          errorBuilder: (_, __, ___) =>
                                              const BuildShimmerEffect(),
                                        );
                                      },
                                    )),
                              );
                            })),
                      ),
                      quantitySelector(
                        colors: true,
                        maxQuantity: int.parse(widget.product
                            .variations![_index]['color_details']['quantity']),
                        priceQS: widget.product.price,
                      ),
                    ],
                  ),
                ),
              )
      ],
    );
  }

  /////////////////////////////////////////////////////////////////////

  Widget quantitySelector({
    required int maxQuantity,
    required List priceQS,
    required bool colors,
  }) {
    void _updateTotalPrice() {
      int price = int.parse(priceQS[0]['price']!);
      if (int.parse(priceQS.last['from']) < _quantity) {
        price = int.parse(priceQS.last['price']!);
      } else {
        for (int i = 0; i < priceQS.length; i++) {
          if (int.parse(priceQS[i]['from']!) <= _quantity &&
              _quantity <= int.parse(priceQS[i]['to']!)) {
            price = int.parse(priceQS[i]['price']!);
            break;
          }
        }
      }
      setState(() {
        totalPrice = _quantity * price;
      });
    }

    void _incrementQuantity() {
      if (_quantity < maxQuantity) {
        setState(() {
          _quantity++;
        });
        _updateTotalPrice();
      }
    }

    void _decrementQuantity() {
      if (_quantity > 0) {
        setState(() {
          _quantity--;
        });
        _updateTotalPrice();
      }
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: IconButton(
                onPressed: _decrementQuantity,
                icon: const Icon(Icons.remove),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "$_quantity",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: _incrementQuantity,
                icon: const Icon(Icons.add),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        if (!colors)
          Text(
            "Total: \$$totalPrice",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: kPrimaryColor,
            ),
          ),
      ],
    );
  }

  //////////////////////////////////////////////////////////////////////////////////

  Widget _buildSizes(int? index) {
    Map variation = widget.product.variations![index ?? 0];
    Map sizeDetails = variation['size_details'];
    Map sizeQuantity = sizeDetails['size_quantity'];
    List<Widget> sizeWidgets = [];

    sizeQuantity.forEach((key, value) {
      String size = key;
      int maxQuantity = int.parse(value);

      sizeWidgets.add(
        SizeOptionWidget(size: size, maxQuantity: maxQuantity),
      );
    });

    return Column(
      children: sizeWidgets,
    );
  }

  //////////////////////////////////////////////////////////////////////////////////

  Widget SizeOptionWidget({required String size, required int maxQuantity}) {
    void incrementQuantity() {
      if (chosenQuantities[size] == null) {
        chosenQuantities[size] = 0;
      }
      if (chosenQuantities[size]! < maxQuantity) {
        setState(() {
          chosenQuantities[size] = chosenQuantities[size]! + 1;
        });
      }
    }

    void decrementQuantity() {
      if (chosenQuantities[size] == null) {
        chosenQuantities[size] = 0;
      }
      if (chosenQuantities[size]! > 0) {
        setState(() {
          chosenQuantities[size] = chosenQuantities[size]! - 1;
        });
      }
    }

    int chosenQuantity = chosenQuantities[size] ?? 0;

    return Row(
      children: [
        Text(
          size,
          style: const TextStyle(fontSize: 20),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: decrementQuantity,
        ),
        Text(chosenQuantity.toString()),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: incrementQuantity,
        ),
      ],
    );
  }

  //////////////////////////////////////////////////////////////////////////////////

  Widget _buildVariations() {
    if (widget.product.available_quantity == null) {
      if (widget.product.variations != null) {
        if (widget.product.variations!.isNotEmpty) {
          if (widget.product.variations![0]['color_details'] != null &&
              widget.product.variations![0]['size_details'] == null) {
            return _buildColorImages(withSizeOrNot: false);
          } else if (widget.product.variations![0]['color_details'] == null &&
              widget.product.variations![0]['size_details'] != null) {
            return _buildSizes(null);
          } else if (widget.product.variations![0]['color_details'] != null &&
              widget.product.variations![0]['size_details'] != null) {
            return Column(
              children: [
                _buildColorImages(withSizeOrNot: true),
                _buildSizes(selectedImage)
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
      return quantitySelector(
        colors: false,
        maxQuantity: widget.product.available_quantity!,
        priceQS: widget.product.price,
      );
    }
  }
}

//////////////////////////////////////////////////////////////////////////////////

Widget AddedToCartButton() {
  return SizedBox(
    width: 250,
    height: 56,
    child: TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: kPrimaryColor, width: 2),
        ),
        backgroundColor: Colors.white,
        foregroundColor: kPrimaryColor,
      ),
      onPressed: () {},
      child: Text(
        'Added successfully!',
        style: TextStyle(
          fontSize: getProportionateScreenWidth(18),
          color: kPrimaryColor,
        ),
      ),
    ),
  );
}
