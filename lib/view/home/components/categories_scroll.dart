import 'package:flutter/material.dart';
import '../../../constants/routes.dart';

List<String> categories = [
  'Clothing',
  'Accessories',
  'Electronics',
  'Home',
  'Kitchen',
  'Beauty',
  'More...'
];

Map<int, String> indexPages = {};

class Categories extends StatelessWidget {
  const Categories({Key? key});

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
              onTap: (() => Navigator.of(context).pushNamedAndRemoveUntil(
                  indexPages[index]!, (route) => false)),
              child: Chip(
                label: Text(
                  categories[index],
                ),
                backgroundColor: Color(0xFF0074CC),
                labelStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 15.3,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
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
