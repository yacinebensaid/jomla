import 'package:flutter/material.dart';
import 'package:jomla/constants/routes.dart';
import 'package:jomla/size_config.dart';
import 'package:jomla/view/subcat_details/subcat_details_view.dart';

List<Map<String, dynamic>> categories = [
  {
    'name': 'Clothing',
    'image': "assets/images/categories_imgs/Insta @marianaftm.jpg"
  },
  {
    'name': 'Accessories',
    'image': "assets/images/categories_imgs/accessoire.jpg"
  },
  {
    'name': 'Electronics',
    'image': "assets/images/categories_imgs/electronics.jpg"
  },
  {'name': 'Home', 'image': "assets/images/categories_imgs/home.jpg"},
  {'name': 'Kitchen', 'image': "assets/images/categories_imgs/kitchen.jpg"},
  {'name': 'Beauty', 'image': "assets/images/categories_imgs/beauty.jpg"},
  {'name': 'Sports', 'image': "assets/images/categories_imgs/sports.jpg"},
  {'name': 'more', 'image': "assets/images/categories_imgs/More.jpg"},
];

@override
Widget buildCategories(BuildContext context, VoidCallback toExplore) {
  return SizedBox(
    height: getProportionateScreenHeight(100),
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categories.length,
      itemBuilder: (BuildContext context, int index) {
        if (categories[index]['name'] == 'more') {
          return CategoriesForHome(
            image: categories[index]['image'],
            category: categories[index]['name'],
            press: () {
              toExplore();
            },
          );
        }
        return CategoriesForHome(
          image: categories[index]['image'],
          category: categories[index]['name'],
          press: () {
            Navigator.pushNamed(context, subcatRout,
                arguments: MainCatKey(maincatvalue: categories[index]['name']));
          },
        );
      },
    ),
  );
}

class CategoriesForHome extends StatelessWidget {
  const CategoriesForHome({
    Key? key,
    required this.category,
    required this.image,
    required this.press,
  }) : super(key: key);

  final String category, image;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(10)),
      child: GestureDetector(
        onTap: press,
        child: SizedBox(
          width: getProportionateScreenWidth(150),
          height: getProportionateScreenHeight(100),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: AssetImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        const Color(0xFF343434).withOpacity(0.4),
                        const Color(0xFF343434).withOpacity(0.15),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 10,
                  child: Text.rich(
                    TextSpan(
                      style: const TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: "$category\n",
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(18),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
