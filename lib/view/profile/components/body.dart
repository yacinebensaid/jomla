import 'package:flutter/material.dart';
import 'package:jomla/services/crud/userdata_service.dart';
import 'user_infos.dart';
import 'user_products.dart';

class Body extends StatefulWidget {
  final UserData userdata;

  const Body({
    Key? key,
    required this.userdata,
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          UserInfos(
            userdata: widget.userdata,
          ),
          Container(
            color: Color.fromARGB(255, 255, 255, 255),
            child: UserProducts(
              uid: widget.userdata.id!,
            ),
          )
        ],
      ),
    );
  }
}
