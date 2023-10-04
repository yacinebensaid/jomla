import 'package:flutter/material.dart';
import 'package:jomla/services/auth/auth_service.dart';
import 'package:jomla/services/auth/auth_user.dart';
import 'package:jomla/services/crud/pcf_service.dart';
import 'package:jomla/services/crud/userdata_service.dart';

class UserDataInitializer with ChangeNotifier {
  UserData? userData;
  Stream<UserData?>? userDataStream;
  void resetUser() async {
    userData = await DataService.getUserDataStream('').first;
  }

  void inituser() {
    AuthUser? user = AuthService.firebase().currentUser;
    if (user != null) {
      String? userUID = user.uid;
      Stream<UserData?>? stream = DataService.getUserDataStream(userUID);
      userDataStream = stream;
      stream.listen(
        (event) {
          userData = event!;
        },
      );
    } else {
      resetUser();
    }
  }

  UserDataInitializer() {
    AuthUser? user = AuthService.firebase().currentUser;
    if (user != null) {
      String? userUID = user.uid;
      Stream<UserData?>? stream = DataService.getUserDataStream(userUID);
      userDataStream = stream;
      stream.listen(
        (event) {
          userData = event!;
        },
      );
    } else {
      resetUser();
    }
  }

  UserData? get getUserData => userData;
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

  late void Function(BuildContext context, int index) _onTapNavigation;
  void initialize({
    required PageController page_Controller,
    required void Function(BuildContext context, int index) onTap,
    required ScrollController scrollController,
  }) {
    pageController = page_Controller;
    _onTapNavigation = onTap;
  }

  void onTapNavigation(BuildContext context, int index) {
    _onTapNavigation(context, index);
  }

  void goToExplore() {
    UserDataInitializer().userData != null &&
            UserDataInitializer().userData != 'market'
        ? pageController.jumpToPage(2)
        : pageController.jumpToPage(3);
  }

  void goToProfile() {
    UserDataInitializer().userData != null &&
            UserDataInitializer().userData != 'market'
        ? pageController.jumpToPage(3)
        : pageController.jumpToPage(4);
  }
}
