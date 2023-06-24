import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jomla/services/crud/userdata_service.dart';

class NormalUserInfos extends StatefulWidget {
  bool fromNav;
  final VoidCallback onBackButtonPressed;
  String uid;
  NormalUserInfos(
      {super.key,
      required this.uid,
      required this.fromNav,
      required this.onBackButtonPressed});

  @override
  State<NormalUserInfos> createState() => _UserInfosState();
}

class _UserInfosState extends State<NormalUserInfos> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DataService.getUserDataStream(widget.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final fullname = snapshot.data!.name;
          return Container(
            padding: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SafeArea(
                  child: SizedBox(
                    height: !widget.fromNav ? kToolbarHeight : 30.h,
                    child: !widget.fromNav
                        ? Row(
                            children: [
                              SizedBox(
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: const Color.fromARGB(
                                        255, 240, 240, 240),
                                    padding: EdgeInsets.zero,
                                  ),
                                  onPressed: widget.onBackButtonPressed,
                                  child: SvgPicture.asset(
                                    "assets/icons/Back ICon.svg",
                                    height: 15.h,
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
                    CircleAvatar(
                      radius: 30.w,
                      backgroundColor: Colors.grey,
                      child: Icon(
                        CupertinoIcons.person,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Hi, ',
                          style: TextStyle(
                            color: Colors.grey[500], // sets text color to gray
                            fontWeight:
                                FontWeight.bold, // sets font weight to normal
                            fontSize: 20.w,
                          ),
                        ),
                        Text(
                          '$fullname',
                          style: TextStyle(
                            fontSize: 20.w,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: ElevatedButton(
                    onPressed: () async {},
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10), // Set rounded corner radius
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 120.w,
                          vertical: 8
                              .h), // Increase padding to make the button larger
                      textStyle:
                          TextStyle(fontSize: 18.w), // Increase font size
                    ),
                    child: const Text(
                      'Settings',
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
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



/*the button isn't changing instantly after clicking on it, the data is being streamd the the numer of followers is getting updated but i want from the color of the button to get changed when i press it without going out of the page then coming back 

 */

/*Row(
                          children: [
                            Text(
                              'Tel:',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              onTap: () async {
                                await launchUrl(_url);
                              },
                              child: Text(
                                userPhonenumber,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.location_on),
                            SizedBox(width: 8),
                            Text(
                              'Oran, Algeria',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ), */
