import 'package:flutter/material.dart';
import 'package:jomla/view/search/search.dart';

class MyCustomAppBar extends AppBar {
  final VoidCallback goToProfile;
  List following;
  bool isAdmin;
  final BuildContext context;
  MyCustomAppBar(
      {super.key,
      required this.context,
      required this.isAdmin,
      required this.following,
      required this.goToProfile})
      : super(
          backgroundColor:
              const Color.fromARGB(255, 28, 26, 26).withOpacity(1.0),
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(
                      context: context,
                      delegate: CustumSearchDeligate(
                          isAdmin: isAdmin,
                          following: following,
                          goToProfile: goToProfile));
                },
                icon: const Icon(
                  Icons.search,
                )),
          ],
        );
}
