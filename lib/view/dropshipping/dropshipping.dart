// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:jomla/utilities/reusable.dart';
import 'package:jomla/view/dropshipping/components/not_dropshipper.dart';

class Dropshipping extends StatefulWidget {
  const Dropshipping({
    Key? key,
  }) : super(key: key);

  @override
  State<Dropshipping> createState() => _DropshippingState();
}

class _DropshippingState extends State<Dropshipping> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarSubPages(
        onBackButtonPressed: () => Navigator.of(context).pop(),
        title: 'Dropshipping',
      ),
      body: Container(
        color: Color.fromARGB(255, 255, 255, 255),
        child: NotDropshipper(),
      ),
    );
  }
}
