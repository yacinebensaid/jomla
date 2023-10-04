import 'package:flutter/material.dart';
import 'package:jomla/services/providers.dart';
import 'package:jomla/view/settings/components/dropship_settings.dart';
import 'package:jomla/view/settings/components/general_settings.dart';
import 'package:jomla/view/settings/components/security_settings.dart';
import 'package:provider/provider.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
                return GeneralSettings();
              })));
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'General Settings',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                )
              ],
            ),
          ),
          Provider.of<UserDataInitializer>(context, listen: false)
                      .getUserData!
                      .user_type ==
                  'dropshipper'
              ? Column(
                  children: [
                    const Divider(
                      thickness: 0.75,
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: ((context) => DropshipSettings(
                                  dropshipID: Provider.of<UserDataInitializer>(
                                          context,
                                          listen: false)
                                      .getUserData!
                                      .dropshipperID!,
                                ))));
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Dropship Settings',
                            style: TextStyle(
                                fontSize: 19, fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                          )
                        ],
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
          const Divider(
            thickness: 0.75,
            height: 30,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: ((context) => ChangePasswordPage())));
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Security Settings',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
