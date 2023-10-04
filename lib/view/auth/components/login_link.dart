import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jomla/constants/const_routs.dart';

class LogInLink extends StatelessWidget {
  const LogInLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Do you have an account? ",
          style: TextStyle(
            fontWeight: FontWeight.w300,
            letterSpacing: 0.5,
            color: Colors.black,
            fontSize: 15.0,
          ),
        ),
        GestureDetector(
          onTap: () {
            GoRouter.of(context).pushReplacementNamed(
                RoutsConst.loginRout); // Navigates to '/register' route
          },
          child: const Text(
            "Login",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
              color: Colors.black,
              fontSize: 15.0,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
