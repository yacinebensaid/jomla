import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jomla/constants/const_routs.dart';
import 'package:jomla/services/providers.dart';
import 'package:jomla/view/favourite/favourite.dart';
import 'package:jomla/view/pending/pending_view.dart';
import 'package:jomla/view/purchased/purchased_view.dart';
import 'package:jomla/view/settings/settings_view.dart';
import 'package:jomla/view/support_staff_orientation.dart';
import 'package:provider/provider.dart';
import '../../constants/routes.dart';
import '../../services/auth/auth_service.dart';

class NavigationDrawer extends StatelessWidget {
  NavigationDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: const Color(0xFFF5F6F9),
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Column(
              children: [
                const SizedBox(
                  height: 8,
                ),
                if (AuthService.firebase().currentUser != null)
                  ListTile(
                    leading:
                        Provider.of<UserDataInitializer>(context, listen: false)
                                    .getImage ==
                                null
                            ? const CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.grey,
                                child: Icon(
                                  CupertinoIcons.person,
                                  color: Colors.white,
                                ),
                              )
                            : CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.grey,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(60),
                                  child: Center(
                                    child: Image.network(
                                      Provider.of<UserDataInitializer>(context,
                                              listen: false)
                                          .getImage!,
                                      fit: BoxFit.cover,
                                      width: 44,
                                      height: 44,
                                    ),
                                  ),
                                ),
                              ),
                    title: Text(
                      Provider.of<UserDataInitializer>(context, listen: false)
                          .getName!,
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                const Divider(
                  height: 10,
                  thickness: 0.15,
                  color: Colors.black,
                ),
                ListTile(
                    leading: const Icon(Icons.home, color: Colors.black),
                    title: const Text(
                      'Home',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    onTap: () {
                      /*Navigator.of(context).pushReplacementNamed(EntryPoint());*/
                    }),
                ListTile(
                  title: Text(
                    "Browse".toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.black),
                  ),
                ),
                ListTile(
                    leading: Icon(
                      Icons.favorite,
                      color: Colors.grey[600],
                    ),
                    title: Text(
                      'Favorites',
                      style: TextStyle(color: Colors.grey[600], fontSize: 18),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) => FavouriteView())));
                    }),
                ListTile(
                    leading:
                        Icon(Icons.pending_actions, color: Colors.grey[600]),
                    title: Text(
                      'Pending',
                      style: TextStyle(color: Colors.grey[600], fontSize: 18),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) => PendingScreen())));
                    }),
                ListTile(
                    leading: Icon(Icons.paid_sharp, color: Colors.grey[600]),
                    title: Text(
                      'Purchased',
                      style: TextStyle(color: Colors.grey[600], fontSize: 18),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) => PurchasedScreen())));
                    }),
                ListTile(
                    leading: Icon(Icons.chat, color: Colors.grey[600]),
                    title: Text(
                      'Help chat',
                      style: TextStyle(color: Colors.grey[600], fontSize: 18),
                    ),
                    onTap: () {}),
                ListTile(
                  title: Text(
                    "services".toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.black),
                  ),
                ),
                ListTile(
                    leading:
                        Icon(Icons.storage_rounded, color: Colors.grey[600]),
                    title: Text(
                      'Storage',
                      style: TextStyle(color: Colors.grey[600], fontSize: 18),
                    ),
                    onTap: () {}),
                ListTile(
                    leading: Icon(Icons.delivery_dining_rounded,
                        color: Colors.grey[600]),
                    title: Text(
                      'Delivery',
                      style: TextStyle(color: Colors.grey[600], fontSize: 18),
                    ),
                    onTap: () {
                      /*Navigator.of(context).push(MaterialPageRoute(
                    builder: ((context) => ShippingServicePage())));*/
                    }),
                ListTile(
                    leading: Icon(Icons.more_horiz, color: Colors.grey[600]),
                    title: Text(
                      'Offers',
                      style: TextStyle(color: Colors.grey[600], fontSize: 18),
                    ),
                    onTap: () {
                      print(Provider.of<UserDataInitializer>(context,
                              listen: false)
                          .getName);
                    }),
                ListTile(
                  title: Text(
                    "settings".toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.black),
                  ),
                ),
                ListTile(
                    leading: Icon(Icons.settings, color: Colors.grey[600]),
                    title: Text(
                      'Settings',
                      style: TextStyle(color: Colors.grey[600], fontSize: 18),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) => SettingsView())));
                    }),
                ListTile(
                    leading:
                        Icon(Icons.contact_support, color: Colors.grey[600]),
                    title: Text(
                      'Support',
                      style: TextStyle(color: Colors.grey[600], fontSize: 18),
                    ),
                    /*
              Navigator.of(context).push(MaterialPageRoute(
                              builder: ((context) =>
                                  const StaffOrientationPage())));
                                  DataService.getUserDataForOrder(userUID)
              */
                    onTap: () async {
                      if (Provider.of<UserDataInitializer>(context,
                              listen: false)
                          .getIsAdmin) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: ((context) =>
                                const StaffOrientationPage())));
                      } else {}
                    }),
                ListTile(
                    leading:
                        Icon(Icons.logout_outlined, color: Colors.grey[600]),
                    title: Text(
                      'Log out',
                      style: TextStyle(color: Colors.grey[600], fontSize: 18),
                    ),
                    onTap: () async {
                      final logoutOption = await showLogoutDialog(context);
                      if (logoutOption) {
                        await AuthService.firebase().logOut();
                      }
                    })
              ],
            ),
          ],
        )),
      ),
    );
  }
}

Widget buildHeader(BuildContext context) => Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
    );

Future<bool> showLogoutDialog(BuildContext context) {
  //showdialog is a widgit that has context and builder
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('LOG OUT!'),
        content: const Text('sure'),
        actions: [
          //the role of all of this is to eather return flase for cancelling and true for sign out
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('cancel')),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('log out')),
        ],
      );
    },
    //we must add 'then' because the return of the showDialog is an optional boolean because the user can prees the return button on his phone instead of the cancel
    // so u eather return a value or false if there is no value
  ).then((value) => value ?? false);
}
/*EntryPoint(
                      id: userdata.id,
                      isAdmin: userdata.isAdmin,
                      isDropshipper: userdata.isDropshipper,
                      name: userdata.name,
                      owned_products: userdata.owned_products,
                      phonenumber: userdata.phoneNumber,
                      user_type: userdata.user_type,
                    )
                    
                    
                    MaterialPageRoute(
                    builder: ((context) =>  EntryPoint(
                      id: userdata!.id,
                      isAdmin: userdata.isAdmin,
                      isDropshipper: userdata.isDropshipper,
                      name: userdata.name,
                      owned_products: userdata.owned_products,
                      phonenumber: userdata.phoneNumber,
                      user_type: userdata.user_type,
                    )))*/