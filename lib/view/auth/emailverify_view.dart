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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'We have sent you an email verification, please check your inbox!',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'After verifying you email, Login to your account',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  await AuthService.firebase().logOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRout,
                    (route) => false,
                  );
                },
                child: Text(
                  'Go to login page',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              const Text(
                'If you have not received an email verification, press this button:',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: () async {
                  await AuthService.firebase().sendEmailVerification();
                },
                child: Text(
                  AppLocalizations.of(context)!.sendemail,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
