import 'package:flutter/material.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320.0,
      height: 60.0,
      alignment: FractionalOffset.center,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 17, 176, 216),
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      child: const Text(
        "Sign Up",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
