import 'package:flutter/material.dart';
import 'package:jomla/view/search/search.dart';

class MyCustomAppBar extends AppBar {
  final BuildContext context;
  MyCustomAppBar({super.key, required this.context})
      : super(
          backgroundColor:
              const Color.fromARGB(255, 28, 26, 26).withOpacity(1.0),
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(
                      context: context, delegate: CustumSearchDeligate());
                },
                icon: const Icon(
                  Icons.search,
                )),
          ],
        );
}
