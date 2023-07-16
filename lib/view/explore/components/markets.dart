// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:jomla/services/crud/userdata_service.dart';
import 'package:jomla/view/profile/profile_view.dart';

import 'markets_loading.dart';

class MarketsRow extends StatefulWidget {
  MarketsRow({
    Key? key,
  }) : super(key: key);

  @override
  State<MarketsRow> createState() => _MarketsRowState();
}

class _MarketsRowState extends State<MarketsRow> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DataService.getMarketData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // Extract the market data from the snapshot
          final marketData = snapshot.data as List<UserData>;

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 15.w, left: 15.w),
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
              Padding(
                padding: EdgeInsets.only(right: 15.w),
                child: SizedBox(
                  height: 130.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: marketData.length,
                    itemBuilder: (context, index) {
                      final UserData market = marketData[index];
                      return Padding(
                        padding: const EdgeInsets.only(left: 18),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: ((context) => ProfileScreen(
                                      fromNav: false,
                                      uid: market.id,
                                    ))));
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              market.picture == null
                                  ? CircleAvatar(
                                      radius: 50.w,
                                      backgroundColor: Colors.grey,
                                      child: Icon(
                                        CupertinoIcons.person,
                                        color: Colors.white,
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 50.w,
                                      backgroundColor: Colors.grey,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(60),
                                        child: Center(
                                          child: Image.network(
                                            market.picture!,
                                            fit: BoxFit.cover,
                                            width: 100.w,
                                            height: 100.h,
                                          ),
                                        ),
                                      ),
                                    ),
                              SizedBox(height: 8.h),
                              Text(
                                market.name,
                                style: TextStyle(
                                    fontSize: 17.h,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        } else {
          return const LoadingMarketsRow();
        }
      },
    );
  }
}
