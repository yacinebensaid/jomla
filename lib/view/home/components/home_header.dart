import 'package:flutter/material.dart';
import '../../../size_config.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF00235B),
      height: 60,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SizedBox(
                height: getProportionateScreenHeight(37),
                child: Image.asset(
                    'assets/images/jomla logo1 no-slogon croped.png',
                    fit: BoxFit.contain),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
