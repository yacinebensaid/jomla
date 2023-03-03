import 'package:flutter/material.dart';
//flutter pub add firebase_auth
import 'package:jomla/constants/routes.dart';
import 'package:jomla/services/auth/auth_exceptions.dart';
import 'package:jomla/services/auth/auth_service.dart';
import 'package:jomla/services/crud/userdata_service.dart';
import '../../utilities/show_error_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegistationPage extends StatefulWidget {
  const RegistationPage({super.key});

  @override
  State<RegistationPage> createState() => _RegistationPageState();
}

class _RegistationPageState extends State<RegistationPage> {
  //late means that i promise that we gonna provide the type of the variable but not now
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _phoneNumber;
  late final TextEditingController _email;
  late final TextEditingController _password;

//this part is for the sign in informations when the app is functioning
// initsta
  @override
  void initState() {
    _firstName = TextEditingController();
    _lastName = TextEditingController();
    _phoneNumber = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

//this part is for the sign in informations when the app is closed
// dispo
  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _phoneNumber.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //we took of all the scafford and returning only
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.register)),
      body: Column(
        children: [
          TextField(
            controller: _firstName,

            //we must do the enablesug, autocorrect, keyboardtype
            keyboardType: TextInputType.name,
            enableSuggestions: true,
            autocorrect: true,
            decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.enterfirstname),
          ),
          TextField(
            controller: _lastName,

            //we must do the enablesug, autocorrect, obscuretext
            enableSuggestions: true,
            autocorrect: true,
            decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.enterlastname),
          ),
          TextField(
            controller: _phoneNumber,

            //we must do the enablesug, autocorrect, keyboardtype
            keyboardType: TextInputType.phone,
            enableSuggestions: true,
            autocorrect: true,
            decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.enterphonenumber),
          ),
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
              //the firebaseAuth package is a future, that's why we must use the 'await'
              try {
                await AuthService.firebase()
                    .createUser(
                  email: email,
                  password: password,
                )
                    .then((value) {
                  DataService.addUserData(
                    firstName: _firstName.text,
                    lastName: _lastName.text,
                    phoneNumber: _phoneNumber.text,
                  );
                });

                //we want to send the verification email first so the user doesn't have to press many buttons
                await AuthService.firebase().sendEmailVerification();
                //we use pushnamed only because the user can back to the registration page
                // ignore: use_build_context_synchronously
                Navigator.of(context).pushNamed(verifyemailRout);
                // instead of using catch, we gonna handel the espectiontions one by one and by knowing their type

                // instead of using catch, we gonna handel the espectiontions one by one and by knowing their type
              } on WeakPasswordAuthException {
                await showErrorDialog(
                  context,
                  AppLocalizations.of(context)!.weakpassword,
                );
              } on EmailInUseAuthException {
                await showErrorDialog(
                  context,
                  AppLocalizations.of(context)!.emailexists,
                );
              } on InvalidEmailAuthException {
                await showErrorDialog(
                  context,
                  AppLocalizations.of(context)!.invalidemail,
                );
              } on GenericAuthException {
                await showErrorDialog(
                  context,
                  AppLocalizations.of(context)!.registerfaild,
                );
              }
            },
            child: Text(AppLocalizations.of(context)!.register),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRout, (route) => false);
              },
              child: Text(AppLocalizations.of(context)!.loginnow))
        ],
      ),
    );
  }
}
