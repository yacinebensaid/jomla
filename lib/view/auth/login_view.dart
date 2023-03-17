import 'package:flutter/material.dart';
//flutter pub add firebase_auth
//this package is for the authentification
import 'package:jomla/constants/routes.dart';
import 'package:jomla/services/auth/auth_exceptions.dart';
import 'package:jomla/services/auth/auth_service.dart';
import '../../utilities/show_error_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//login page is the exact same page as signup page just with some small changes

//stl=> less / stf=> ful
//ctr+shift+r wrap with statefulwidget
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  //late means that i promise that we gonna provide the type of the variable but not now
  late final TextEditingController _email;
  late final TextEditingController _password;

//this part is for the sign in informations when the app is functioning
// initsta
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

//this part is for the sign in informations when the app is closed
// dispo
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.login),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,

            //we must do the enablesug, autocorrect, keyboardtype
            keyboardType: TextInputType.emailAddress,
            enableSuggestions: false,
            autocorrect: false,
            decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.enteremail),
          ),
          TextField(
            controller: _password,

            //we must do the enablesug, autocorrect, obscuretext
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.enterpassword),
          ),
          TextButton(
            //async because we need the button to read the informations after we press it
            onPressed: () async {
              //we must do _email.text and _password.text
              final email = _email.text;
              final password = _password.text;
              //user does not exist handeling
              try {
                //the firebaseAuth package is a future, that's why we must use the 'await'
                //it is the same as sign up but here we have signin instead of createuser
                await AuthService.firebase().logIn(
                  email: email,
                  password: password,
                );
                final user = AuthService.firebase().currentUser;
                if (user?.isEmailVerified ?? false) {
                  //user email is verified
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    enterypointRout,
                    (route) => false,
                  );
                  //////////////////////////////////////////////////
                } else {
                  //user email is not verified
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    verifyemailRout,
                    (route) => false,
                  );
                }
                // instead of using catch, we gonna handel the espectiontions one by one and by knowing their type
              } on UserNotFoundAuthException {
                await showErrorDialog(
                  context,
                  AppLocalizations.of(context)!.usernotfound,
                );
              } on WrongPasswordAuthException {
                await showErrorDialog(
                  context,
                  AppLocalizations.of(context)!.wrongpassword,
                );
              } on GenericAuthException {
                await showErrorDialog(
                  context,
                  AppLocalizations.of(context)!.authenticationerror,
                );
              }
            },
            child: Text(AppLocalizations.of(context)!.login),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRout, (route) => false);
              },
              child: Text(AppLocalizations.of(context)!.registernow))
        ],
      ),
    );
  }
}
