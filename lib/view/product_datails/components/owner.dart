// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jomla/services/auth/auth_service.dart';

import 'package:jomla/services/crud/userdata_service.dart';
import 'package:jomla/services/providers.dart';
import 'package:jomla/utilities/reusable.dart';
import 'package:jomla/view/profile/profile_view.dart';
import 'package:provider/provider.dart';

class Owner extends StatefulWidget {
  final String uid;
  const Owner({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<Owner> createState() => _OwnerState();
}

class _OwnerState extends State<Owner> {
  late bool _isFollowing;
  late UserData userdata;
  String? currentUid = AuthService.firebase().currentUser?.uid;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isFollowing = Provider.of<UserDataInitializer>(context).getUserData != null
        ? Provider.of<UserDataInitializer>(context, listen: false)
            .getUserData!
            .following
            .contains(widget.uid)
        : false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 65,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        width: MediaQuery.of(context).size.width * 0.93,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.grey[100],
            border: Border.all(
              color: const Color.fromARGB(255, 218, 218, 218),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15), // Shadow color
                spreadRadius: 1.5, // Spread radius
                blurRadius: 5, // Blur radius
                offset: const Offset(0, 0.5), // Offset in the x and y direction
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
                            fromNav: false,
                            uid: widget.uid,
                          ))));
                },
                child: Container(
                  height: 70,
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
                          const SizedBox(width: 16),
                          Text(
                            fullname!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      currentUid != widget.uid
                          ? _isFollowing &&
                                  AuthService.firebase().currentUser != null
                              ? ElevatedButton(
                                  onPressed: () {
                                    final internetConnectionStatus =
                                        Provider.of<InternetConnectionStatus>(
                                            context,
                                            listen: false);
                                    if (internetConnectionStatus ==
                                        InternetConnectionStatus.connected) {
                                      setState(() {
                                        _isFollowing = false;
                                      });
                                      if (userdata.following
                                          .contains(widget.uid)) {
                                        DataService followbuttoninst =
                                            DataService();
                                        followbuttoninst
                                            .unfollowFunction(widget.uid);
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25,
                                        vertical: 7), // Set padding
                                    textStyle: const TextStyle(
                                        fontSize: 18), // Set font size
                                  ),
                                  child: const Text('Following'),
                                )
                              : ElevatedButton(
                                  onPressed: () {
                                    if (kIsWeb) {
                                      if (AuthService.firebase().currentUser !=
                                          null) {
                                        if (Provider.of<UserDataInitializer>(
                                                        context,
                                                        listen: false)
                                                    .getUserData !=
                                                null
                                            ? Provider.of<UserDataInitializer>(
                                                    context,
                                                    listen: false)
                                                .getUserData!
                                                .following
                                                .contains(widget.uid)
                                            : false) {
                                        } else {
                                          DataService followbuttoninst =
                                              DataService();
                                          followbuttoninst
                                              .followFunction(widget.uid);
                                        }
                                      } else {
                                        showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              return Dialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  child: const LoginDialog(
                                                    guest: true,
                                                  ));
                                            });
                                      }
                                    } else {
                                      final internetConnectionStatus =
                                          Provider.of<InternetConnectionStatus>(
                                              context,
                                              listen: false);
                                      if (internetConnectionStatus ==
                                          InternetConnectionStatus.connected) {
                                        setState(() {
                                          _isFollowing = true;
                                        });
                                        if (AuthService.firebase()
                                                .currentUser !=
                                            null) {
                                          if (Provider.of<UserDataInitializer>(
                                                          context,
                                                          listen: false)
                                                      .getUserData !=
                                                  null
                                              ? Provider.of<
                                                          UserDataInitializer>(
                                                      context,
                                                      listen: false)
                                                  .getUserData!
                                                  .following
                                                  .contains(widget.uid)
                                              : false) {
                                          } else {
                                            DataService followbuttoninst =
                                                DataService();
                                            followbuttoninst
                                                .followFunction(widget.uid);
                                          }
                                        } else {
                                          showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                return Dialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    child: const LoginDialog(
                                                      guest: true,
                                                    ));
                                              });
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content:
                                              Text('you are not connected'),
                                          behavior: SnackBarBehavior.floating,
                                        ));
                                      }
                                    }
                                    /////////////////////////////
                                    final internetConnectionStatus =
                                        Provider.of<InternetConnectionStatus>(
                                            context,
                                            listen: false);
                                    if (internetConnectionStatus ==
                                        InternetConnectionStatus.connected) {
                                      setState(() {
                                        _isFollowing = true;
                                      });
                                      if (userdata.following
                                          .contains(widget.uid)) {
                                      } else {
                                        DataService followbuttoninst =
                                            DataService();
                                        followbuttoninst
                                            .followFunction(widget.uid);
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 35,
                                        vertical:
                                            7), // Increase padding to make the button larger
                                    textStyle: const TextStyle(
                                        fontSize: 18), // Increase font size
                                  ),
                                  child: const Text(
                                    'Follow',
                                  ),
                                )
                          : const SizedBox.shrink()
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
