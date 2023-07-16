import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jomla/services/crud/userdata_service.dart';

class NormalUserInfos extends StatefulWidget {
  bool fromNav;
  UserData userdata;
  NormalUserInfos({
    super.key,
    required this.userdata,
    required this.fromNav,
  });

  @override
  State<NormalUserInfos> createState() => _UserInfosState();
}

class _UserInfosState extends State<NormalUserInfos> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SafeArea(
            child: SizedBox(
              height: !widget.fromNav ? kToolbarHeight : 30.h,
              child: !widget.fromNav
                  ? Row(
                      children: [
                        SizedBox(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  const Color.fromARGB(255, 240, 240, 240),
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: SvgPicture.asset(
                              "assets/icons/Back ICon.svg",
                              height: 15.h,
                            ),
                          ),
                        ),
                        const Spacer(),
                        dropDownMenu(context),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30.w,
                backgroundColor: Colors.grey,
                child: Icon(
                  CupertinoIcons.person,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 20.w,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Hi, ',
                    style: TextStyle(
                      color: Colors.grey[500], // sets text color to gray
                      fontWeight: FontWeight.bold, // sets font weight to normal
                      fontSize: 20.w,
                    ),
                  ),
                  Text(
                    '${widget.userdata.name}',
                    style: TextStyle(
                      fontSize: 20.w,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: ElevatedButton(
              onPressed: () async {},
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10), // Set rounded corner radius
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: 120.w,
                    vertical:
                        8.h), // Increase padding to make the button larger
                textStyle: TextStyle(fontSize: 18.w), // Increase font size
              ),
              child: const Text(
                'Settings',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dropDownMenu(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) async {},
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'signal',
          child: Text('Signal Profile'),
        ),
      ].toList(),
    );
  }
}
