import '../../constants/routes.dart';

class SideBarAsset {
  final String title;
  final press;
  SideBarAsset({
    required this.title,
    required this.press,
  });
}

List<SideBarAsset> sideMenu1 = [
  SideBarAsset(
    title: "Home",
    press: enterypointRout,
  ),
  SideBarAsset(
    title: "Favorites",
    press: () {},
  ),
  SideBarAsset(
    title: "Pending",
    press: () {},
  ),
  SideBarAsset(
    title: "Purchased",
    press: () {},
  ),
  SideBarAsset(
    title: "Help chat",
    press: () {},
  ),
];

List<SideBarAsset> sideMenu2 = [
  SideBarAsset(
    title: "Storage",
    press: () {},
  ),
  SideBarAsset(
    title: "Delivery",
    press: () {},
  ),
  SideBarAsset(
    title: "Offers",
    press: () {},
  ),
];

List<SideBarAsset> sideMenu3 = [
  SideBarAsset(
    title: "Settings",
    press: () {},
  ),
  SideBarAsset(
    title: "Support",
    press: () {},
  ),
  SideBarAsset(
    title: "Log out",
    press: "",
  ),
];
