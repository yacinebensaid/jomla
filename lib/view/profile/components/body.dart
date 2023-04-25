import 'package:flutter/material.dart';
import 'package:jomla/size_config.dart';
import 'user_infos.dart';
import 'user_products.dart';

class Body extends StatefulWidget {
  final String uid;

  Body({Key? key, required this.uid}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                  color: const Color.fromARGB(255, 240, 240, 240),
                  height: getProportionateScreenHeight(300),
                  child: UserInfos(
                    uid: widget.uid,
                  )),
              UserProducts(
                uid: widget.uid,
              )
            ],
          ),
        ),
      ),
    );
  }
}
