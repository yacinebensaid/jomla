// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'dropship_settings/dropship_settings.dart';
import 'general_settings.dart';
import 'security_settings.dart';

class SettingsView extends StatefulWidget {
  String name;
  String userType;
  String? description;
  String? dropshipID;
  String? image;
  String phoneNumber;
  SettingsView({
    Key? key,
    required this.name,
    required this.image,
    required this.dropshipID,
    required this.userType,
    required this.description,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        shadowColor: Colors.transparent.withOpacity(0),
        backgroundColor: Colors.transparent.withOpacity(0),
        title: Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: ((context) {
                  return GeneralSettings(
                    image: widget.image,
                    userType: widget.userType,
                    description: widget.description,
                    name: widget.name,
                    phoneNumber: widget.phoneNumber,
                  );
                })));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'General Settings',
                    style:
                        TextStyle(fontSize: 19.w, fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                  )
                ],
              ),
            ),
            widget.userType == 'dropshipper'
                ? Column(
                    children: [
                      Divider(
                        thickness: 0.75.h,
                        height: 30.h,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: ((context) => DropshipSettings(
                                    dropshipID: widget.dropshipID!,
                                  ))));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Dropship Settings',
                              style: TextStyle(
                                  fontSize: 19.w, fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                : SizedBox.shrink(),
            Divider(
              thickness: 0.75.h,
              height: 30.h,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: ((context) => ChangePasswordPage())));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Security Settings',
                    style:
                        TextStyle(fontSize: 19.w, fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}


/*, */