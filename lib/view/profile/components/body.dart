import 'package:flutter/material.dart';
import 'package:jomla/services/crud/userdata_service.dart';
import 'user_infos.dart';
import 'user_products.dart';

class Body extends StatefulWidget {
  final bool fromNav;

  final UserData userdata;

  const Body({
    Key? key,
    required this.fromNav,
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
          Container(
              color: const Color.fromARGB(255, 240, 240, 240),
              child: UserInfos(
                fromNav: widget.fromNav,
                userdata: widget.userdata,
              )),
          Container(
            color: Color(0xFFF5F6F9),
            child: UserProducts(
              uid: widget.userdata.id,
            ),
          )
        ],
      ),
    );
  }
}
