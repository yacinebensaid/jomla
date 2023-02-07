import 'package:flutter/material.dart';

import '../../constants/routes.dart';
import '../../enums/actions_menu.dart';
import '../../services/auth/auth_service.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          actions: [
            //creating a popup menu for the logout button
            //we must first create the buttun of the type of our enum
            PopupMenuButton<MenuAction>(
                // the value will get passed
                onSelected: (value) async {
              // we gonna receive a boolean value from the showlogoutdialog
              switch (value) {
                //in case the user selected logout from the menu
                case MenuAction.logout:
                  final logoutOption = await showLogoutDialog(context);
                  if (logoutOption) {
                    await AuthService.firebase().logOut();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRout, (_) => false);
                  }
              }
            },
                //building here the items
                itemBuilder: (context) {
              return const [
                //the item must have the type of our enum
                PopupMenuItem<MenuAction>(
                    //the value is like a name for the item
                    value: MenuAction.logout,
                    child: Text('log out'))
              ];
            })
          ],
        ),
        body: const Text('this is explore'));
  }
}

Future<bool> showLogoutDialog(BuildContext context) {
  //showdialog is a widgit that has context and builder
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign out'),
        content: const Text('are sure you want to sign out?'),
        actions: [
          //the role of all of this is to eather return flase for cancelling and true for sign out
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('cancel')),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('sign out')),
        ],
      );
    },
    //we must add 'then' because the return of the showDialog is an optional boolean because the user can prees the return button on his phone instead of the cancel
    // so u eather return a value or false if there is no value
  ).then((value) => value ?? false);
}
