// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:jomla/utilities/reusable.dart';

import 'components/body.dart';

class ExploreView extends StatefulWidget {
  ExploreView({
    Key? key,
  }) : super(key: key);

  @override
  State<ExploreView> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ExploreView>
    with AutomaticKeepAliveClientMixin<ExploreView> {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: CustomAppBarSubPages(
        onBackButtonPressed: null,
        title: 'Explore',
      ),
      body: Body(),
    );
  }
}
