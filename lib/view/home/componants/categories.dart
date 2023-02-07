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
  const Categories({super.key});

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
                ),
              ));
        },
      ),
    );
  }
}
