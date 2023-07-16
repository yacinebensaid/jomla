// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jomla/services/auth/auth_service.dart';
import 'package:jomla/services/crud/userdata_service.dart';
import 'package:jomla/services/providers.dart';
import 'package:jomla/utilities/page_not_found.dart';
import 'package:jomla/view/auth/login/index.dart';
import 'package:provider/provider.dart';

import 'components/body.dart';
import 'components/normal_user.dart/body_normal_user.dart';

class ProfileScreen extends StatefulWidget {
  bool fromNav;
  String? uid;
  ProfileScreen({
    Key? key,
    required this.fromNav,
    required this.uid,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin<ProfileScreen> {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
        child: Scaffold(
            body: AuthService.firebase().currentUser != null
                ? widget.uid == AuthService.firebase().currentUser!.uid
                    ? Provider.of<UserDataInitializer>(context, listen: false)
                                .getUserType ==
                            'normal'
                        ? NormalBody(
                            fromNav: widget.fromNav,
                            userdata: Provider.of<UserDataInitializer>(context,
                                    listen: false)
                                .getUserData!,
                          )
                        : Body(
                            fromNav: widget.fromNav,
                            userdata: Provider.of<UserDataInitializer>(context,
                                    listen: false)
                                .getUserData!,
                          )
                    : StreamBuilder(
                        stream: DataService.getUserDataStream(widget.uid!),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            UserData? userdata = snapshot.data;
                            if (userdata != null) {
                              return userdata.user_type == 'normal'
                                  ? NormalBody(
                                      fromNav: widget.fromNav,
                                      userdata: userdata,
                                    )
                                  : Body(
                                      fromNav: widget.fromNav,
                                      userdata: userdata,
                                    );
                            } else {
                              return PageNotFound();
                            }
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        },
                      )
                : LoginScreen()));
  }
}
