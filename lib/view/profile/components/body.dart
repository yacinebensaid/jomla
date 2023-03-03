import 'package:flutter/material.dart';
import '../../../constants/routes.dart';
import '../../../enums/actions_menu.dart';
import '../../../services/auth/auth_service.dart';
import 'profile_menu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20),
          ProfileMenu(
            text: AppLocalizations.of(context)!.myaccount,
            icon: "assets/icons/User Icon.svg",
            press: () => {},
          ),
          ProfileMenu(
            text: AppLocalizations.of(context)!.notifications,
            icon: "assets/icons/Bell.svg",
            press: () {},
          ),
          ProfileMenu(
            text: AppLocalizations.of(context)!.settings,
            icon: "assets/icons/Settings.svg",
            press: () {},
          ),
          ProfileMenu(
            text: AppLocalizations.of(context)!.helpcenter,
            icon: "assets/icons/Question mark.svg",
            press: () {},
          ),
          ProfileMenu(
            text: AppLocalizations.of(context)!.logout,
            icon: "assets/icons/Log out.svg",
            press: () async {
              final logoutOption = await showLogoutDialog(context);
              if (logoutOption) {
                await AuthService.firebase().logOut();
                // ignore: use_build_context_synchronously
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRout, (_) => false);
              }
            },
          ),
        ],
      ),
    );
  }
}

Future<bool> showLogoutDialog(BuildContext context) {
  //showdialog is a widgit that has context and builder
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(AppLocalizations.of(context)!.logout),
        content: Text(AppLocalizations.of(context)!.surelogout),
        actions: [
          //the role of all of this is to eather return flase for cancelling and true for sign out
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(AppLocalizations.of(context)!.cancel)),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(AppLocalizations.of(context)!.logout)),
        ],
      );
    },
    //we must add 'then' because the return of the showDialog is an optional boolean because the user can prees the return button on his phone instead of the cancel
    // so u eather return a value or false if there is no value
  ).then((value) => value ?? false);
}
