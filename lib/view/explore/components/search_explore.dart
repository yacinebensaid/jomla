// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:jomla/view/search/search.dart';

class SearchForExplore extends StatelessWidget {
  final VoidCallback goToProfile;
  List following;
  bool isAdmin;
  SearchForExplore({
    Key? key,
    required this.isAdmin,
    required this.following,
    required this.goToProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: GestureDetector(
        onTap: () {
          showSearch(
              context: context,
              delegate: CustumSearchDeligate(
                  isAdmin: isAdmin,
                  following: following,
                  goToProfile: goToProfile));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.grey,
              width: 0.4,
            ),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 50,
          child: Row(
            children: const [
              Icon(Icons.search),
              SizedBox(width: 10),
              Text(
                'Search...',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
