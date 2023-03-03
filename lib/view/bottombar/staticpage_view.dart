import 'package:flutter/material.dart';
import 'package:jomla/view/explore/explore.dart';
import 'package:jomla/view/add_product/components/adding_newproduct_view.dart';
import 'package:jomla/view/home/homepage_view.dart';

import '../cart/cart_view.dart';
import '../profile/profile_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StaticPage extends StatefulWidget {
  const StaticPage({Key? key}) : super(key: key);

  @override
  _StaticPageState createState() => _StaticPageState();
}

class _StaticPageState extends State<StaticPage> {
  int _selectedIndex = 0;
  final List<Widget> _children = [
    const HomeView(),
    const CartScreen(),
    AddProductPage(),
    const ExploreView(),
    const ProfileScreen(),
  ];
  PageController pageController = PageController(initialPage: 0);

  void onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: _children,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: AppLocalizations.of(context)!.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_cart),
            label: AppLocalizations.of(context)!.cart,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.add),
            label: AppLocalizations.of(context)!.addproduct,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.explore),
            label: AppLocalizations.of(context)!.explore,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: AppLocalizations.of(context)!.profile,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        unselectedItemColor: Colors.grey,
        onTap: onTapped,
      ),
    );
  }
}
