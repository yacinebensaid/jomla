import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jomla/constants/const_routs.dart';
import 'package:jomla/utilities/show_error_dialog.dart';
import 'package:jomla/view/auth/components/signup_button.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/services.dart';
import '../components/input_fields.dart';
import 'package:jomla/services/auth/auth_exceptions.dart';
import 'package:jomla/services/auth/auth_service.dart';
import 'package:jomla/services/crud/userdata_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NormalRegister extends StatefulWidget {
  const NormalRegister({Key? key}) : super(key: key);

  @override
  State<NormalRegister> createState() => _NormalRegisterState();
}

class _NormalRegisterState extends State<NormalRegister> {
  bool _isVerifying = false;
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _phoneNumber;

//this part is for the sign in informations when the app is functioning
  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
    _firstName = TextEditingController();
    _lastName = TextEditingController();
    _phoneNumber = TextEditingController();
    // Create the AnimationController
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _phoneNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InputFieldArea(
            controler: _firstName,
            keyboardType: TextInputType.emailAddress,
            inputFormat: null,
            hint: "First Name",
            maxlines: 1,
            obscure: false,
            icon: Icons.person_outline,
          ),
          InputFieldArea(
            controler: _lastName,
            keyboardType: null,
            maxlines: 1,
            inputFormat: null,
            hint: "Last Name",
            obscure: false,
            icon: Icons.person_outline,
          ),
          InputFieldArea(
            controler: _phoneNumber,
            maxlines: 1,
            keyboardType: TextInputType.phone,
            inputFormat: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
              // Add more input formatters as needed to format the phone number
            ],
            hint: "Phone Number",
            obscure: false,
            icon: Icons.phone_outlined,
          ),
          InputFieldArea(
            controler: _email,
            keyboardType: null,
            inputFormat: null,
            maxlines: 1,
            hint: "Email",
            obscure: false,
            icon: Icons.email_outlined,
          ),
          InputFieldArea(
            controler: _password,
            keyboardType: null,
            maxlines: 1,
            inputFormat: null,
            hint: "Password",
            obscure: true,
            icon: Icons.lock_outline,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 35.0),
            child: Stack(children: [
              InkWell(
                  onTap: () async {
                    setState(() {
                      _isVerifying = true;
                    });
                    try {
                      await AuthService.firebase()
                          .createUser(
                        email: _email.text,
                        password: _password.text,
                      )
                          .then((value) {
                        DataService _dataServInstance = DataService();
                        _dataServInstance.addUserData(
                          full_name: '${_firstName.text} ${_lastName.text}',
                          phoneNumber: _phoneNumber.text,
                          following: [],
                        );
                      });

                      //we want to send the verification email first so the user doesn't have to press many buttons
                      await AuthService.firebase().sendEmailVerification();
                      //we use pushnamed only because the user can back to the registration page
                      // ignore: use_build_context_synchronously
                      GoRouter.of(context)
                          .pushNamed(RoutsConst.verifyemailRout);
                      setState(() {
                        _isVerifying = false;
                      });
                    } on WeakPasswordAuthException {
                      await showErrorDialog(
                        context,
                        AppLocalizations.of(context)!.weakpassword,
                      );
                      setState(() {
                        _isVerifying = false;
                      });
                    } on EmailInUseAuthException {
                      await showErrorDialog(
                        context,
                        AppLocalizations.of(context)!.emailexists,
                      );
                      setState(() {
                        _isVerifying = false;
                      });
                    } on InvalidEmailAuthException {
                      await showErrorDialog(
                        context,
                        AppLocalizations.of(context)!.invalidemail,
                      );
                      setState(() {
                        _isVerifying = false;
                      });
                    } on GenericAuthException {
                      await showErrorDialog(
                        context,
                        AppLocalizations.of(context)!.registerfaild,
                      );
                      setState(() {
                        _isVerifying = false;
                      });
                    }
                  },
                  child: const SignUpButton()),
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
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
                    child: const Text('verifying...'),
                  ),
                ),
            ]),
          )
        ],
      ),
    );
  }
}
