// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:jomla/constants/constants.dart';
import 'package:jomla/services/providers.dart';
import 'package:jomla/size_config.dart';
import 'package:jomla/view/dropshipping/dropshiper_pay.dart';
import 'package:provider/provider.dart';

import 'start_dropship.dart';

class NotDropshiper extends StatefulWidget {
  NotDropshiper({
    Key? key,
  }) : super(key: key);

  @override
  State<NotDropshiper> createState() => _NotDropshiperState();
}

class _NotDropshiperState extends State<NotDropshiper> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 200,
          ),
          startButton(context),
          const SizedBox(height: 50),
          Text(
            'What is dropshipping?',
            style: TextStyle(
              fontSize: getProportionateScreenWidth(20),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              '   Dropshipping is a retail fulfillment method where a store doesn\'t keep the products it sells in stock. Instead, when a store sells a product, it purchases the item from a third party and has it shipped directly to the customer. As a result, the merchant never sees or handles the product.',
              style: TextStyle(
                fontSize: getProportionateScreenWidth(18),
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 30),
          startButton(context),
          const SizedBox(height: 30),
          Text(
            'What you will get if you start:',
            style: TextStyle(
              fontSize: getProportionateScreenWidth(20),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              '1. Access to a wide range of products.\n2. No need to manage inventory.\n3. Ability to run your business from anywhere.\n4. Low startup costs.\n5. Flexible work hours.\n6. Potential for high profits.',
              style: TextStyle(
                fontSize: getProportionateScreenWidth(18),
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 30),
          startButton(context),
        ],
      ),
    );
  }
}

Widget startButton(BuildContext context) {
  return SizedBox(
    width: 270,
    height: getProportionateScreenHeight(56),
    child: TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        foregroundColor: kPrimaryColor,
        backgroundColor: kPrimaryColor,
      ),
      onPressed: (() {
        if (Provider.of<UserDataInitializer>(context, listen: false)
                .getUserType !=
            null) {
          if (Provider.of<UserDataInitializer>(context, listen: false)
                  .getUserType !=
              'market') {
            Navigator.of(context).pop();
            if (Provider.of<UserDataInitializer>(context, listen: false)
                    .getUserType !=
                'dropshipper') {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: ((context) => StratDropship())));
            } else {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: ((context) => DropshiperPay())));
            }
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  content: Text(
                    "Markets are not able to do Dropshipping.",
                    style: TextStyle(fontSize: 18.w),
                  ),
                  actions: [
                    TextButton(
                      child: Text(
                        "Ok",
                        style: TextStyle(fontSize: 16.w),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
        }
      }),
      child: Text(
        'Be Dropshipper!',
        style: TextStyle(
          fontSize: getProportionateScreenWidth(18),
          color: Colors.white,
        ),
      ),
    ),
  );
}
