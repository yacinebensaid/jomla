import 'package:flutter/material.dart';
import 'package:jomla/constants/routes.dart';
import 'package:jomla/view/explore/explore.dart';
import 'package:jomla/view/subcat_details/subcat_details_view.dart';

List<String> categories = [
  'Clothing',
  'Accessories',
  'Electronics',
  'Home',
  'Kitchen',
  'Beauty',
  'More...'
];

List indexPages = [
  'Clothing',
  'Accessories',
  'Electronics',
  'Home',
  'Kitchen',
  'Beauty',
  ExploreView()
];

class Categories extends StatelessWidget {
  final VoidCallback goToExplore;
  const Categories({super.key, required this.goToExplore});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: const EdgeInsets.all(5.0),
            child: InkWell(
              onTap: (() {
                if (categories[index] == 'More...') {
                  GestureDetector(onTap: goToExplore);
                } else {
                  Navigator.pushNamed(
                    context,
                    subcatRout,
                    arguments: MainCatKey(maincatvalue: indexPages[index]),
                  );
                }
              }),
              child: Chip(
                label: Text(
                  categories[index],
                ),
                backgroundColor: Color.fromARGB(255, 174, 220, 255),
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 0, 51, 133),
                  fontSize: 15.3,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: Color.fromARGB(255, 117, 218, 255),
                    width: 0.9,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
