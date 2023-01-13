import 'package:flutter/material.dart';
import 'package:jomla/constants/routes.dart';
import 'package:jomla/services/auth/auth_service.dart';
import 'package:jomla/view/auth/emailverify_view.dart';
import 'package:jomla/view/auth/login_view.dart';
import 'package:jomla/view/auth/register_view.dart';
import 'package:jomla/view/auth/user_data_view.dart';
import 'package:jomla/view/home/homepage_view.dart';

void main() {
  //flutter must initialize the user creation part before clicking on register
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        loginRout: (context) => const LoginView(),
        registerRout: (context) => const RegistationPage(),
        verifyemailRout: (context) => const VerifyEmailView(),
        homepageRout: (context) => const HomeView(),
      },
    ),
  );
}

// we don't want to have intializiation in every page, we want to initialize eveything just one time from here

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      //we are building after the future returns a result
      builder: (context, snapshot) {
        //the snapshot is tracking the state of our future before building, if the future is processing the data or is it done or failed
        // but here we are not building, this is just for initializing
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            // handeling email verification
            final user = AuthService.firebase().currentUser;
            // redirecting the user based on his account status
            if (user != null) {
              if (user.isEmailVerified) {
                return const UserDataView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const Text('loading');
        }
      },
    );
  }
}


// flutter pub add sqflite
//flutter pub add path_provider
// flutter pub add path_provider 