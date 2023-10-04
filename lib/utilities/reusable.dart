import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jomla/constants/const_routs.dart';
import 'package:jomla/services/auth/auth_service.dart';

import 'package:jomla/size_config.dart';
import 'package:jomla/utilities/loading_user_products.dart';
import 'package:jomla/view/products_card/body.dart';
import 'package:jomla/view/products_card/loading_row.dart';
import 'package:jomla/view/products_card/product.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jomla/view/settings/settings_view.dart';

Widget ProductsColumn({required productsList, required context}) {
  final screenWidth = MediaQuery.of(context).size.width;

  return FutureBuilder<List<Product>>(
    future: productsList,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        List<Product> products = snapshot.data!;
        const cardWidth = 160; // Width of each ProductCard widget
        const spacingWidth = 10.0; // Space between each ProductCard widget
        final availableWidth = screenWidth -
            spacingWidth; // Width available for ProductCard widgets after accounting for spacing
        final numOfCards = (availableWidth / cardWidth)
            .floor(); // Calculate number of ProductCard widgets that can fit in a row
        final numOfRows = (products.length / numOfCards)
            .ceil(); // Calculate number of rows needed to display all products

        return Column(
          children: [
            const SizedBox(height: 20),
            SizedBox(
              width: SizeConfig.screenWidth,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: numOfRows,
                itemBuilder: (context, rowIndex) {
                  final startIndex = rowIndex * numOfCards;
                  final endIndex = startIndex + numOfCards;
                  final rowProducts = products.sublist(startIndex,
                      endIndex > products.length ? products.length : endIndex);

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: spacingWidth,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: rowProducts.map((product) {
                        return ProductCard(
                          product: product,
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      } else {
        return UserProductsLoading();
      }
    },
  );
}

class Service {
  final String name;
  final String description;
  final String imageUrl;
  final servicePage;
  bool isExpanded;

  Service({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.servicePage,
    this.isExpanded = false,
  });
}

class ProductRows extends StatefulWidget {
  final getProducts;
  final String? title;
  const ProductRows(
      {super.key, required this.getProducts, required this.title});

  @override
  State<ProductRows> createState() => _ProductRowsState();
}

class _ProductRowsState extends State<ProductRows> {
  final ScrollController _scrollController = ScrollController();
  bool _showBackIcon = false;
  bool _showForwardIcon = true;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      // Step 2: Update the _showBackIcon variable based on the scroll offset
      setState(() {
        _showBackIcon = _scrollController.offset > 0;
        _showForwardIcon = _scrollController.position.extentAfter > 0;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        children: [
          widget.title != null
              ? Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SectionTitle(title: widget.title!, press: () {}),
                    ),
                    const SizedBox(height: 10),
                  ],
                )
              : SizedBox.shrink(),
          FutureBuilder<List<Product>>(
            future: widget.getProducts,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingRow();
              } else if (snapshot.hasData) {
                List<Product> products = snapshot.data!;
                if (products.isNotEmpty) {
                  return Stack(
                    children: [
                      ShaderMask(
                        shaderCallback: (Rect rect) {
                          if (!_showBackIcon) {
                            return const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.black,
                                Colors.transparent,
                              ],
                              stops: [0.9, 1],
                            ).createShader(rect);
                          } else if (!_showForwardIcon) {
                            return const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.transparent,
                                Colors.black,
                              ],
                              stops: [0.0, 0.1],
                            ).createShader(rect);
                          } else {
                            return const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.transparent,
                                Colors.black,
                                Colors.black,
                                Colors.transparent
                              ],
                              stops: [0.0, 0.05, 0.95, 1.0],
                            ).createShader(rect);
                          }
                        },
                        blendMode: BlendMode.dstIn,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ...List.generate(
                                products.length,
                                (index) {
                                  return Padding(
                                      padding: const EdgeInsets.only(right: 7),
                                      child: ProductCard(
                                        product: products[index],
                                      ));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (kIsWeb && _showBackIcon)
                        Positioned(
                          top: 70,
                          left: 5,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  offset: Offset(0, 1),
                                  blurRadius: 10,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: IconButton(
                              onPressed: () {
                                _scrollController.animateTo(
                                  _scrollController.offset - 140,
                                  curve: Curves.linear,
                                  duration: const Duration(milliseconds: 200),
                                );
                              },
                              icon: Icon(
                                Icons.arrow_back_ios_new_sharp,
                                size: 20.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      if (kIsWeb && _showForwardIcon)
                        Positioned(
                          top: 70,
                          right: 5,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  offset: Offset(0, 1),
                                  blurRadius: 10,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: IconButton(
                              onPressed: () {
                                _scrollController.animateTo(
                                  _scrollController.offset + 140,
                                  curve: Curves.linear,
                                  duration: const Duration(milliseconds: 200),
                                );
                              },
                              icon: Icon(
                                Icons.arrow_forward_ios_sharp,
                                size: 20.0,
                                color: Colors.white,
                              ),
                            ),
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
            },
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBackButtonPressed;
  final String ref;

  const CustomAppBar({
    Key? key,
    required this.onBackButtonPressed,
    required this.ref,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 5,
      shadowColor: Color.fromARGB(255, 169, 231, 205),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 91, 199, 245),
              Color.fromARGB(
                  255, 169, 231, 205), // Start color (your blue color)
              // End color (lighter color)
            ],
            begin: Alignment
                .centerLeft, // You can adjust the gradient's start point
            end: Alignment
                .centerRight, // You can adjust the gradient's end point
          ),
        ),
      ),
      title: Text('Product details'),
      actions: [
        IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () {},
          iconSize: 22,
        ),
      ],
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_sharp),
        onPressed: onBackButtonPressed,
      ),
    );
  }

  @override
  final Size preferredSize = const Size.fromHeight(45);
}

class CustomAppBarSubPages extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback? onBackButtonPressed;
  final String title;

  const CustomAppBarSubPages({
    Key? key,
    required this.onBackButtonPressed,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 5,
      shadowColor: Color.fromARGB(255, 169, 231, 205),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 91, 199, 245),
              Color.fromARGB(
                  255, 169, 231, 205), // Start color (your blue color)
              // End color (lighter color)
            ],
            begin: Alignment
                .centerLeft, // You can adjust the gradient's start point
            end: Alignment
                .centerRight, // You can adjust the gradient's end point
          ),
        ),
      ),
      title: Text(title),
      leading: onBackButtonPressed != null
          ? IconButton(
              icon: Icon(Icons.arrow_back_ios_new_sharp),
              onPressed: onBackButtonPressed,
            )
          : null,
    );
  }

  @override
  final Size preferredSize = const Size.fromHeight(45);
}

