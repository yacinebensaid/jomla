import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jomla/view/explore/explore.dart';
import 'package:jomla/view/add_product/components/adding_newproduct_view.dart';
import 'package:jomla/view/home/homepage_view.dart';
import '../components/drawer.dart';
import '../cart/cart_view.dart';
import '../profile/profile_view.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  int _selectedIndex = 0;
  final PageController pageController = PageController(initialPage: 0);

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
      backgroundColor: const Color(0xFF00235B),
      resizeToAvoidBottomInset: false,
      extendBody: true,
      appBar: AppBar(
        title: SizedBox(
          height: 37,
          child: Image.asset('assets/images/jomla logo1 no-slogon croped.png',
              fit: BoxFit.contain),
        ),
        shadowColor: Colors.black12,
        centerTitle: true,
        backgroundColor: const Color(0xFF00235B),
      ),
      drawer: const NavigationDrawer(),
      body: PageView(
        controller: pageController,
        children: [
          const HomeView(),
          const CartScreen(),
          AddProductPage(),
          const ExploreView(),
          const ProfileScreen(),
        ],
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          color: null,
          height: 65,
          padding: const EdgeInsets.all(0),
          margin: const EdgeInsets.symmetric(horizontal: 7),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black38, spreadRadius: 0, blurRadius: 10)
              ]),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(24)),
            child: Theme(
              data: Theme.of(context).copyWith(
                canvasColor: const Color(0xFF00235B).withOpacity(0.85),
                shadowColor: null,
              ),
              child: BottomNavigationBar(
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
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.grey,
                onTap: onTapped,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
