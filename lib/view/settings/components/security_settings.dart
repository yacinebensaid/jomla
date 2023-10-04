import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jomla/utilities/reusable.dart';
import 'package:jomla/utilities/success_dialog.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _errorMessage;

  Future<void> _changePassword() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _errorMessage = 'User not logged in.';
      });
      return;
    }

    final String oldPassword = _oldPasswordController.text.trim();
    final String newPassword = _newPasswordController.text.trim();
    final String confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword != confirmPassword) {
      setState(() {
        _errorMessage = 'New password and confirmation password do not match.';
      });
      return;
    }

    try {
      // Reauthenticate the user with their old password
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // Change the password
      await user.updatePassword(newPassword);

      // Password updated successfully
      // You can show a success message or navigate to another page here
      setState(() {
        _errorMessage = null; // clear any previous error message
      });
      Navigator.pop(context);
      showSuccessDialog(
        context,
        'Password Updated Successfully',
      );
    } catch (e) {
      setState(() {
        _errorMessage =
            'Error changing password, please check the entered credentials';
      });
    }
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarSubPages(
        onBackButtonPressed: () => Navigator.of(context).pop(),
        title: 'Security settings',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _oldPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Old Password',
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Please enter your old password.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'New Password',
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Please enter your new password.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Please confirm your new password.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              _errorMessage != null
                  ? Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    )
                  : Container(),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _changePassword();
                  }
                },
                child: Text('Change Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
