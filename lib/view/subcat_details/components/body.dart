import 'package:flutter/material.dart';
import 'package:jomla/view/subcat_details/components/card_rows.dart';
import '../../../size_config.dart';

class Body extends StatefulWidget {
  final String maincat;

  const Body({Key? key, required this.maincat}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          // Implement the refresh action here
          // For example, you can call setState to trigger a rebuild of the CardRows widget
          setState(() {});
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: getProportionateScreenWidth(20)),
              CardRows(maincat: widget.maincat),
            ],
          ),
        ),
      ),
    );
  }
}
