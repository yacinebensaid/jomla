import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jomla/services/auth/auth_service.dart';
import 'package:jomla/services/providers.dart';
import 'package:provider/provider.dart';
import 'package:jomla/constants/routes.dart';
import 'l10n/l10n.dart';

void main() {
  //flutter must initialize the user creation part before clicking on register
  WidgetsFlutterBinding.ensureInitialized();

  // Create a SystemUiOverlayStyle with the gradient
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark));

  AuthService.firebase().initialize().then((value) => runApp(MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) {
            return UserDataInitializer();
          }),
          ChangeNotifierProvider(
            create: (context) => CheckedCartProducts(),
          ),
          ChangeNotifierProvider(
            create: (context) => HomeFunc(),
          )
        ],
        child: const MyApp(),
      )));
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
          return StreamProvider<InternetConnectionStatus>(
            initialData: InternetConnectionStatus.connected,
            create: (_) {
              return InternetConnectionChecker().onStatusChange;
            },
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              routerConfig: MyAppRouter().router,
              supportedLocales: L10n.all,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
            ),
          );
        });
  }
}
/*
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
}*/
