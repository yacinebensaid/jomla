import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jomla/view/entrypoint/entrypoint.dart';
import 'package:jomla/view/favourite/favourite.dart';

import '../../constants/routes.dart';
import '../../services/auth/auth_service.dart';
import '../profile/components/body.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF00235B),
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
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: ((context) => const EntryPoint())));
            }),
        ListTile(
            leading: const Icon(Icons.favorite, color: Colors.white),
            title: const Text(
              'Favorites',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: ((context) => const FavouriteView())));
            }),
        ListTile(
            leading: const Icon(Icons.pending_actions, color: Colors.white),
            title: const Text(
              'Pending',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {}),
        ListTile(
            leading: const Icon(Icons.paid_sharp, color: Colors.white),
            title: const Text(
              'Purchased',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {}),
        ListTile(
            leading: const Icon(Icons.chat, color: Colors.white),
            title: const Text(
              'Help chat',
              style: TextStyle(color: Colors.white),
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
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {}),
        ListTile(
            leading:
                const Icon(Icons.delivery_dining_rounded, color: Colors.white),
            title: const Text(
              'Delivery',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {}),
        ListTile(
            leading: const Icon(Icons.more_horiz, color: Colors.white),
            title: const Text(
              'Offers',
              style: TextStyle(color: Colors.white),
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
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {}),
        ListTile(
            leading: const Icon(Icons.contact_support, color: Colors.white),
            title: const Text(
              'Support',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {}),
        ListTile(
            leading: const Icon(Icons.logout_outlined, color: Colors.white),
            title: const Text(
              'Log out',
              style: TextStyle(color: Colors.white),
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
