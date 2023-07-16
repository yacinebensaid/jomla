import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jomla/constants/const_routs.dart';
import 'package:jomla/constants/routes.dart';

class SignUpLink extends StatelessWidget {
  const SignUpLink();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 160.0,
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
              fontSize: 12.0,
            ),
          ),
          GestureDetector(
            onTap: () {
              GoRouter.of(context).pushNamed(
                  RoutsConst.registerRout); // Navigates to '/register' route
            },
            child: const Text(
              "Sign Up",
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
      ),
    );
  }
}
