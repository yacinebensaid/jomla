// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:jomla/utilities/reusable.dart';
import 'components/no_fba.dart';

class OnlineMarket extends StatefulWidget {
  const OnlineMarket({
    Key? key,
  }) : super(key: key);

  @override
  State<OnlineMarket> createState() => _OnlineMarketState();
}

class _OnlineMarketState extends State<OnlineMarket> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarSubPages(
        onBackButtonPressed: () => Navigator.of(context).pop(),
        title: 'Online Market',
      ),
      body: Container(
        color: Color.fromARGB(255, 255, 255, 255),
        child: NotOnlineMarket(),
      ),
    );
  }
}
