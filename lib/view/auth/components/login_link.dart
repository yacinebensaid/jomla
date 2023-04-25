import 'package:flutter/material.dart';
import 'package:jomla/constants/routes.dart';

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
            fontSize: 12.0,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(
                context, loginRout); // Navigates to '/register' route
          },
          child: const Text(
            "Login",
            style: TextStyle(
              fontWeight: FontWeight.w300,
              letterSpacing: 0.5,
              color: Colors.black,
              fontSize: 12.0,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
