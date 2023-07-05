// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'components/not_dropshiper.dart';

class Dropship extends StatefulWidget {
  final String? userType;
  final VoidCallback goToProfile;
  const Dropship({
    Key? key,
    required this.goToProfile,
    required this.userType,
  }) : super(key: key);

  @override
  State<Dropship> createState() => _DropshipPayState();
}

class _DropshipPayState extends State<Dropship> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Color(0xFFF5F6F9),
          child: NotDropshiper(
            userType: widget.userType,
            goToProfile: widget.goToProfile,
          ),
        ),
      ),
    );
  }
}