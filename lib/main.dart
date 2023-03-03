import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jomla/constants/routes.dart';
import 'package:jomla/services/auth/auth_service.dart';
import 'package:jomla/view/auth/emailverify_view.dart';
import 'package:jomla/view/auth/login_view.dart';
import 'package:jomla/view/auth/register_view.dart';
import 'package:jomla/view/banner_links/sale/sale.dart';
import 'package:jomla/view/banner_links/tips/tips.dart';
import 'package:jomla/view/banner_links/using_jomla/using_jomla.dart';
import 'package:jomla/view/home/homepage_view.dart';
import 'package:jomla/view/bottombar/staticpage_view.dart';
import 'package:jomla/view/product_datails/details_view.dart';
import 'package:jomla/view/subcat_details/subcat_details_view.dart';
import 'l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        saleRout: (context) => const SalePage(),
        usingJomlaRout: (context) => const UsingJomlaPage(),
        tipsRout: (context) => const TipsPage(),
        detailsRout: (context) => const DetailsScreen(),
        subcatRout: (context) => const SubcatView(),
      },
      supportedLocales: L10n.all,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
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
                return const StaticPage();
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