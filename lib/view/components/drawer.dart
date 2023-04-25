import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:jomla/services/crud/userdata_service.dart';
import 'package:jomla/view/entrypoint/entrypoint.dart';
import 'package:jomla/view/favourite/favourite.dart';
import 'package:jomla/view/pending/pending_view.dart';
import 'package:jomla/view/purchased/purchased_view.dart';
import 'package:jomla/view/products_shipping_service/shipping_service_view.dart';
import 'package:jomla/view/support_staff_orientation.dart';

import '../../constants/routes.dart';
import '../../services/auth/auth_service.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 28, 26, 26),
      child: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          buildHeader(context),
          buildMenuItems(context),
        ],
      )),
    );
  }
}

Widget buildHeader(BuildContext context) => Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
    );

Widget buildMenuItems(BuildContext context) => Column(
      children: [
        const ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.white24,
            child: Icon(
              CupertinoIcons.person,
              color: Colors.white,
            ),
          ),
          title: Text(
            'Yacine Bensaid',
            style: TextStyle(color: Colors.white),
          ),
        ),
        ListTile(
          title: Text(
            "Browse".toUpperCase(),
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.white70),
          ),
        ),
        ListTile(
            leading: const Icon(Icons.home, color: Colors.white),
            title: const Text(
              'Home',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(enterypointRout);
            }),
        ListTile(
            leading: const Icon(
              Icons.favorite,
              color: Colors.white,
            ),
            title: const Text(
              'Favorites',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: ((context) => const FavouriteView())));
            }),
        ListTile(
            leading: const Icon(Icons.pending_actions, color: Colors.white),
            title: const Text(
              'Pending',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: ((context) => const PendingScreen())));
            }),
        ListTile(
            leading: const Icon(Icons.paid_sharp, color: Colors.white),
            title: const Text(
              'Purchased',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: ((context) => const PurchasedScreen())));
            }),
        ListTile(
            leading: const Icon(Icons.chat, color: Colors.white),
            title: const Text(
              'Help chat',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onTap: () {}),
        ListTile(
          title: Text(
            "services".toUpperCase(),
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.white70),
          ),
        ),
        ListTile(
            leading: const Icon(Icons.storage_rounded, color: Colors.white),
            title: const Text(
              'Storage',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onTap: () {}),
        ListTile(
            leading:
                const Icon(Icons.delivery_dining_rounded, color: Colors.white),
            title: const Text(
              'Delivery',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: ((context) => ShippingServicePage())));
            }),
        ListTile(
            leading: const Icon(Icons.more_horiz, color: Colors.white),
            title: const Text(
              'Offers',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onTap: () {}),
        ListTile(
          title: Text(
            "settings".toUpperCase(),
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.white70),
          ),
        ),
        ListTile(
            leading: const Icon(Icons.settings, color: Colors.white),
            title: const Text(
              'Settings',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onTap: () {}),
        ListTile(
            leading: const Icon(Icons.contact_support, color: Colors.white),
            title: const Text(
              'Support',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            /*
            Navigator.of(context).push(MaterialPageRoute(
                            builder: ((context) =>
                                const StaffOrientationPage())));
                                DataService.getUserDataForOrder(userUID)
            */
            onTap: () async {
              final userData = await DataService.getUserData(userUID!);
              if (userData!.isAdmin) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: ((context) => const StaffOrientationPage())));
              } else {}
            }),
        ListTile(
            leading: const Icon(Icons.logout_outlined, color: Colors.white),
            title: const Text(
              'Log out',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onTap: () async {
              final logoutOption = await showLogoutDialog(context);
              if (logoutOption) {
                await AuthService.firebase().logOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRout, (_) => false);
              }
            })
      ],
    );

Future<bool> showLogoutDialog(BuildContext context) {
  //showdialog is a widgit that has context and builder
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('LOG OUT!'),
        content: Text('sure'),
        actions: [
          //the role of all of this is to eather return flase for cancelling and true for sign out
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('cancel')),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('log out')),
        ],
      );
    },
    //we must add 'then' because the return of the showDialog is an optional boolean because the user can prees the return button on his phone instead of the cancel
    // so u eather return a value or false if there is no value
  ).then((value) => value ?? false);
}
