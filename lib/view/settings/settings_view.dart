// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:jomla/services/auth/auth_service.dart';

import 'package:jomla/services/providers.dart';
import 'package:jomla/utilities/reusable.dart';
import 'package:provider/provider.dart';
import 'components/body.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({
    Key? key,
  }) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataInitializer>(
        builder: (context, userDataInitializer, _) {
      return Scaffold(
        appBar: CustomAppBarSubPages(
          onBackButtonPressed: () => Navigator.of(context).pop(),
          title: 'Settings',
        ),
        body: AuthService.firebase().currentUser != null
            ? const Body()
            : const Center(
                child: LoginDialog(
                guest: false,
              )),
      );
    });
  }
}
