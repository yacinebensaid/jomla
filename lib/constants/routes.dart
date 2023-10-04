import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jomla/constants/const_routs.dart';
import 'package:jomla/main.dart';
import 'package:jomla/services/auth/auth_service.dart';
import 'package:jomla/services/crud/userdata_service.dart';
import 'package:jomla/utilities/page_not_found.dart';
import 'package:jomla/view/add_product/adding_newproduct_view.dart';
import 'package:jomla/view/affiliate_marketing/affiliate_view.dart';
import 'package:jomla/view/auth/email_verification/emailverify_view.dart';
import 'package:jomla/view/auth/login/index.dart';
import 'package:jomla/view/auth/register/register_view.dart';
import 'package:jomla/view/banner_links/sale/sale.dart';
import 'package:jomla/view/banner_links/tips/tips.dart';
import 'package:jomla/view/banner_links/using_jomla/using_jomla.dart';
import 'package:jomla/view/cart/cart_view.dart';
import 'package:jomla/view/cart/checkout.dart';
import 'package:jomla/view/dropshipping/dropshipping.dart';
import 'package:jomla/view/fba/fba_view.dart';
import 'package:jomla/view/entrypoint/entrypoint.dart';
import 'package:jomla/view/explore/explore.dart';
import 'package:jomla/view/favourite/favourite.dart';
import 'package:jomla/view/home/homepage_view.dart';
import 'package:jomla/view/pending/pending_view.dart';
import 'package:jomla/view/product_datails/details_view.dart';
import 'package:jomla/view/products_card/product.dart';
import 'package:jomla/view/profile/profile_view.dart';
import 'package:jomla/view/purchased/purchased_view.dart';
import 'package:jomla/view/settings/settings_view.dart';
import 'package:jomla/view/subcat_details/subcat_details_view.dart';
import 'package:jomla/view/support_staff_orientation.dart';

GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();
void disposekeys() {
  _navigationKey = GlobalKey<NavigatorState>();
}

