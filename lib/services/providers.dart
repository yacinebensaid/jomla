import 'package:flutter/material.dart';
import 'package:jomla/services/auth/auth_service.dart';
import 'package:jomla/services/auth/auth_user.dart';
import 'package:jomla/services/crud/pcf_service.dart';
import 'package:jomla/services/crud/userdata_service.dart';

class UserDataInitializer with ChangeNotifier {
  String? name;
  String user_type = 'normal';
  String? phoneNumber;
  String? description;
  String? image;
  String? dropshipperID;
  List following = [];
  bool isAdmin = false;
  UserData? userdata;
  List? owned_products;
  String? userUid;
  late Stream<UserData?> userDataStream;

  UserDataInitializer({required AuthUser? user}) {
    if (user != null) {
      String? userUID = user.uid;
      userDataStream = DataService.getUserDataStream(userUID);
      userDataStream.listen((userData) {
        if (userData != null) {
          userUid = userData.id;
          userdata = userData;
          following = userData.following;
          isAdmin = userData.isAdmin;
          image = userData.picture;
          description = userData.description;
          name = userData.name;
          dropshipperID = userData.dropshipperID;
          owned_products = userData.owned_products;
          phoneNumber = userData.phoneNumber;
          user_type = userData.user_type;
        }
      });
    }
  }

  UserData? get getUserData => userdata;
  String? get getName => name;
  String? get getUid => userUid;
  String get getUserType => user_type;
  String? get getPhoneNumber => phoneNumber;
  String? get getDescription => description;
  String? get getImage => image;
  String? get getDropshipperID => dropshipperID;
  List get getFollowing => following;
  bool get getIsAdmin => isAdmin;
  List? get getOwnedProducts => owned_products;
}

class CheckedCartProducts with ChangeNotifier {
  Map<String, CartProduct> cartItemsMap =
      {}; // key - product id, value- quantity in the cart
  num total_price = 0;
  void updateCheckedProducts(
      {required Map<String, CartProduct> newCheckedMap}) {
    num _total = 0;
    cartItemsMap = newCheckedMap;
    newCheckedMap.forEach((key, value) {
      _total = _total + value.total_price;
    });
    total_price = _total;
  }

  Map<String, CartProduct> get getChackeMap => cartItemsMap;
  num get getTotalPrice => total_price;
}

class HomeFunc with ChangeNotifier {
  late PageController pageController = PageController(initialPage: 0);
  late GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void initialize(
      {required PageController page_Controller,
      required GlobalKey<ScaffoldState> scaffoldKey}) {
    pageController = page_Controller;
    _scaffoldKey = scaffoldKey;
  }

  void opendrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  void goToExplore() {
    UserDataInitializer inst =
        UserDataInitializer(user: AuthService.firebase().currentUser);
    inst.getUserType != 'market'
        ? pageController.jumpToPage(2)
        : pageController.jumpToPage(3);
  }

  void goToProfile() {
    UserDataInitializer inst =
        UserDataInitializer(user: AuthService.firebase().currentUser);
    inst.getUserType != 'market'
        ? pageController.jumpToPage(3)
        : pageController.jumpToPage(4);
  }
}
