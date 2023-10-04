import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({super.key});
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
        "Sign In",
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

class GuestButton extends StatelessWidget {
  const GuestButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320.0,
      height: 50.0,
      alignment: FractionalOffset.center,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.0),
        border: Border.all(
          color: Colors.black,
          width: 2.0,
        ),
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      child: Text(
        "Continue as a Guest",
        style: TextStyle(
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320.0,
      height: 50.0,
      alignment: FractionalOffset.center,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.0),
        border: Border.all(
          color: Colors.black,
          width: 2.0,
        ),
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 32,
            width: 32,
            child: SvgPicture.asset(
              "assets/icons/google.svg",
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Text(
            "Sign in with Google",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
