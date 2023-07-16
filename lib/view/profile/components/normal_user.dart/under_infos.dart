// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:jomla/services/crud/userdata_service.dart';
import 'package:jomla/services/providers.dart';
import 'package:jomla/view/home/components/services.dart';
import 'package:jomla/view/product_datails/details_view.dart';
import 'package:jomla/view/products_card/product.dart';
import 'package:jomla/view/profile/components/normal_user.dart/mini_purchased_cards.dart';
import 'package:jomla/view/profile/profile_view.dart';
import 'package:jomla/view/purchased/components/purchased.dart';
import 'package:jomla/view/purchased/purchased_view.dart';
import 'package:provider/provider.dart';

class UnderInfos extends StatelessWidget {
  UnderInfos({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            SizedBox(height: 15.h),
            Container(
              width: 370.w,
              height: 150.h,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(13),
                border: Border.all(width: 0.5.w, color: Colors.grey),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.25),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(1, 3),
                  ),
                ],
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Products',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 19.w,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: ((context) => PurchasedScreen())));
                            },
                            child: Text(
                              'See all',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 16.w,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    FutureBuilder<List<PurchasedProduct>>(
                      future: populateDemoCarts(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasData) {
                          List<PurchasedProduct> products = snapshot.data!;
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children:
                                    List.generate(products.length, (index) {
                                  return Padding(
                                    padding: EdgeInsets.only(right: 8.w),
                                    child: GestureDetector(
                                      onTap: () async {
                                        Product _product =
                                            await getProductsByReference(
                                                products[index].reference);
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: ((context) => DetailsScreen(
                                                product: _product,
                                                ref: null,
                                              )),
                                        ));
                                      },
                                      child: MiniPurchasedCard(
                                        purchasedProd: products[index],
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          );
                        } else {
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
                      },
                    )
                  ]),
            ),
            SizedBox(height: 10.h), // Adds some spacing between the containers
            Container(
                width: 370.w,
                height: 150.h,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(width: 0.5.w, color: Colors.grey),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.25),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: Offset(1, 3),
                    ),
                  ],
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Followings',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 19.w,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'See all',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 16.w,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Provider.of<UserDataInitializer>(context, listen: false)
                              .getFollowing
                              .isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: List.generate(
                                    Provider.of<UserDataInitializer>(context,
                                            listen: false)
                                        .getFollowing
                                        .length,
                                    (index) {
                                      return FutureBuilder(
                                        future: DataService.getUserDataForOrder(
                                            Provider.of<UserDataInitializer>(
                                                    context,
                                                    listen: false)
                                                .getFollowing[index]),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          } else if (snapshot.hasData) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: ((context) =>
                                                              ProfileScreen(
                                                                fromNav: false,
                                                                uid: snapshot
                                                                    .data!.id,
                                                              ))));
                                                },
                                                child: Column(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 30,
                                                      backgroundColor:
                                                          Colors.grey,
                                                      child: snapshot.data!
                                                                  .picture ==
                                                              null
                                                          ? Icon(
                                                              Icons.storefront,
                                                              color:
                                                                  Colors.white,
                                                            )
                                                          : ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          60),
                                                              child: Center(
                                                                child: Image
                                                                    .network(
                                                                  snapshot.data!
                                                                      .picture!,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  width: 60,
                                                                  height: 0,
                                                                ),
                                                              ),
                                                            ),
                                                    ),
                                                    SizedBox(
                                                      height: 5.h,
                                                    ),
                                                    Text(
                                                      snapshot.data!.name,
                                                      style: TextStyle(
                                                        fontSize: 14.w,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          } else {
                                            return Text(
                                                'Error retrieving user data');
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: Text(
                                'You do not follow anyone',
                                style: TextStyle(
                                  fontSize: 24.w,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                    ])),
            SizedBox(height: 10.h),
            Services()
          ],
        )
      ],
    );
  }
}
