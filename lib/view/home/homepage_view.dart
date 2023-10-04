import 'package:jomla/services/auth/auth_service.dart';
import 'package:jomla/services/providers.dart';
import 'package:jomla/utilities/reusable.dart';
import 'package:jomla/view/components/appbar.dart';
import 'package:jomla/view/components/drawer.dart';
import 'package:provider/provider.dart';

import '../../size_config.dart';
import 'components/body.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    Key? key,
  }) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void opendrawer() {
    _scaffoldKey.currentState!.openDrawer();
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
    SizeConfig().init(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: Appbar(
        onTapDrawer: opendrawer,
      ),
      drawer: CostumNavigationDrawer(),
      body: Body(),
      floatingActionButton:
          AuthService.firebase().currentUser != null && usertype == 'market'
              ? floatingAddButton(context)
              : null,
    );
  }
}
