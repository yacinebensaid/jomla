import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jomla/services/crud/userdata_service.dart';
import 'package:jomla/view/settings/settings_view.dart';

class NormalUserInfos extends StatefulWidget {
  final bool fromNav;
  final UserData userdata;
  const NormalUserInfos({
    super.key,
    required this.userdata,
    required this.fromNav,
  });

  @override
  State<NormalUserInfos> createState() => _UserInfosState();
}

class _UserInfosState extends State<NormalUserInfos> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SafeArea(
            child: SizedBox(
              height: !widget.fromNav ? kToolbarHeight : 30,
              child: !widget.fromNav
                  ? Row(
                      children: [
                        SizedBox(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  const Color.fromARGB(255, 240, 240, 240),
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: SvgPicture.asset(
                              "assets/icons/Back ICon.svg",
                              height: 15,
                            ),
                          ),
                        ),
                        const Spacer(),
                        dropDownMenu(context),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey,
                child: Icon(
                  CupertinoIcons.person,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Hi, ',
                    style: TextStyle(
                      color: Colors.grey[500], // sets text color to gray
                      fontWeight: FontWeight.bold, // sets font weight to normal
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    '${widget.userdata.name}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SettingsView(),
                ));
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10), // Set rounded corner radius
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 100,
                    vertical: 8), // Increase padding to make the button larger
                textStyle: const TextStyle(fontSize: 18), // Increase font size
              ),
              child: const Text(
                'Settings',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dropDownMenu(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) async {},
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'signal',
          child: Text('Signal Profile'),
        ),
      ].toList(),
    );
  }
}
