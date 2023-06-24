import 'package:flutter/material.dart';
import 'package:jomla/view/search/search.dart';
import '../../size_config.dart';
import 'components/body.dart';

class HomeView extends StatefulWidget {
  final List following;
  final bool isAdmin;
  final String? userType;
  final VoidCallback goToProfile;
  final VoidCallback refresh;
  final VoidCallback goToExplore;
  final VoidCallback opendrawer;

  const HomeView(
      {Key? key,
      required this.goToExplore,
      required this.opendrawer,
      required this.userType,
      required this.isAdmin,
      required this.refresh,
      required this.following,
      required this.goToProfile})
      : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  void goToExplore() {
    widget.goToExplore();
  }

  void opendrawer() {
    widget.opendrawer();
  }

  bool _isAppBarTransparent = true;

  void _updateAppBarState(bool isAppBarTransparent) {
    setState(() {
      _isAppBarTransparent = isAppBarTransparent;
    });
  }

  Future<void> _onRefresh() async {
    // Wait for a short delay to give the user time to see the loading animation
    await Future.delayed(Duration(milliseconds: 500));

    // Navigate to the HomeView again and replace the current route with the new one
    widget.refresh;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Stack(
          children: [
            Scaffold(
              body: Body(
                userType: widget.userType,
                goToProfile: widget.goToProfile,
                following: widget.following,
                isAdmin: widget.isAdmin,
                toExplore: goToExplore,
                updateAppBarState: _updateAppBarState,
              ),
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            ),
            Container(
              height: 55,
              width: SizeConfig.screenWidth,
              color: Colors.transparent.withOpacity(0.0),
              child: AppBar(
                elevation: 0,
                backgroundColor: _isAppBarTransparent
                    ? Colors.transparent.withOpacity(0.0)
                    : const Color.fromARGB(255, 28, 26, 26),
                leading: IconButton(
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    opendrawer();
                  },
                ),
                actions: [
                  IconButton(
                    padding: const EdgeInsets.only(right: 10),
                    style: IconButton.styleFrom(foregroundColor: Colors.white),
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      showSearch(
                          context: context,
                          delegate: CustumSearchDeligate(
                            goToProfile: widget.goToProfile,
                            isAdmin: widget.isAdmin,
                            following: widget.following,
                          ));
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
