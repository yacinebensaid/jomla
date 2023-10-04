import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:jomla/constants/const_routs.dart';
import 'package:jomla/services/providers.dart';

import 'package:provider/provider.dart';
import '../../../constants/constants.dart';
import '../../product_datails/components/default_btn.dart';

class CheckoutCard extends StatefulWidget {
  final int checkedProducts;

  const CheckoutCard({
    Key? key,
    required this.checkedProducts,
  }) : super(key: key);

  @override
  State<CheckoutCard> createState() => _CheckoutCardState();
}

class _CheckoutCardState extends State<CheckoutCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 20, top: 10, left: 10, right: 10),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                height: 30,
                width: 30,
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
            height: 20.h,
          ),
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  flex: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: 'Selected: ',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                              fontSize: 16),
                          children: [
                            TextSpan(
                                text: "${widget.checkedProducts}",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey[800])),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text.rich(
                        TextSpan(
                          text: 'Total: ',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                              fontSize: 16),
                          children: [
                            TextSpan(
                                text:
                                    '${Provider.of<CheckedCartProducts>(context, listen: false).getTotalPrice}',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey[800])),
                            TextSpan(
                                text: ' da',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.grey[600])),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Expanded(
                  flex: 8,
                  child: DefaultButton(
                    text: AppLocalizations.of(context)!.checkout,
                    press: () {
                      GoRouter.of(context).pushNamed(RoutsConst.deliverRout);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
