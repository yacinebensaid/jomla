import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jomla/constants/const_routs.dart';

class SignUpLink extends StatelessWidget {
  const SignUpLink();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 100.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Don't have an account? ",
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
                  RoutsConst.registerRout); // Navigates to '/register' route
            },
            child: const Text(
              "Sign Up",
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
      ),
    );
  }
}
