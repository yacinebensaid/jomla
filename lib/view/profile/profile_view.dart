// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:jomla/services/auth/auth_service.dart';
import 'package:jomla/services/crud/userdata_service.dart';
import 'package:jomla/services/providers.dart';
import 'package:jomla/utilities/page_not_found.dart';
import 'package:jomla/utilities/reusable.dart';

import 'package:provider/provider.dart';

import 'components/body.dart';
import 'components/normal_user.dart/body_normal_user.dart';

class ProfileScreen extends StatefulWidget {
  final bool fromNav;
  final String? uid;
  final UserData? passed_userdata;
  const ProfileScreen({
    Key? key,
    required this.fromNav,
    required this.uid,
    this.passed_userdata,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin<ProfileScreen> {
  @override
  bool get wantKeepAlive => true;
  Widget body() {
    if (widget.uid != null) {
      if (AuthService.firebase().currentUser != null) {
        if (widget.uid == AuthService.firebase().currentUser!.uid) {
          bool isNormal =
              Provider.of<UserDataInitializer>(context, listen: false)
                      .getUserData!
                      .user_type ==
                  'normal';
          if (isNormal) {
            return NormalBody(
              fromNav: widget.fromNav,
              userdata: Provider.of<UserDataInitializer>(context).getUserData!,
            );
          } else {
            return Body(
              userdata: Provider.of<UserDataInitializer>(context).getUserData!,
            );
          }
        } else {
          return StreamBuilder(
            stream: DataService.getUserDataStream(widget.uid!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                UserData? userdata = snapshot.data;
                if (userdata != null) {
                  bool isNormal = userdata.user_type == 'normal';
                  if (isNormal) {
                    return NormalBody(
                      fromNav: widget.fromNav,
                      userdata: userdata,
                    );
                  } else {
                    return Body(
                      userdata: userdata,
                    );
                  }
                } else {
                  return PageNotFound();
                }
              } else {
                return PageNotFound();
              }
            },
          );
        }
      } else {
        return StreamBuilder(
          stream: DataService.getUserDataStream(widget.uid!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              UserData? userdata = snapshot.data;
              if (userdata != null) {
                bool isNormal = userdata.user_type == 'normal';
                if (isNormal) {
                  return NormalBody(
                    fromNav: widget.fromNav,
                    userdata: userdata,
                  );
                } else {
                  return Body(
                    userdata: userdata,
                  );
                }
              } else {
                return PageNotFound();
              }
            } else {
              return PageNotFound();
            }
          },
        );
      }
    } else {
      if (widget.passed_userdata != null) {
        bool isNormal = widget.passed_userdata!.user_type == 'normal';
        if (isNormal) {
          return NormalBody(
            fromNav: widget.fromNav,
            userdata: widget.passed_userdata!,
          );
        } else {
          return Body(
            userdata: widget.passed_userdata!,
          );
        }
      } else {
        if (AuthService.firebase().currentUser != null) {
          bool isNormal =
              Provider.of<UserDataInitializer>(context, listen: false)
                      .getUserData!
                      .user_type ==
                  'normal';
          if (isNormal) {
            return NormalBody(
              fromNav: widget.fromNav,
              userdata: Provider.of<UserDataInitializer>(context).getUserData!,
            );
          } else {
            return Body(
              userdata: Provider.of<UserDataInitializer>(context).getUserData!,
            );
          }
        } else {
          return PageNotFound();
        }
      }
    }
  }

  String usertype = 'normal';
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    usertype = Provider.of<UserDataInitializer>(context).getUserData != null
        ? Provider.of<UserDataInitializer>(context).getUserData!.user_type
        : 'normal';
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: ProfileAppbar(
          onBackButtonPressed:
              widget.fromNav ? null : () => Navigator.of(context).pop(),
          uid: widget.uid != null
              ? widget.uid
              : widget.passed_userdata != null
                  ? widget.passed_userdata!.id
                  : null),
      body: body(),
      floatingActionButton:
          AuthService.firebase().currentUser != null && usertype == 'market'
              ? floatingAddButton(context)
              : null,
    );
  }
}
