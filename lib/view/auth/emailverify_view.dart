import 'package:flutter/material.dart';
import 'package:jomla/constants/routes.dart';
import 'package:jomla/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('verify')),
      body: Column(children: [
        const Text(
            'we have send to you an email verification, please check your inbox!'),
        const Text(
            'if you have not receive an email verification, press this button'),
        TextButton(
          onPressed: () async {
            await AuthService.firebase().sendEmailVerification();
          },
          child: const Text('send verification email'),
        ),
        TextButton(
            onPressed: () async {
              await AuthService.firebase().logOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRout, (route) => false);
            },
            child: const Text('restart')),
      ]),
    );
  }
}
