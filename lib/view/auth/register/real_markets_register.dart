import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jomla/utilities/show_error_dialog.dart';
import 'package:jomla/view/auth/components/signup_button.dart';
import 'package:shimmer/shimmer.dart';
import '../components/input_fields.dart';
import 'package:jomla/constants/routes.dart';
import 'package:jomla/services/auth/auth_exceptions.dart';
import 'package:jomla/services/auth/auth_service.dart';
import 'package:jomla/services/crud/userdata_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jomla/view/var_lib.dart' as vars;

class RealMarketsRegister extends StatefulWidget {
  const RealMarketsRegister({Key? key}) : super(key: key);

  @override
  State<RealMarketsRegister> createState() => _RealMarketsRegisterState();
}

class _RealMarketsRegisterState extends State<RealMarketsRegister> {
  bool _isVerifying = false;

  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _marketName;
  late final TextEditingController _phoneNumber;
  late final TextEditingController _marketLocation;
  bool _isOranSelected = true;
  String? _selectedCategory;

  final List<String> _categories = vars.get_mainCategoryOptionEX();

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
    _marketName = TextEditingController();
    _marketLocation = TextEditingController();
    _phoneNumber = TextEditingController();
    _isOranSelected = true;
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _marketName.dispose();
    _marketLocation.dispose();
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
            controler: _marketName,
            keyboardType: TextInputType.emailAddress,
            inputFormat: null,
            hint: "Market Name",
            obscure: false,
            icon: Icons.person_outline,
          ),
          Center(
            child: Container(
              width: 240,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(13)),
              child: DropdownButton<String>(
                hint: const Text('choose main category'),
                value: _selectedCategory,

                iconEnabledColor: Colors.black,
                isExpanded: true,
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
                dropdownColor: const Color.fromARGB(255, 241, 241, 241),
                elevation: 15,
                iconSize: 36,
                // Set the font color to white
                items: _categories.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
          InputFieldArea(
            controler: _phoneNumber,
            keyboardType: TextInputType.phone,
            inputFormat: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            hint: "Phone Number",
            obscure: false,
            icon: Icons.phone_outlined,
          ),
          InputFieldArea(
            controler: _email,
            keyboardType: null,
            inputFormat: null,
            hint: "Email",
            obscure: false,
            icon: Icons.email_outlined,
          ),
          InputFieldArea(
            controler: _password,
            keyboardType: null,
            inputFormat: null,
            hint: "Password",
            obscure: true,
            icon: Icons.lock_outline,
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: _isOranSelected,
                  onChanged: (value) {
                    setState(() {
                      _isOranSelected = value!;
                    });
                  },
                ),
                const Text('Oran', style: TextStyle(fontSize: 18)),
                const SizedBox(
                  width: 80,
                ),
                Checkbox(
                  value: !_isOranSelected,
                  onChanged: (value) {
                    setState(() {
                      _isOranSelected = !value!;
                    });
                  },
                ),
                const Text(
                  'Setif',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          InputFieldArea(
            controler: _marketLocation,
            keyboardType: TextInputType.streetAddress,
            inputFormat: null,
            hint: "Adress",
            obscure: false,
            icon: Icons.location_on_outlined,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 35.0),
            child: Stack(children: [
              InkWell(
                  onTap: () async {
                    setState(() {
                      _isVerifying = true;
                    });
                    String city = _isOranSelected ? 'Oran' : 'Setif';

                    try {
                      await AuthService.firebase()
                          .createUser(
                        email: _email.text,
                        password: _password.text,
                      )
                          .then((value) {
                        DataService.addMarketData(
                          marketName: _marketName.text,
                          marketCategory: _selectedCategory!,
                          phoneNumber: _phoneNumber.text,
                          city: city,
                          adress: _marketLocation.text,
                          owned_products: [],
                        );
                      });

                      //we want to send the verification email first so the user doesn't have to press many buttons
                      await AuthService.firebase().sendEmailVerification();
                      //we use pushnamed only because the user can back to the registration page
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pushNamed(verifyemailRout);
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
