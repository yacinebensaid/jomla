import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jomla/constants/const_routs.dart';
import 'package:jomla/services/crud/product_service.dart';
import 'package:jomla/services/crud/userdata_service.dart';
import 'package:jomla/services/providers.dart';
import 'package:jomla/utilities/reusable.dart';
import 'package:jomla/view/products_card/product.dart';
import 'package:provider/provider.dart';

class FollowingProducts extends StatefulWidget {
  const FollowingProducts({super.key});

  @override
  State<FollowingProducts> createState() => _FollowingProductsState();
}

class _FollowingProductsState extends State<FollowingProducts> {
  String? image;
  String name = '';
  void retrieveDropShip(String id) async {
    DropshipperData? dropshipperData =
        await DataService.getDropshipperData(id).first;
    if (dropshipperData != null) {
      image = dropshipperData.picture;
      name = dropshipperData.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: Provider.of<UserDataInitializer>(context, listen: false)
            .getUserData!
            .following
            .length,
        itemBuilder: ((context, index) {
          Stream<UserData?> userData = DataService.getUserDataStream(
              Provider.of<UserDataInitializer>(context, listen: false)
                  .getUserData!
                  .following[index]);

          return StreamBuilder(
            stream: userData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                UserData? userData0 = snapshot.data;
                if (userData0 != null) {
                  if (userData0.user_type == 'market' ||
                      userData0.user_type == 'dropshipper') {
                    if (userData0.user_type == 'dropshipper') {
                      DataService.getDropshipperData(userData0.dropshipperID!)
                          .listen((dropshipperData) {
                        if (dropshipperData != null) {
                          image = dropshipperData.picture;
                          name = dropshipperData.name;
                        }
                      });
                    } else {
                      image = userData0.picture;
                      name = userData0.name!;
                    }

                    Future<List<Product>> products =
                        ProductService.searchProductByUser(
                            Provider.of<UserDataInitializer>(context,
                                    listen: false)
                                .getUserData!
                                .following[index]);
                    return FutureBuilder(
                        future: products,
                        builder: ((context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasData) {
                            List<Product>? productlist = snapshot.data;

                            if (productlist != null && productlist.isNotEmpty) {
                              return Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: GestureDetector(
                                      onTap: () {
                                        GoRouter.of(context).pushNamed(
                                          RoutsConst.profileRout,
                                          extra: userData0,
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const CircleAvatar(
                                            radius: 17,
                                            backgroundColor: Color.fromARGB(
                                                255, 105, 105, 105),
                                            child: Icon(
                                              Icons.person,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(width: 14),
                                          Text(
                                            name,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ProductRows(
                                      getProducts: products, title: null)
                                  ///////////////////////////////////////////////////////////////////////////////////
                                ],
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          } else {
                            return const SizedBox.shrink();
                          }
                        }));
                  } else {
                    return const SizedBox.shrink();
                  }
                } else {
                  return const SizedBox.shrink();
                }
              } else {
                return const SizedBox.shrink();
              }
            },
          );
        }),
      ),
    );
  }
}
