import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jomla/constants/const_routs.dart';
import 'package:jomla/services/crud/userdata_service.dart';
import 'package:jomla/services/providers.dart';
import 'package:jomla/utilities/reusable.dart';
import 'package:jomla/utilities/shimmers.dart';
import 'package:provider/provider.dart';
import '../../services/auth/auth_service.dart';

class CostumNavigationDrawer extends StatefulWidget {
  const CostumNavigationDrawer({
    super.key,
  });

  @override
  State<CostumNavigationDrawer> createState() => _CostumNavigationDrawerState();
}

class _CostumNavigationDrawerState extends State<CostumNavigationDrawer> {
  Widget drawer() {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 9, 156, 219),
              Color.fromARGB(255, 3, 184, 216), // Start color (your blue color)
              // End color (lighter color)
              Color.fromARGB(255, 7, 206, 212),
            ],
            begin:
                Alignment.topLeft, // You can adjust the gradient's start point
            end: Alignment
                .bottomRight, // You can adjust the gradient's end point
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
              child: Column(
            children: [
              const SizedBox(
                height: 6,
              ),
              //heading
              StreamBuilder(
                  stream: UserDataInitializer().userDataStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data?.id != null) {
                      return Column(
                        children: [
                          heading(userDataInitializer: snapshot.data!),
                          const Divider(
                            height: 1,
                            thickness: 0.15,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ],
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),

              const Divider(
                height: 1,
                thickness: 0.15,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              ListTile(
                title: Text(
                  "Browse".toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Color.fromARGB(255, 255, 255, 255)),
                ),
              ),
              buildList(items: itemsBrows),
              const Divider(
                height: 1,
                thickness: 0.15,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              ListTile(
                title: Text(
                  "services".toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Color.fromARGB(255, 255, 255, 255)),
                ),
              ),
              buildList(items: itemsServices),
              const Divider(
                height: 1,
                thickness: 0.15,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              ListTile(
                title: Text(
                  "settings".toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Color.fromARGB(255, 255, 255, 255)),
                ),
              ),
              buildList(items: itemsSettings),
              AuthService.firebase().currentUser != null
                  ? buildLoginLogout(
                      text: 'Log out',
                      icon: Icons.logout_outlined,
                      action: () async {
                        final logoutOption = await showLogoutDialog(context);
                        if (logoutOption) {
                          context
                              .read<CheckedCartProducts>()
                              .updateCheckedProducts(newCheckedMap: {});
                          GoogleSignIn().disconnect();
                          AuthService.firebase().logOut().then((value) =>
                              Provider.of<HomeFunc>(context, listen: false)
                                  .onTapNavigation(context, 3));
                        }
                      })
                  : buildLoginLogout(
                      text: 'Log in',
                      icon: Icons.login_outlined,
                      action: () {
                        Provider.of<HomeFunc>(context, listen: false)
                            .onTapNavigation(context, 3);

                        //GoRouter.of(context).go('/login');
                      }),
            ],
          )),
        ),
      ),
    );
  }

  Widget heading({required UserData userDataInitializer}) {
    return GestureDetector(
      onTap: () {
        Provider.of<HomeFunc>(context, listen: false)
            .onTapNavigation(context, 3);
      },
      child: ListTile(
        leading: userDataInitializer.picture == null
            ? CircleAvatar(
                radius: 22,
                backgroundColor: Colors.grey[400],
                child: Icon(
                  CupertinoIcons.person,
                  color: Colors.white,
                ),
              )
            : CircleAvatar(
                radius: 22,
                backgroundColor: Colors.grey[400],
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Center(
                      child: CachedNetworkImage(
                    key: UniqueKey(),
                    imageUrl: userDataInitializer.picture!,
                    height: 22,
                    width: 22,
                    maxWidthDiskCache: 250,
                    fit: BoxFit.cover,
                    placeholder: (context, url) {
                      return const BuildShimmerEffect();
                    },
                    errorWidget: (context, url, error) {
                      return Image.network(
                        userDataInitializer.picture!,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return const BuildShimmerEffect();
                        },
                        errorBuilder: (_, __, ___) =>
                            const BuildShimmerEffect(),
                      );
                    },
                  )),
                ),
              ),
        title: Text(
          userDataInitializer.name!,
          style: const TextStyle(
              color: Color.fromARGB(255, 255, 255, 255), fontSize: 20),
        ),
      ),
    );
  }

  Widget buildList({
    required List<DrawerItems> items,
  }) {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return buildMenuItem(
            text: item.title, icon: item.icon, action: item.action);
      },
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    required String? action,
  }) {
    final color = Color.fromARGB(255, 255, 255, 255);
    final leading = Icon(
      icon,
      color: color,
    );
    return ListTile(
      leading: leading,
      title: Text(
        text,
        style: TextStyle(color: color, fontSize: 18),
      ),
      onTap: () {
        GoRouter.of(context).push('/$action');
      },
    );
  }

  Widget buildLoginLogout({
    required String text,
    required IconData icon,
    required VoidCallback? action,
  }) {
    final color = Color.fromARGB(255, 255, 255, 255);
    final leading = Icon(
      icon,
      color: color,
    );
    return ListTile(
      leading: leading,
      title: Text(
        text,
        style: TextStyle(color: color, fontSize: 18),
      ),
      onTap: action,
    );
  }

  @override
  Widget build(BuildContext context) {
    return drawer();
  }
}

class DrawerItems {
  final String title;
  final IconData icon;
  final String action;
  const DrawerItems(
      {required this.icon, required this.title, required this.action});
}

final itemsBrows = [
  //DrawerItems(title: 'Home', icon: Icons.home, action: null),
  const DrawerItems(
      title: 'Favorites', icon: Icons.favorite, action: RoutsConst.favRout),
  const DrawerItems(
      title: 'Pending',
      icon: Icons.pending_actions,
      action: RoutsConst.pendingRout),
  const DrawerItems(
      title: 'Purchased',
      icon: Icons.paid_sharp,
      action: RoutsConst.purchasedRout),
  const DrawerItems(
      title: 'Help chat', icon: Icons.chat, action: RoutsConst.helpRout),
];

final itemsServices = [
  const DrawerItems(
      title: 'Online Market',
      icon: Icons.store_rounded,
      action: RoutsConst.onlineMarket),
  const DrawerItems(
      title: 'Dropshipping',
      icon: Icons.delivery_dining,
      action: RoutsConst.dropshipRout),
  const DrawerItems(
      title: 'Affiliate Marketing',
      icon: Icons.link,
      action: RoutsConst.affiRout),
];

final itemsSettings = [
  const DrawerItems(
      title: 'Settings', icon: Icons.settings, action: RoutsConst.settingsRout),
  const DrawerItems(
      title: 'Support',
      icon: Icons.contact_support,
      action: RoutsConst.supportRout),
];
