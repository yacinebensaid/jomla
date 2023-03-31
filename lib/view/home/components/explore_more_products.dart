import 'package:flutter/material.dart';
import 'package:jomla/constants/constants.dart';
import 'package:jomla/size_config.dart';

class ExploreMoreProducts extends StatelessWidget {
  const ExploreMoreProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: kPrimaryColor,
        height: getProportionateScreenHeight(200),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Text(
                  'Explore More\nProducts',
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(18),
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Container(
                  height: 50,
                  width: 150,
                  child: ElevatedButton(
                    onPressed: (() {}),
                    child: Text('Explore =>'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
