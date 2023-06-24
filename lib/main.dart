import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jomla/constants/routes.dart';
import 'package:jomla/services/auth/auth_service.dart';
import 'package:jomla/services/crud/userdata_service.dart';
import 'package:jomla/view/auth/email_verification/emailverify_view.dart';
import 'package:jomla/view/auth/login/index.dart';
import 'package:jomla/view/auth/register/register_view.dart';
import 'package:jomla/view/banner_links/sale/sale.dart';
import 'package:jomla/view/banner_links/tips/tips.dart';
import 'package:jomla/view/banner_links/using_jomla/using_jomla.dart';
import 'package:jomla/view/entrypoint/entrypoint.dart';
import 'package:jomla/view/product_storing_service/storing_service.dart';
import 'l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  //flutter must initialize the user creation part before clicking on register
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.black, // Change the status bar color to black
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(411.4, 866.3),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            home: const AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle(
                statusBarColor: Colors.black,
                // Change the status bar color to black
              ),
              child: HomePage(),
            ),
            routes: {
              loginRout: (context) => const LoginScreen(),
              registerRout: (context) => const RegisterPage(),
              verifyemailRout: (context) => const VerifyEmailView(),
              saleRout: (context) => const SalePage(),
              usingJomlaRout: (context) => const UsingJomlaPage(),
              tipsRout: (context) => const TipsPage(),
              storingServiceRout: (context) => const StoringServicePage(),
            },
            supportedLocales: L10n.all,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
          );
        });
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                return EntryPoint(
                  uid: user.uid,
                );
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginScreen();
            }
          default:
            return const Text('loading');
        }
      },
    );
  }
}
