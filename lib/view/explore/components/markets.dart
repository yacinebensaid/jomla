// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:jomla/services/crud/userdata_service.dart';
import 'package:jomla/view/profile/profile_view.dart';

import 'markets_loading.dart';

class MarketsRow extends StatefulWidget {
  final VoidCallback goToProfile;
  List following;
  bool isAdmin;
  MarketsRow({
    Key? key,
    required this.isAdmin,
    required this.following,
    required this.goToProfile,
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

          return Padding(
            padding: const EdgeInsets.only(right: 18),
            child: SizedBox(
              height: 140.h,
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
                                  goToProfile: widget.goToProfile,
                                  userType: marketData[index].user_type,
                                  fromNav: false,
                                  following: widget.following,
                                  uid: market.id,
                                  isAdmin: widget.isAdmin,
                                ))));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          market.picture == null
                              ? const CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.grey,
                                  child: Icon(
                                    CupertinoIcons.person,
                                    color: Colors.white,
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.grey,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(60),
                                    child: Center(
                                      child: Image.network(
                                        market.picture!,
                                        fit: BoxFit.cover,
                                        width: 100,
                                        height: 100,
                                      ),
                                    ),
                                  ),
                                ),
                          const SizedBox(height: 8),
                          Text(
                            market.name,
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        } else {
          return const LoadingMarketsRow();
        }
      },
    );
  }
}
