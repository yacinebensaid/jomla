// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jomla/services/auth/auth_service.dart';

import 'package:jomla/services/crud/userdata_service.dart';
import 'package:jomla/view/profile/profile_view.dart';
import 'package:provider/provider.dart';

class Owner extends StatefulWidget {
  final VoidCallback goToProfile;

  List following;
  bool isAdmin;
  String uid;
  Owner({
    Key? key,
    required this.goToProfile,
    required this.following,
    required this.isAdmin,
    required this.uid,
  }) : super(key: key);

  @override
  State<Owner> createState() => _OwnerState();
}

class _OwnerState extends State<Owner> {
  late bool _isFollowing;
  String? currentUid = AuthService.firebase().currentUser?.uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isFollowing = widget.following.contains(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 65.h,
        padding: EdgeInsets.symmetric(horizontal: 10),
        width: MediaQuery.of(context).size.width * 0.93,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.grey[100],
            border: Border.all(
              color: Color.fromARGB(255, 218, 218, 218),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15), // Shadow color
                spreadRadius: 1.5, // Spread radius
                blurRadius: 5, // Blur radius
                offset: Offset(0, 0.5), // Offset in the x and y direction
              ),
            ]),
        child: StreamBuilder(
          stream: DataService.getUserDataStream(widget.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final fullname = snapshot.data!.name;
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => ProfileScreen(
                            goToProfile: widget.goToProfile,
                            userType: snapshot.data!.user_type,
                            fromNav: false,
                            uid: widget.uid,
                            following: widget.following,
                            isAdmin: widget.isAdmin,
                          ))));
                },
                child: Container(
                  height: 70.h,
                  width: MediaQuery.of(context).size.width * 0.93,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 20,
                            backgroundColor: Color.fromARGB(255, 105, 105, 105),
                            child: Icon(
                              CupertinoIcons.person,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Text(
                            fullname,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 19.w,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      currentUid != widget.uid
                          ? _isFollowing
                              ? ElevatedButton(
                                  onPressed: () {
                                    final internetConnectionStatus =
                                        Provider.of<InternetConnectionStatus>(
                                            context,
                                            listen: false);
                                    if (internetConnectionStatus ==
                                        InternetConnectionStatus.connected) {
                                      DataService followbuttoninst =
                                          DataService();
                                      followbuttoninst
                                          .unfollowFunction(widget.uid);
                                      setState(() {
                                        _isFollowing = false;
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text('you are not connected'),
                                        behavior: SnackBarBehavior.floating,
                                      ));
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        Colors.blueGrey, // Set the text color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10.0), // Set rounded corner radius
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 25.w,
                                        vertical: 7.h), // Set padding
                                    textStyle: TextStyle(
                                        fontSize: 18.w), // Set font size
                                  ),
                                  child: const Text('Following'),
                                )
                              : ElevatedButton(
                                  onPressed: () {
                                    final internetConnectionStatus =
                                        Provider.of<InternetConnectionStatus>(
                                            context,
                                            listen: false);
                                    if (internetConnectionStatus ==
                                        InternetConnectionStatus.connected) {
                                      DataService followbuttoninst =
                                          DataService();
                                      followbuttoninst
                                          .followFunction(widget.uid);
                                      setState(() {
                                        _isFollowing = true;
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text('you are not connected'),
                                        behavior: SnackBarBehavior.floating,
                                      ));
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10), // Set rounded corner radius
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 35.w,
                                        vertical: 7
                                            .h), // Increase padding to make the button larger
                                    textStyle: const TextStyle(
                                        fontSize: 18), // Increase font size
                                  ),
                                  child: const Text(
                                    'Follow',
                                  ),
                                )
                          : SizedBox.shrink()
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
