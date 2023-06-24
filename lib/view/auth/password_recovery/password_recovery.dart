import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jomla/utilities/success_dialog.dart';

class PasswordRecoveryPage extends StatefulWidget {
  @override
  _PasswordRecoveryPageState createState() => _PasswordRecoveryPageState();
}

class _PasswordRecoveryPageState extends State<PasswordRecoveryPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _emailController = TextEditingController();

  void _sendPasswordResetEmail() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      try {
        await _auth.sendPasswordResetEmail(email: email);
        // Show a success message or navigate to a success page
        Navigator.pop(context);
        showSuccessDialog(context, 'Password reset email sent successfully.');
      } catch (e) {
        // Show an error message
        showSuccessDialog(context, 'Error sending password reset email.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          shadowColor: Colors.transparent.withOpacity(0),
          backgroundColor: Colors.transparent.withOpacity(0),
          title: Text('Password Recovery'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(
                              r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _sendPasswordResetEmail,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10), // Set rounded corner radius
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 60,
                      vertical: 7,
                    ), // Increase padding to make the button larger
                    textStyle: TextStyle(fontSize: 18), // Increase font size
                  ),
                  child: const Text(
                    'Send recovery email',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
