import 'package:flutter/material.dart';

import 'header.dart';
import 'services.dart';

class Body extends StatefulWidget {
  final void Function(bool isAppBarTransparent) updateAppBarState;

  const Body({super.key, required this.updateAppBarState});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _scrollController = ScrollController();

  bool _isAppBarTransparent = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.offset <= kToolbarHeight) {
      if (!_isAppBarTransparent) {
        setState(() {
          _isAppBarTransparent = true;
        });
        widget.updateAppBarState(true);
      }
    } else {
      if (_isAppBarTransparent) {
        setState(() {
          _isAppBarTransparent = false;
        });
        widget.updateAppBarState(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      controller: _scrollController,
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          buildHeader(),
          Services(),
          SizedBox(height: 45),
        ],
      ),
    ));
  }
}
