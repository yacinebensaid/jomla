import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jomla/services/crud/product_service.dart';
import 'package:jomla/services/crud/userdata_service.dart';
import 'package:jomla/services/providers.dart';
import 'package:jomla/view/product_datails/details_view.dart';
import 'package:jomla/view/products_card/body.dart';
import 'package:jomla/view/products_card/product.dart';
import 'package:jomla/view/profile/profile_view.dart';
import 'package:provider/provider.dart';

class FollowingProducts extends StatefulWidget {
  const FollowingProducts({super.key});

  @override
  State<FollowingProducts> createState() => _FollowingProductsState();
}

class _FollowingProductsState extends State<FollowingProducts> {
  String? image;
  String name = '';
  void retrieveDropShip(String Id) async {
    DropshipperData? dropshipperData =
        await DataService.getDropshipperData(Id).first;
    if (dropshipperData != null) {
      image = dropshipperData.picture;
      name = dropshipperData.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: Provider.of<UserDataInitializer>(context, listen: false)
            .getFollowing
            .length,
        itemBuilder: ((context, index) {
          Stream<UserData?> userData = DataService.getUserDataStream(
              Provider.of<UserDataInitializer>(context, listen: false)
                  .getFollowing[index]);

          return StreamBuilder(
            stream: userData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                UserData? _userData = snapshot.data;
                if (_userData != null) {
                  if (_userData.user_type == 'market' ||
                      _userData.user_type == 'dropshipper') {
                    Future<List<Product>> products =
                        ProductService.searchProductByUser(
                            Provider.of<UserDataInitializer>(context,
                                    listen: false)
                                .getFollowing[index]);
                    return FutureBuilder(
                        future: products,
                        builder: ((context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasData) {
                            List<Product>? productlist = snapshot.data;
                            if (_userData.user_type == 'dropshipper') {
                              retrieveDropShip(_userData.id);
                            } else {
                              image = _userData.picture;
                              name = _userData.name;
                            }
                            if (productlist != null && productlist.isNotEmpty) {
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: ((context) =>
                                                  ProfileScreen(
                                                    fromNav: false,
                                                    uid: Provider.of<
                                                                UserDataInitializer>(
                                                            context,
                                                            listen: false)
                                                        .getFollowing[index],
                                                  ))));
                                    },
                                    child: Container(
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                          Row(
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
                                              SizedBox(width: 14.w),
                                              Text(
                                                name,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ])),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  ///////////////////////////////////////////////////////////////////////////////////
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        ...List.generate(
                                          productlist.length,
                                          (index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 7),
                                              child: ProductCard(
                                                product: productlist[index],
                                              ),
                                            );
                                          },
                                        ),
                                      ],
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
                        }));
                  } else {
                    return SizedBox.shrink();
                  }
                } else {
                  return SizedBox.shrink();
                }
              } else {
                return SizedBox.shrink();
              }
            },
          );
        }),
      ),
    );
  }
}
