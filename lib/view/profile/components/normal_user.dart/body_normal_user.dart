import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jomla/services/crud/userdata_service.dart';

import 'normal_user_infos.dart';
import 'under_infos.dart';

class NormalBody extends StatefulWidget {
  final bool fromNav;
  final UserData userdata;

  const NormalBody({
    Key? key,
    required this.fromNav,
    required this.userdata,
  }) : super(key: key);

  @override
  State<NormalBody> createState() => _BodyState();
}

class _BodyState extends State<NormalBody> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
              color: Color.fromARGB(255, 255, 255, 255),
              child: NormalUserInfos(
                fromNav: widget.fromNav,
                userdata: widget.userdata,
              )),
          Divider(
            color: Colors.grey,
            thickness: 0.2.h,
          ),
          Container(
            color: Color.fromARGB(255, 255, 255, 255),
            child: UnderInfos(),
          )
        ],
      ),
    );
  }
}
