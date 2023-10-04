// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:jomla/utilities/reusable.dart';

import 'components/not_affiliate.dart';

class AffiliateMarketing extends StatefulWidget {
  const AffiliateMarketing({
    Key? key,
  }) : super(key: key);

  @override
  State<AffiliateMarketing> createState() => _AffiliateMarketingState();
}

class _AffiliateMarketingState extends State<AffiliateMarketing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarSubPages(
        onBackButtonPressed: () => Navigator.of(context).pop(),
        title: 'Affiliate Marketing',
      ),
      body: Container(
        color: Color.fromARGB(255, 255, 255, 255),
        child: NotAffiliate(),
      ),
    );
  }
}
