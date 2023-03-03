import 'package:flutter/material.dart';
import 'package:jomla/constants/routes.dart';
import 'package:jomla/services/auth/auth_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.verify)),
      body: Column(children: [
        Text(AppLocalizations.of(context)!.emailverificationsent),
        Text(AppLocalizations.of(context)!.emailnotrecieved),
        TextButton(
          onPressed: () async {
            await AuthService.firebase().sendEmailVerification();
          },
          child: Text(AppLocalizations.of(context)!.sendemail),
        ),
        TextButton(
            onPressed: () async {
              await AuthService.firebase().logOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRout, (route) => false);
            },
            child: Text(AppLocalizations.of(context)!.restart)),
      ]),
    );
  }
}
