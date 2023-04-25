import 'package:flutter/material.dart';
import 'package:jomla/view/auth/components/login_link.dart';

import 'normal_register.dart';
import 'real_markets_register.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isNormalUser = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(padding: const EdgeInsets.all(0.0), children: [
        Stack(alignment: AlignmentDirectional.bottomCenter, children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 100, bottom: 300),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isNormalUser = true;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: isNormalUser ? Colors.blue : Colors.grey,
                              width: 1.5,
                            ),
                          ),
                        ),
                        child: Text(
                          'Normal User',
                          style: TextStyle(
                            color: isNormalUser ? Colors.black : Colors.grey,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isNormalUser = false;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: !isNormalUser ? Colors.blue : Colors.grey,
                              width: 1.5,
                            ),
                          ),
                        ),
                        child: Text(
                          'Real Market',
                          style: TextStyle(
                            color: isNormalUser ? Colors.grey : Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Form(
                    child: Column(
                  children: [
                    isNormalUser
                        ? const NormalRegister()
                        : const RealMarketsRegister(),
                  ],
                )),
                const LogInLink(),
              ],
            ),
          ),
        ]),
      ]),
    );
  }
}