class ProfileAppbar extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback? onBackButtonPressed;
  final String? uid;

  ProfileAppbar({
    Key? key,
    required this.onBackButtonPressed,
    required this.uid,
  }) : super(key: key);

  @override
  State<ProfileAppbar> createState() => _ProfileAppbarState();

  @override
  final Size preferredSize = const Size.fromHeight(45);
}

class _ProfileAppbarState extends State<ProfileAppbar> {
  String? currentuid;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (AuthService.firebase().currentUser != null) {
      currentuid = AuthService.firebase().currentUser!.uid;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      bottomOpacity: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 91, 199, 245),
              Color.fromARGB(
                  255, 169, 231, 205), // Start color (your blue color)
              // End color (lighter color)
            ],
            begin: Alignment
                .centerLeft, // You can adjust the gradient's start point
            end: Alignment
                .centerRight, // You can adjust the gradient's end point
          ),
        ),
      ),
      title: Text('Profile'),
      actions: [
        if (widget.uid != null)
          if (widget.uid == currentuid)
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SettingsView(),
                ));
              },
              iconSize: 22,
            )
          else
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {},
              iconSize: 22,
            )
      ],
      leading: widget.onBackButtonPressed != null
          ? IconButton(
              icon: Icon(Icons.arrow_back_ios_new_sharp),
              onPressed: widget.onBackButtonPressed,
            )
          : null,
    );
  }
}

class DonthaveProducts extends StatelessWidget {
  const DonthaveProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        AppLocalizations.of(context)!.youdonthaveproducts,
        style: const TextStyle(
          fontSize: 24,
          color: Colors.grey,
        ),
      ),
    );
  }
}

class LoginDialog extends StatelessWidget {
  final bool guest;
  const LoginDialog({Key? key, required this.guest}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Welcome!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Please login to have the full experience.',
            style: TextStyle(fontSize: 17, color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              GoRouter.of(context).go('/profile');
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Text('Log In'),
            ),
          ),
          const SizedBox(height: 12),
          if (guest)
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Text('Continue as Guest'),
              ),
            ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    Key? key,
    required this.title,
    required this.press,
  }) : super(key: key);

  final String title;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            AppLocalizations.of(context)!.seemore,
            style: const TextStyle(color: Color(0xFFBBBBBB)),
          ),
        ),
      ],
    );
  }
}

Future<bool> showLogoutDialog(BuildContext context) {
  //showdialog is a widgit that has context and builder
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('LOG OUT!'),
        content: const Text('sure'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('cancel')),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('log out')),
        ],
      );
    },
  ).then((value) => value ?? false);
}

Widget floatingAddButton(BuildContext context) {
  return FloatingActionButton(
    backgroundColor: Color.fromARGB(255, 17, 176, 216),
    onPressed: () {
      _showFloatingButtonModal(context);
    },
    child: Icon(
      Icons.add,
      color: Colors.white,
    ),
  );
}

Widget _buildBottomSheet(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 17, 176, 216),
          onPressed: () {
            // Handle action for the second additional button
          },
          child: Icon(Icons.edit),
        ),
        SizedBox(height: 20), // Spacer
        FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 17, 176, 216),
          onPressed: () {
            GoRouter.of(context).pushNamed(RoutsConst.addRout);
          },
          child: Icon(Icons.add),
        ),
      ],
    ),
  );
}

Future<void> _showFloatingButtonModal(BuildContext context) async {
  await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: _buildBottomSheet,
  );
}
