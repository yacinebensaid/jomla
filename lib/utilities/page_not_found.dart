// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class PageNotFound extends StatelessWidget {
  final String? errortexr;
  const PageNotFound({
    Key? key,
    this.errortexr,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(errortexr ?? 'page not found'),
      ),
    );
  }
}
