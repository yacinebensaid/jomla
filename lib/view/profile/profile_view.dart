import 'package:flutter/material.dart';
import 'components/body.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Colors.transparent, // set the background color to transparent
        foregroundColor: Color.fromARGB(255, 116, 116, 116),
        elevation: 0, // set the elevation to 0 to remove the shadow
        centerTitle: true, // center the title text
        title: Text(AppLocalizations.of(context)!.profile),
      ),
      body: Body(),
    );
  }
}
