/////////unused/////////////

import 'package:flutter/material.dart';
import 'package:jomla/services/auth/auth_service.dart';
import 'package:jomla/services/crud/crud_exceptions.dart';

import '../../constants/routes.dart';
import '../../enums/actions_menu.dart';
import '../../services/crud/userdata_service.dart';
import '../../utilities/show_error_dialog.dart';

class UserDataView extends StatefulWidget {
  const UserDataView({super.key});

  @override
  State<UserDataView> createState() => _UserDataState();
}

class _UserDataState extends State<UserDataView> {
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _phoneNumber;

  @override
  void initState() {
    _firstName = TextEditingController();
    _lastName = TextEditingController();
    _phoneNumber = TextEditingController();

    super.initState();
  }

//this part is for the sign in informations when the app is closed
// dispo
  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _phoneNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(''),
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
        body: Column(children: [
          TextField(
            controller: _firstName,

            //we must do the enablesug, autocorrect, keyboardtype
            keyboardType: TextInputType.name,
            enableSuggestions: true,
            autocorrect: true,
            decoration: const InputDecoration(hintText: 'Enter your email'),
          ),
          TextField(
            controller: _lastName,

            //we must do the enablesug, autocorrect, obscuretext
            enableSuggestions: true,
            autocorrect: true,
            decoration: const InputDecoration(hintText: 'Enter your password'),
          ),
          TextField(
            controller: _phoneNumber,

            //we must do the enablesug, autocorrect, keyboardtype
            keyboardType: TextInputType.phone,
            enableSuggestions: true,
            autocorrect: true,
            decoration: const InputDecoration(hintText: 'Enter your email'),
          ),
          TextButton(
            //async because we need the button to read the informations after we press it
            onPressed: () async {
              //we must do _email.text and _password.text
              try {
                await DataService.addUserData(
                  firstName: _firstName.text,
                  lastName: _lastName.text,
                  phoneNumber: _phoneNumber.text,
                ).then((value) => Navigator.of(context).pushNamedAndRemoveUntil(
                      homepageRout,
                      (route) => false,
                    ));
              } on InvalidCredintials {
                await showErrorDialog(
                  context,
                  'Invalid informations',
                );
              }
            },
            child: const Text('register'),
          ),
        ]));
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
