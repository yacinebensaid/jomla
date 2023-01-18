import 'package:flutter/material.dart';
import 'package:jomla/view/home/explore.dart';
import 'package:jomla/view/home/adding_product_view.dart';
import 'package:jomla/view/home/homepage_view.dart';

class StaticPage extends StatefulWidget {
  const StaticPage({super.key});

  @override
  State<StaticPage> createState() => _StaticPageState();
}

class _StaticPageState extends State<StaticPage> {
  int _selectedIndex = 0;
  final List<Widget> _children = [
    const HomeView(),
    const AddingProductView(),
    const ExploreView(),
  ];
  PageController pageController = PageController();
  void onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    //we can animate this by using animatetopage
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _children[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'add product',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: 'explore',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Color.fromARGB(255, 0, 0, 0),
          unselectedItemColor: Colors.grey,
          onTap: onTapped,
        ));
  }
}
