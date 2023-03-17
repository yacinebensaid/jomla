import 'package:flutter/material.dart';
import '../../constants/routes.dart';
import '../../services/auth/auth_service.dart';
import '../models/rive_asset.dart';
import '../profile/components/body.dart';
import 'info_card.dart';
import 'side_menu_tile.dart';

// Welcome to the Episode 5
class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  SideBarAsset selectedMenu = sideMenu1.first;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 288,
        height: double.infinity,
        color: const Color(0xFF00235B),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const InfoCard(
                  name: "Yacine Bensaid",
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
                  child: Text(
                    "Browse".toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.white70),
                  ),
                ),
                ...sideMenu1.map(
                  (menu) => SideMenuTile(
                    menu: menu,
                    press: () {
                      setState(() {
                        selectedMenu = menu;
                      });
                      Navigator.pushNamed(context, menu.press);
                    },
                    isActive: selectedMenu == menu,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
                  child: Text(
                    "Services".toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.white70),
                  ),
                ),
                ...sideMenu2.map(
                  (menu) => SideMenuTile(
                    menu: menu,
                    press: () {
                      setState(() {
                        selectedMenu = menu;
                      });
                      Navigator.pushNamed(context, menu.press);
                    },
                    isActive: selectedMenu == menu,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
                  child: Text(
                    "Settings".toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.white70),
                  ),
                ),
                ...sideMenu3.map(
                  (menu) => SideMenuTile(
                    menu: menu,
                    press: () async {
                      setState(() {
                        selectedMenu = menu;
                      });
                      if (menu.title == 'Log out') {
                        final logoutOption = await showLogoutDialog(context);
                        if (logoutOption) {
                          await AuthService.firebase().logOut();
                          Navigator.of(context)
                              .pushNamedAndRemoveUntil(loginRout, (_) => false);
                        }
                      } else {
                        Navigator.pushNamed(context, menu.press);
                      }
                    },
                    isActive: selectedMenu == menu,
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
