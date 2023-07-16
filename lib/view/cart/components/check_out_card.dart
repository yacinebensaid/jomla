import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jomla/services/crud/pcf_service.dart';
import 'package:jomla/services/providers.dart';
import 'package:jomla/view/dropshipping/dropshiper_pay.dart';
import 'package:jomla/view/dropshipping/dropship_view.dart';
import 'package:jomla/view/products_shipping_service/shipping_service_view.dart';
import 'package:jomla/view/services/components/services.dart';
import 'package:provider/provider.dart';
import '../../../constants/constants.dart';
import '../../product_datails/components/default_btn.dart';

class CheckoutCard extends StatefulWidget {
  final Map<String, CartProduct> checkedProducts;
  CheckoutCard({
    Key? key,
    required this.checkedProducts,
  }) : super(key: key);

  @override
  State<CheckoutCard> createState() => _CheckoutCardState();
}

class _CheckoutCardState extends State<CheckoutCard> {
  List<Service> services = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Provider.of<UserDataInitializer>(context, listen: false).getUserType ==
            'market'
        ? services = [
            Service(
              servicePage: ShippingServicePage(),
              name: 'Products\nShipping',
              description: 'Service description',
              imageUrl: 'assets/images/services/shipping_serv.jpeg',
            ),
          ]
        : Provider.of<UserDataInitializer>(context, listen: false)
                    .getUserType ==
                'dropshipper'
            ? services = [
                Service(
                  servicePage: ShippingServicePage(),
                  name: 'Products\nShipping',
                  description: 'Service description',
                  imageUrl: 'assets/images/services/shipping_serv.jpeg',
                ),
                Service(
                  servicePage: DropshiperPay(),
                  name: 'Dropship\nService',
                  description: 'Service description',
                  imageUrl: 'assets/images/services/shipping.jpeg',
                )
              ]
            : services = [
                Service(
                  servicePage: ShippingServicePage(),
                  name: 'Products\nShipping',
                  description: 'Service description',
                  imageUrl: 'assets/images/services/shipping_serv.jpeg',
                ),
                Service(
                  servicePage: Dropship(),
                  name: 'Dropship\nService',
                  description: 'Service description',
                  imageUrl: 'assets/images/services/shipping.jpeg',
                )
              ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        // height: 174,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, -15),
              blurRadius: 20,
              color: const Color(0xFFDADADA).withOpacity(0.15),
            )
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(5.w),
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F6F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SvgPicture.asset("assets/icons/receipt.svg"),
                  ),
                  const Spacer(),
                  Text(AppLocalizations.of(context)!.addvouchercode),
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: kTextColor,
                  )
                ],
              ),
              SizedBox(
                height: 5.h,
              ),
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                        flex: 3,
                        child: Text.rich(
                          TextSpan(
                            text: 'Selected: ',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                                fontSize: 17.w),
                            children: [
                              TextSpan(
                                  text:
                                      "${Provider.of<CheckedCartProducts>(context, listen: false).getChackeMap.length}",
                                  style: TextStyle(
                                      fontSize: 17.w, color: Colors.grey[800])),
                            ],
                          ),
                        )),
                    Expanded(
                      flex: 4,
                      child: Text.rich(
                        TextSpan(
                          text: 'Total: ',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                              fontSize: 17.w),
                          children: [
                            TextSpan(
                                text:
                                    '${Provider.of<CheckedCartProducts>(context, listen: false).getTotalPrice}',
                                style: TextStyle(
                                    fontSize: 17.w, color: Colors.grey[800])),
                            TextSpan(
                                text: ' da',
                                style: TextStyle(
                                    fontSize: 15.w, color: Colors.grey[600])),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: DefaultButton(
                        text: AppLocalizations.of(context)!.checkout,
                        press: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: SizedBox(
                                  height: Provider.of<UserDataInitializer>(
                                                  context,
                                                  listen: false)
                                              .getUserType ==
                                          'market'
                                      ? 220
                                      : 380,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Column(
                                        children: List.generate(services.length,
                                            (index) {
                                          final service = services[index];
                                          return Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  final internetConnectionStatus =
                                                      Provider.of<
                                                              InternetConnectionStatus>(
                                                          context,
                                                          listen: false);
                                                  if (internetConnectionStatus ==
                                                      InternetConnectionStatus
                                                          .connected) {
                                                    Navigator.of(context).pop();
                                                    UserPCFService
                                                        .moveItemsToPending();
                                                    /*
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: ((context) =>
                                                              service
                                                                  .servicePage)));*/
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      content: Text(
                                                          'you are not connected'),
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                    ));
                                                  }
                                                },
                                                child: Card(
                                                  margin: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Expanded(
                                                        flex: 5,
                                                        child: Container(
                                                          height: 150,
                                                          decoration:
                                                              BoxDecoration(
                                                            image:
                                                                DecorationImage(
                                                              image: AssetImage(
                                                                  service
                                                                      .imageUrl),
                                                              fit: BoxFit.cover,
                                                            ),
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(20),
                                                              bottomLeft: Radius
                                                                  .circular(20),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 6,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      20,
                                                                  vertical: 10),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                service.name,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              Text(
                                                                service
                                                                    .description,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              'cancel',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