class MyAppRouter {
  String? _uid;
  GoRouter router = GoRouter(
      navigatorKey: _navigationKey,
      initialLocation: ('/'),
      errorPageBuilder: (context, state) {
        return MaterialPage(
            child: PageNotFound(
          errortexr: state.error!.message,
        ));
      },
      redirect: (context, state) {
        if (AuthService.firebase().currentUser == null &&
            state.location.startsWith('/profile') &&
            MyAppRouter()._uid == null) {
          return '/login';
        } else {
          null;
        }
        return null;
      },
      routes: [
        ShellRoute(
            navigatorKey: GlobalKey<NavigatorState>(),
            builder: (context, state, child) {
              return EntryPoint(key: state.pageKey, child: child);
            },
            routes: [
              GoRoute(
                name: RoutsConst.entryRout,
                path: '/',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: HomeView(),
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
                  routes: [
                    GoRoute(
                      name: RoutsConst.subcatRout,
                      path: 'subcat/:sub_cat',
                      pageBuilder: (context, state) {
                        return NoTransitionPage(
                            child: SubcatView(
                          maincatvalue: state.pathParameters['sub_cat']!,
                        ));
                      },
                    ),
                  ]),
              GoRoute(
                  name: RoutsConst.cartRout,
                  path: '/cart',
                  pageBuilder: (context, state) => NoTransitionPage(
                        child: CartScreen(
                          key: state.pageKey,
                        ),
                      ),
                  routes: [
                    GoRoute(
                      name: RoutsConst.deliverRout,
                      parentNavigatorKey: _navigationKey,
                      path: 'checkout',
                      pageBuilder: (context, state) {
                        return const NoTransitionPage(child: FinalCheckout());
                      },
                    ),
                  ]),
              GoRoute(
                  name: RoutsConst.profileWithUidRout,
                  path: '/profile/:uid',
                  pageBuilder: (context, state) {
                    String? uid;
                    if (AuthService.firebase().currentUser != null) {
                      bool isUid = AuthService.firebase().currentUser!.uid ==
                          state.pathParameters['uid'];

                      if (isUid) {
                        uid = AuthService.firebase().currentUser!.uid;
                        MyAppRouter()._uid =
                            AuthService.firebase().currentUser!.uid;
                      } else {
                        uid = state.pathParameters['uid'];
                        MyAppRouter()._uid = state.pathParameters['uid'];
                      }
                    } else {
                      uid = state.pathParameters['uid'];
                      MyAppRouter()._uid = state.pathParameters['uid'];
                    }

                    return NoTransitionPage(
                      child: ProfileScreen(
                          key: state.pageKey, fromNav: true, uid: uid),
                    );
                  }),
            ]),
        GoRoute(
          name: RoutsConst.loginRout,
          path: '/login',
          pageBuilder: (context, state) {
            return const MaterialPage(child: LoginScreen());
          },
        ),
        GoRoute(
          name: RoutsConst.homeRout,
          path: '/home',
          pageBuilder: (context, state) {
            return const MaterialPage(child: MyApp());
          },
        ),
        GoRoute(
          name: RoutsConst.favRout,
          path: '/favourite',
          pageBuilder: (context, state) {
            return const MaterialPage(child: FavouriteView());
          },
        ),
        GoRoute(
          name: RoutsConst.pendingRout,
          path: '/pending',
          pageBuilder: (context, state) {
            return MaterialPage(child: PendingScreen());
          },
        ),
        GoRoute(
          name: RoutsConst.purchasedRout,
          path: '/purchased',
          pageBuilder: (context, state) {
            return MaterialPage(child: PurchasedScreen());
          },
        ),
        GoRoute(
          name: RoutsConst.helpRout,
          path: '/help-chat',
          pageBuilder: (context, state) {
            return const MaterialPage(child: LoginScreen());
          },
        ),
        GoRoute(
          name: RoutsConst.settingsRout,
          path: '/settings',
          pageBuilder: (context, state) {
            return const MaterialPage(child: SettingsView());
          },
        ),
        GoRoute(
          name: RoutsConst.supportRout,
          path: '/support',
          pageBuilder: (context, state) {
            return const MaterialPage(child: StaffOrientationPage());
          },
        ),
        GoRoute(
          name: RoutsConst.registerRout,
          path: '/register',
          pageBuilder: (context, state) {
            return const MaterialPage(child: RegisterPage());
          },
        ),
        GoRoute(
          name: RoutsConst.verifyemailRout,
          path: '/verifyemail',
          pageBuilder: (context, state) {
            return const MaterialPage(child: VerifyEmailView());
          },
        ),
        GoRoute(
          name: RoutsConst.saleRout,
          path: '/sale',
          pageBuilder: (context, state) {
            return const MaterialPage(child: SalePage());
          },
        ),
        GoRoute(
          name: RoutsConst.usingJomlaRout,
          path: '/howto',
          pageBuilder: (context, state) {
            return const MaterialPage(child: UsingJomlaPage());
          },
        ),
        GoRoute(
          name: RoutsConst.tipsRout,
          path: '/tips',
          pageBuilder: (context, state) {
            return const MaterialPage(child: TipsPage());
          },
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
          name: RoutsConst.onlineMarket,
          parentNavigatorKey: _navigationKey,
          path: '/online-market',
          pageBuilder: (context, state) {
            return const NoTransitionPage(child: OnlineMarket());
          },
        ),
        GoRoute(
          name: RoutsConst.dropshipRout,
          parentNavigatorKey: _navigationKey,
          path: '/dropship',
          pageBuilder: (context, state) {
            return const NoTransitionPage(child: Dropshipping());
          },
        ),
        GoRoute(
          name: RoutsConst.affiRout,
          parentNavigatorKey: _navigationKey,
          path: '/affiliate-marketing',
          pageBuilder: (context, state) {
            return const NoTransitionPage(child: AffiliateMarketing());
          },
        ),
        GoRoute(
          name: RoutsConst.productProductRout,
          parentNavigatorKey: _navigationKey,
          path: '/product',
          pageBuilder: (context, state) {
            Product product = state.extra as Product;
            return MaterialPage(
                child: DetailsScreen(
              product: product,
              ref: null,
              affiId: null,
            ));
          },
        ),
        GoRoute(
          name: RoutsConst.productAffiRout,
          path: '/product/:ref/:affiId',
          pageBuilder: (context, state) {
            return MaterialPage(
                child: DetailsScreen(
              product: null,
              ref: state.pathParameters['ref']!,
              affiId: state.pathParameters['affiId']!,
            ));
          },
        ),
        GoRoute(
          name: RoutsConst.productRefRout,
          path: '/product/:ref',
          pageBuilder: (context, state) {
            return MaterialPage(
                child: DetailsScreen(
              product: null,
              ref: state.pathParameters['ref']!,
              affiId: null,
            ));
          },
        ),
        GoRoute(
            name: RoutsConst.profileRout,
            path: '/profile',
            pageBuilder: (context, state) {
              UserData userData = state.extra as UserData;
              return NoTransitionPage(
                child: ProfileScreen(
                  key: state.pageKey,
                  fromNav: true,
                  passed_userdata: userData,
                  uid: null,
                ),
              );
            }),
      ]);
}
