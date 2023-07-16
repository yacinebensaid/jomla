import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:jomla/constants/const_routs.dart';
import 'package:jomla/services/providers.dart';
import 'package:jomla/utilities/page_not_found.dart';
import 'package:jomla/view/add_product/adding_newproduct_view.dart';
import 'package:jomla/view/auth/email_verification/emailverify_view.dart';
import 'package:jomla/view/auth/login/index.dart';
import 'package:jomla/view/auth/register/register_view.dart';
import 'package:jomla/view/banner_links/sale/sale.dart';
import 'package:jomla/view/banner_links/tips/tips.dart';
import 'package:jomla/view/banner_links/using_jomla/using_jomla.dart';
import 'package:jomla/view/cart/cart_view.dart';
import 'package:jomla/view/entrypoint/entrypoint.dart';
import 'package:jomla/view/explore/explore.dart';
import 'package:jomla/view/home/homepage_view.dart';
import 'package:jomla/view/product_datails/details_view.dart';
import 'package:jomla/view/products_card/product.dart';
import 'package:jomla/view/profile/profile_view.dart';
import 'package:provider/provider.dart';

class MyAppRouter {
  GoRouter router = GoRouter(
      initialLocation: ('/'),
      errorPageBuilder: (context, state) {
        return MaterialPage(child: PageNotFound());
      },
      redirect: (context, state) {},
      routes: [
        ShellRoute(
            builder: (context, state, child) {
              return AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle(
                  statusBarColor: Colors.black,
                  // Change the status bar color to black
                ),
                child: EntryPoint(key: state.pageKey, child: child),
              );
            },
            routes: [
              GoRoute(
                name: RoutsConst.entryRout,
                path: '/',
                pageBuilder: (context, state) => NoTransitionPage(
                  child: HomeView(
                    key: state.pageKey,
                  ),
                ),
              ),
              GoRoute(
                name: RoutsConst.cartRout,
                path: '/cart',
                pageBuilder: (context, state) => NoTransitionPage(
                  child: CartScreen(
                    key: state.pageKey,
                  ),
                ),
              ),
              GoRoute(
                name: RoutsConst.addRout,
                path: '/add',
                pageBuilder: (context, state) => NoTransitionPage(
                  child: AddProductPage(
                    key: state.pageKey,
                  ),
                ),
              ),
              GoRoute(
                name: RoutsConst.exploreRout,
                path: '/explore',
                pageBuilder: (context, state) => NoTransitionPage(
                  child: ExploreView(
                    key: state.pageKey,
                  ),
                ),
              ),
              GoRoute(
                name: RoutsConst.profileRout,
                path: '/profile/:uid',
                pageBuilder: (context, state) => NoTransitionPage(
                  child: ProfileScreen(
                      key: state.pageKey,
                      fromNav: true,
                      uid: state.pathParameters['uid']),
                ),
              ),
            ]),
        GoRoute(
          name: RoutsConst.loginRout,
          path: '/login',
          pageBuilder: (context, state) {
            return MaterialPage(child: LoginScreen());
          },
        ),
        GoRoute(
          name: RoutsConst.registerRout,
          path: '/register',
          pageBuilder: (context, state) {
            return MaterialPage(child: RegisterPage());
          },
        ),
        GoRoute(
          name: RoutsConst.verifyemailRout,
          path: '/verifyemail',
          pageBuilder: (context, state) {
            return MaterialPage(child: VerifyEmailView());
          },
        ),
        GoRoute(
          name: RoutsConst.saleRout,
          path: '/sale',
          pageBuilder: (context, state) {
            return MaterialPage(child: SalePage());
          },
        ),
        GoRoute(
          name: RoutsConst.usingJomlaRout,
          path: '/howto',
          pageBuilder: (context, state) {
            return MaterialPage(child: UsingJomlaPage());
          },
        ),
        GoRoute(
          name: RoutsConst.tipsRout,
          path: '/tips',
          pageBuilder: (context, state) {
            return MaterialPage(child: TipsPage());
          },
        ),
        GoRoute(
          name: RoutsConst.productRout,
          path: '/product/:ref',
          pageBuilder: (context, state) {
            Product? product = state.extra as Product?;
            return MaterialPage(
                child: DetailsScreen(
              product: product,
              ref: state.pathParameters['ref'],
            ));
          },
        ),
      ]);
}
