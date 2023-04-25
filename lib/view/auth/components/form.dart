import 'package:flutter/material.dart';

import 'input_fields.dart';

class FormContainer extends StatefulWidget {
  const FormContainer({super.key});

  @override
  State<FormContainer> createState() => _FormContainerState();
}

class _FormContainerState extends State<FormContainer> {
  //late means that i promise that we gonna provide the type of the variable but not now
  late final TextEditingController _email;

  late final TextEditingController _password;

//this part is for the sign in informations when the app is functioning
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

//this part is for the sign in informations when the app is closed
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Form(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  InputFieldArea(
                    controler: _email,
                    keyboardType: TextInputType.emailAddress,
                    inputFormat: null,
                    hint: "Email",
                    obscure: false,
                    icon: Icons.person_outline,
                  ),
                  InputFieldArea(
                    controler: _password,
                    inputFormat: null,
                    keyboardType: null,
                    hint: "Password",
                    obscure: true,
                    icon: Icons.lock_outline,
                  ),
                ],
              )),
            ],
          ),
        ),
      ],
    );
  }
}
