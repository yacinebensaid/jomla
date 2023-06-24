import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../size_config.dart';
import 'categories.dart';
import 'markets.dart';
import 'search_explore.dart';

class Body extends StatelessWidget {
  final VoidCallback goToProfile;
  List following;
  bool isAdmin;
  Body({
    Key? key,
    required this.isAdmin,
    required this.following,
    required this.goToProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          color: Color(0xFFF5F6F9),
          child: Column(
            children: [
              SizedBox(height: 5.h),
              SearchForExplore(
                goToProfile: goToProfile,
                following: following,
                isAdmin: isAdmin,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Markets',
                      style: TextStyle(
                          fontSize: 20.w,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                        onPressed: () {},
                        child: Text('See more',
                            style: TextStyle(
                              fontSize: 14.w,
                              color: Colors.grey,
                            )))
                  ],
                ),
              ),
              MarketsRow(
                goToProfile: goToProfile,
                following: following,
                isAdmin: isAdmin,
              ),
              SizedBox(height: 5.h),
              Categories(
                goToProfile: goToProfile,
                following: following,
                isAdmin: isAdmin,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
