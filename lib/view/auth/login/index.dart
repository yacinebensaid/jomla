import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jomla/constants/const_routs.dart';
import 'package:jomla/constants/routes.dart';

import 'package:jomla/main.dart';
import 'package:jomla/services/providers.dart';
import 'package:jomla/view/auth/password_recovery/password_recovery.dart';
import 'package:provider/provider.dart';
import '../components/input_fields.dart';
import '../components/sign_uplink.dart';
import '../components/signin_button.dart';
import 'login_animation.dart';
import 'package:jomla/services/auth/auth_exceptions.dart';
import 'package:jomla/services/auth/auth_service.dart';
import 'package:jomla/utilities/show_error_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shimmer/shimmer.dart';

class LoginScreen extends StatefulWidget {
  final bool? notfromNav;
  const LoginScreen({Key? key, this.notfromNav}) : super(key: key);
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  bool _isVerifying = false;

  late AnimationController _loginButtonController;
  late Animation<double> _buttonSqueezeAnimation;
  var animationStatus = 0;
  late final TextEditingController _email;

  late final TextEditingController _password;

//this part is for the sign in informations when the app is functioning
  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
    // Create the AnimationController
    _loginButtonController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // Create the animation that will be passed to the StaggerAnimation widget
    _buttonSqueezeAnimation = Tween(
      begin: 320.0,
      end: 70.0,
    ).animate(
      CurvedAnimation(
        parent: _loginButtonController,
        curve: const Interval(0.0, 0.150),
      ),
    );
  }

  @override
  void dispose() {
    _loginButtonController.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _playAnimation() async {
    try {
      await _loginButtonController.forward();
      await _loginButtonController.reverse();
    } on TickerCanceled {}
  }

  signInWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    UserCredential usercredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    if (usercredential.user != null) {
      if (usercredential.user!.emailVerified != false) {
        //user email is verified
        // ignore: use_build_context_synchronously
        setState(() {
          _isVerifying = false;
          animationStatus = 1;
        });
        await _playAnimation();

        if (widget.notfromNav == null) {
          Provider.of<UserDataInitializer>(context, listen: false).inituser();
          disposekeys();
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => MyApp()));
        } else {
          Provider.of<UserDataInitializer>(context, listen: false).inituser();
          disposekeys();
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => MyApp()));
        }
      } else {
        //user email is not verified
        // ignore: use_build_context_synchronously
        setState(() {
          _isVerifying = false;
        });
        GoRouter.of(context).pushNamed(RoutsConst.verifyemailRout);
      }
    } else {
      setState(() {
        _isVerifying = false;
      });
      await showErrorDialog(
        context,
        'User not found',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 300),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: [
                          InkWell(
                              onTap: () {
                                if (widget.notfromNav == null) {
                                  Provider.of<UserDataInitializer>(context,
                                          listen: false)
                                      .inituser();
                                  disposekeys();
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => MyApp()));
                                } else {
                                  Provider.of<UserDataInitializer>(context,
                                          listen: false)
                                      .inituser();
                                  disposekeys();
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => MyApp()));
                                }
                              },
                              child: GuestButton()),
                          SizedBox(
                            height: 5,
                          ),
                          InkWell(
                              onTap: () {
                                signInWithGoogle();
                              },
                              child: GoogleSignInButton()),
                          Divider(),
                          Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Form(
                                    child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    InputFieldArea(
                                      controler: _email,
                                      maxlines: 1,
                                      inputFormat: null,
                                      keyboardType: TextInputType.emailAddress,
                                      hint: "Email",
                                      obscure: false,
                                      icon: Icons.person_outline,
                                    ),
                                    InputFieldArea(
                                      controler: _password,
                                      inputFormat: null,
                                      maxlines: 1,
                                      keyboardType: null,
                                      hint: "Password",
                                      obscure: true,
                                      icon: Icons.lock_outline,
                                    ),
                                  ],
                                )),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: ((context) =>
                                                  PasswordRecoveryPage())));
                                    },
                                    child: Text(
                                      'Forgot your password?',
                                      style: TextStyle(
                                          fontSize: 19, color: Colors.grey),
                                    )),
                              ],
                            ),
                          ),
                          SignUpLink(),
                        ],
                      ),
                    ],
                  ),
                ),
                animationStatus == 0
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 50.0),
                        child: Stack(children: [
                          InkWell(
                              onTap: () async {
                                setState(() {
                                  _isVerifying = true;
                                });
                                try {
                                  //the firebaseAuth package is a future, that's why we must use the 'await'
                                  //it is the same as sign up but here we have signin instead of createuser
                                  await AuthService.firebase().logIn(
                                    email: _email.text,
                                    password: _password.text,
                                  );
                                  final user =
                                      AuthService.firebase().currentUser;
                                  if (user?.isEmailVerified ?? false) {
                                    //user email is verified
                                    // ignore: use_build_context_synchronously
                                    setState(() {
                                      _isVerifying = false;
                                      animationStatus = 1;
                                    });
                                    await _playAnimation();

                                    if (widget.notfromNav == null) {
                                      Provider.of<UserDataInitializer>(context,
                                              listen: false)
                                          .inituser();
                                      disposekeys();
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: ((context) => MyApp())));
                                    } else {
                                      Provider.of<UserDataInitializer>(context,
                                              listen: false)
                                          .inituser();
                                      Navigator.pop(context);
                                      disposekeys();
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: ((context) => MyApp())));
                                    }
                                  } else {
                                    //user email is not verified
                                    // ignore: use_build_context_synchronously
                                    setState(() {
                                      _isVerifying = false;
                                    });
                                    GoRouter.of(context)
                                        .pushNamed(RoutsConst.verifyemailRout);
                                  }
                                  // instead of using catch, we gonna handel the espectiontions one by one and by knowing their type
                                } on UserNotFoundAuthException {
                                  setState(() {
                                    _isVerifying = false;
                                  });
                                  await showErrorDialog(
                                    context,
                                    AppLocalizations.of(context)!.usernotfound,
                                  );
                                } on WrongPasswordAuthException {
                                  setState(() {
                                    _isVerifying = false;
                                  });
                                  await showErrorDialog(
                                    context,
                                    AppLocalizations.of(context)!.wrongpassword,
                                  );
                                } on GenericAuthException {
                                  setState(() {
                                    _isVerifying = false;
                                  });
                                  await showErrorDialog(
                                    context,
                                    AppLocalizations.of(context)!
                                        .authenticationerror,
                                  );
                                }
                              },
                              child: SignInButton()),
                          if (_isVerifying)
                            Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: 320.0,
                                height: 60.0,
                                alignment: FractionalOffset.center,
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(247, 64, 106, 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                ),
                                child: const Text('verifying...'),
                              ),
                            ),
                        ]),
                      )
                    : StaggerAnimation(
                        buttonController: _loginButtonController,
                        buttonSqueezeAnimation: _buttonSqueezeAnimation,
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
