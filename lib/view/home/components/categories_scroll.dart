import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jomla/constants/const_routs.dart';

class BuildCategories extends StatefulWidget {
  const BuildCategories({super.key});

  @override
  State<BuildCategories> createState() => _BuildCategoriesState();
}

class _BuildCategoriesState extends State<BuildCategories> {
  final ScrollController _scrollController = ScrollController();
  bool _showBackIcon = false;
  bool _showForwardIcon = true;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      // Step 2: Update the _showBackIcon variable based on the scroll offset
      setState(() {
        _showBackIcon = _scrollController.offset > 0;
        _showForwardIcon = _scrollController.position.extentAfter > 0;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 100,
            child: Stack(
              children: [
                ShaderMask(
                  shaderCallback: (Rect rect) {
                    if (!_showBackIcon) {
                      return const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.black,
                          Colors.transparent,
                        ],
                        stops: [0.9, 1],
                      ).createShader(rect);
                    } else if (!_showForwardIcon) {
                      return const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.transparent,
                          Colors.black,
                        ],
                        stops: [0.0, 0.1],
                      ).createShader(rect);
                    } else {
                      return const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.transparent,
                          Colors.black,
                          Colors.black,
                          Colors.transparent
                        ],
                        stops: [0.0, 0.05, 0.95, 1.0],
                      ).createShader(rect);
                    }
                  },
                  blendMode: BlendMode.dstIn,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ListView.builder(
                      shrinkWrap: true,
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CategoriesForHome(
                          image: categories[index]['image'],
                          category: categories[index]['name'],
                          press: () {
                            GoRouter.of(context).pushNamed(
                              RoutsConst.subcatRout,
                              pathParameters: {
                                'sub_cat': categories[index]['name']
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                if (kIsWeb && _showBackIcon)
                  Positioned(
                    top: 30,
                    left: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: Offset(0, 1),
                            blurRadius: 10,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () {
                          _scrollController.animateTo(
                            _scrollController.offset - 150,
                            curve: Curves.linear,
                            duration: const Duration(milliseconds: 200),
                          );
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_new_sharp,
                          size: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                if (kIsWeb && _showForwardIcon)
                  Positioned(
                    top: 30,
                    right: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: Offset(0, 1),
                            blurRadius: 10,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () {
                          _scrollController.animateTo(
                            _scrollController.offset + 150,
                            curve: Curves.linear,
                            duration: const Duration(milliseconds: 200),
                          );
                        },
                        icon: Icon(
                          Icons.arrow_forward_ios_sharp,
                          size: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}

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
  {'name': 'Books', 'image': "assets/images/categories_imgs/books.jpg"},
  {
    'name': 'Industrial',
    'image': "assets/images/categories_imgs/electricity.jpeg"
  },
  {'name': 'Food', 'image': "assets/images/categories_imgs/Food.jpg"},
];

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
      padding: const EdgeInsets.only(left: 10),
      child: GestureDetector(
        onTap: press,
        child: SizedBox(
          width: 150,
          height: 100,
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
                          style: const TextStyle(
                            fontSize: 18,
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
