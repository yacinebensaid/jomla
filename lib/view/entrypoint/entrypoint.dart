import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jomla/constants/const_routs.dart';
import 'package:jomla/constants/routes.dart';
import 'package:jomla/services/auth/auth_service.dart';
import 'package:jomla/services/providers.dart';
import 'package:jomla/size_config.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class EntryPoint extends StatefulWidget {
  final Widget child;
  const EntryPoint({super.key, required this.child});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  final PageController pageController = PageController(initialPage: 0);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController scrollController = ScrollController();
  int selectedIndex = 0;

  String? uid;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (AuthService.firebase().currentUser != null) {
      uid = AuthService.firebase().currentUser!.uid;
    }
  }

  void onTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        selectedIndex = index;
        GoRouter.of(context).go('/');
        break;
      case 1:
        selectedIndex = index;
        GoRouter.of(context).go('/explore');
        break;
      case 2:
        selectedIndex = index;

        GoRouter.of(context).go('/cart');
        break;
      case 3:
        selectedIndex = index;
        GoRouter.of(context).go('/profile/${uid}');

        break;

      default:
        MyAppRouter().router.namedLocation(RoutsConst.loginRout);
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<HomeFunc>(context).initialize(
        page_Controller: pageController,
        scrollController: scrollController,
        onTap: onTapped);
    SizeConfig().init(context);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        key: _scaffoldKey,
        body: widget.child,
        bottomNavigationBar: !kIsWeb
            ? Material(
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        color: Color.fromARGB(255, 190, 190, 190),
                        width: 1.5,
                      ),
                    ),
                  ),
                  child: TabBar(
                    indicator: CustomTabIndicator(),
                    labelColor: Color.fromARGB(255, 17, 176, 216),
                    indicatorWeight: 2.0,
                    indicatorPadding:
                        const EdgeInsets.symmetric(horizontal: 20),
                    tabs: const [
                      Tab(
                        child: Icon(Icons.home_outlined),
                      ),
                      Tab(
                        child: Icon(Icons.explore_outlined),
                      ),
                      Tab(
                        child: Icon(Icons.shopping_cart_outlined),
                      ),
                      Tab(
                        child: Icon(Icons.person_outlined),
                      ),
                    ],
                    unselectedLabelColor: Color.fromARGB(255, 77, 113, 133),
                    onTap: ((value) {
                      onTapped(context, value);
                    }),
                  ),
                ),
              )
            : null,
      ),
    );
  }
}

class CustomTabIndicator extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomTabIndicatorPainter(this, onChanged);
  }
}

class _CustomTabIndicatorPainter extends BoxPainter {
  final CustomTabIndicator decoration;

  _CustomTabIndicatorPainter(this.decoration, VoidCallback? onChanged)
      : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Rect rect = offset & configuration.size!;
    final Paint paint = Paint();
    paint.color = const Color.fromARGB(255, 19, 164, 241); // Indicator color
    paint.style = PaintingStyle.fill;

    // Adjust the Y-coordinate to place the indicator above the TabBar
    final double indicatorY = rect.top - 2.0;

    canvas.drawRect(
        Rect.fromLTWH(rect.left, indicatorY, rect.width, 4.0), paint);
  }
}
