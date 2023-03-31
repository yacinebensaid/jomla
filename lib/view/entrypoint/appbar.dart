import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jomla/view/search/search.dart';

class MyCustomAppBar extends AppBar {
  final BuildContext context;
  MyCustomAppBar({required this.context})
      : super(
          title: SizedBox(
            height: 37.h,
            child: Image.asset('assets/images/jomla logo1 no-slogon croped.png',
                fit: BoxFit.contain),
          ),
          centerTitle: true,
          backgroundColor: Color.fromRGBO(0, 0, 0, 0),
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(
                      context: context, delegate: CustumSearchDeligate());
                },
                icon: Icon(Icons.search)),
          ],
        );
}
