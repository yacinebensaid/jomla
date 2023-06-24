import 'package:flutter/material.dart';
import 'package:jomla/services/crud/userdata_service.dart';
import 'package:jomla/size_config.dart';
import 'package:jomla/view/add_product/adding_newproduct_view.dart';
import 'package:jomla/view/cart/cart_view.dart';
import 'package:jomla/view/components/appbar.dart';
import 'package:jomla/view/explore/explore.dart';
import 'package:jomla/view/home/homepage_view.dart';
import '../components/drawer.dart';
import '../profile/profile_view.dart';

class EntryPoint extends StatefulWidget {
  String uid;
  EntryPoint({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  int _selectedIndex = 0;
  final PageController pageController = PageController(initialPage: 0);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late String name = '', user_type = 'normal', phoneNumber = '', id;
  String? description;
  String? image;
  String? dropshipperID;
  late List following = [];
  late bool isAdmin = false;
  late List? owned_products;
  @override
  void initState() {
    super.initState();
    id = widget.uid;
    _initializeUserData();
  }

  void _initializeUserData() {
    Stream<UserData?> userDataStream =
        DataService.getUserDataStream(widget.uid);
    userDataStream.listen((userData) {
      if (userData != null) {
        setState(() {
          following = userData.following;
          isAdmin = userData.isAdmin;
          image = userData.picture;
          description = userData.description;
          name = userData.name;
          dropshipperID = userData.dropshipperID;
          owned_products = userData.owned_products;
          phoneNumber = userData.phoneNumber;
          user_type = userData.user_type;
        });
      }
    });
  }

  void onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    pageController.jumpToPage(index);
  }

  void goToExplore() {
    user_type != 'market'
        ? pageController.jumpToPage(2)
        : pageController.jumpToPage(3);
  }

  void goToProfile() {
    user_type != 'market'
        ? pageController.jumpToPage(3)
        : pageController.jumpToPage(4);
  }

  void opendrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  void goToHome() {
    if (pageController.page?.round() == 0) {
      setState(() {});
    } else {
      pageController.jumpToPage(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar: _selectedIndex == 1
          ? MyCustomAppBar(
              goToProfile: goToProfile,
              following: following,
              context: context,
              isAdmin: isAdmin,
            )
          : null,
      drawer: NavigationDrawer(
        userType: user_type,
        name: name,
        picture: image,
        image: image,
        dropshipID: dropshipperID,
        description: description,
        phoneNumber: phoneNumber,
        goToProfile: goToProfile,
        isAdmin: isAdmin,
        following: following,
      ),
      body: Stack(children: [
        PageView(
          controller: pageController,
          children: [
            HomeView(
              userType: user_type,
              refresh: goToHome,
              goToProfile: goToProfile,
              following: following,
              opendrawer: opendrawer,
              goToExplore: goToExplore,
              isAdmin: isAdmin,
            ), // pass the function here
            CartScreen(
              following: following,
              goToProfile: goToProfile,
              userType: user_type,
              isAdmin: isAdmin,
            ),
            user_type == 'market'
                ? AddProductPage()
                : ExploreView(
                    goToProfile: goToProfile,
                    following: following,
                    isAdmin: isAdmin,
                  ),
            user_type == 'market'
                ? ExploreView(
                    goToProfile: goToProfile,
                    following: following,
                    isAdmin: isAdmin,
                  )
                : ProfileScreen(
                    goToProfile: goToProfile,
                    userType: user_type,
                    fromNav: true,
                    following: following,
                    uid: id,
                    isAdmin: isAdmin,
                  ),
            if (user_type == 'market')
              ProfileScreen(
                goToProfile: goToProfile,
                userType: user_type,
                fromNav: true,
                following: following,
                uid: id,
                isAdmin: isAdmin,
              )
          ],
          //i don't want to return anything if the user_type != 'market'
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ]),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255).withOpacity(1.0),
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: '',
          ),
          if (user_type == 'market')
            const BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: '',
            ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_sharp),
            label: '',
          ),
        ],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 0, 0, 0),
        unselectedItemColor: Colors.grey,
        onTap: onTapped,
      ),
    );
  }
}
