import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jomla/services/auth/auth_service.dart';
import 'package:jomla/services/crud/userdata_service.dart';
import 'package:jomla/services/providers.dart';
import 'package:jomla/view/settings/settings_view.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class UserInfos extends StatefulWidget {
  bool fromNav;
  UserData userdata;
  UserInfos({
    super.key,
    required this.userdata,
    required this.fromNav,
  });

  @override
  State<UserInfos> createState() => _UserInfosState();
}

class _UserInfosState extends State<UserInfos> {
  bool _descriptionFieldExpanded = false;
  late bool _isFollowing;
  late UserData _userdata;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isFollowing = Provider.of<UserDataInitializer>(context, listen: false)
        .getFollowing
        .contains(widget.userdata.id);

    _userdata = widget.userdata;
    if (_userdata.user_type == 'market') {
      marketInfos(
        _userdata.name,
        _userdata.phoneNumber,
        _userdata.sales,
        _userdata.followers,
        _userdata.owned_products,
        _userdata.description,
      );
    } else {
      retrieveDropShip(widget.userdata.dropshipperID!);
    }
  }

  String fullname = '';
  String userPhonenumber = '';
  Uri _url = Uri.parse('tel:');
  List sales = [];
  List followers = [];
  List products = [];
  String description = '';

  void retrieveDropShip(String Id) async {
    DropshipperData? dropshipperData =
        await DataService.getDropshipperData(Id).first;
    setState(() {
      fullname = dropshipperData!.name;
      userPhonenumber = dropshipperData.phoneNumber;
      _url = Uri.parse('tel:$userPhonenumber');
      sales = dropshipperData.sales;
      followers = dropshipperData.followers;
      products = dropshipperData.owned_products;
      dropshipperData.description != null
          ? description = dropshipperData.description!
          : '';
    });
  }

  void marketInfos(String _fullname, String _userPhonenumber, List? _sales,
      List? _followers, List? _owned_products, String? _description) {
    fullname = _fullname;
    userPhonenumber = _userPhonenumber;
    _url = Uri.parse('tel:$userPhonenumber');
    _sales != null ? sales = _sales : [];
    _followers != null ? followers = _followers : [];
    _owned_products != null ? products = _owned_products : [];
    _description != null ? description = _description : '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                              foregroundColor:
                                  const Color.fromARGB(255, 240, 240, 240),
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 50.w,
                backgroundColor: Colors.grey,
                child: Icon(
                  CupertinoIcons.person,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 20.w,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    fullname,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22.w,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Row(
                    children: [
                      SizedBox(
                        width: 68.w,
                        child: Column(
                          children: [
                            Text(
                              '${products.length}', // Replace with actual number of products
                              style: TextStyle(
                                fontSize: 16.w,
                              ),
                            ),
                            Text(
                              'Products',
                              style: TextStyle(
                                fontSize: 15.w,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 18.w,
                      ),
                      SizedBox(
                        width: 68.w,
                        child: Column(
                          children: [
                            Text(
                              '${sales.length}', // Replace with actual number of sales
                              style: TextStyle(fontSize: 16.w),
                            ),
                            Text(
                              'Sales',
                              style: TextStyle(
                                fontSize: 15.w,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 18.w,
                      ),
                      SizedBox(
                        width: 68.w,
                        child: Column(
                          children: [
                            Text(
                              '${followers.length}', // Replace with actual number of followers
                              style: TextStyle(fontSize: 16.w),
                            ),
                            Text(
                              'Followers',
                              style: TextStyle(
                                fontSize: 15.w,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          description != ''
              ? Container(
                  padding: EdgeInsets.only(left: 10.w, top: 10.h, bottom: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 16.w,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: _descriptionFieldExpanded ? null : 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (description.trim().split('\n').length > 2)
                        _descriptionFieldExpanded != true
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _descriptionFieldExpanded = true;
                                  });
                                },
                                child: Text(
                                  '...see more',
                                  style: TextStyle(
                                    fontSize: 16.w,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                    ],
                  ),
                )
              : SizedBox(
                  height: 20.h,
                ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.userdata.id == AuthService.firebase().currentUser?.uid
                    ? ElevatedButton(
                        onPressed: () async {
                          String? uid = AuthService.firebase().currentUser?.uid;
                          UserData? userdata =
                              await DataService.getUserDataStream(uid!).first;
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: ((context) => SettingsView())));
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10), // Set rounded corner radius
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 60.w,
                            vertical: 7.h,
                          ), // Increase padding to make the button larger
                          textStyle:
                              TextStyle(fontSize: 18.w), // Increase font size
                        ),
                        child: const Text(
                          'Edit',
                        ),
                      )
                    : _isFollowing
                        ? ElevatedButton(
                            onPressed: () {
                              final internetConnectionStatus =
                                  Provider.of<InternetConnectionStatus>(context,
                                      listen: false);
                              if (internetConnectionStatus ==
                                  InternetConnectionStatus.connected) {
                                setState(() {
                                  _isFollowing = false;
                                });
                                if (Provider.of<UserDataInitializer>(context,
                                        listen: false)
                                    .getFollowing
                                    .contains(widget.userdata.id)) {
                                  DataService followbuttoninst = DataService();
                                  followbuttoninst
                                      .unfollowFunction(widget.userdata.id);
                                }
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text('you are not connected'),
                                  behavior: SnackBarBehavior.floating,
                                ));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  Colors.blueGrey, // Set the text color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10.0), // Set rounded corner radius
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 40.w,
                                  vertical: 7.h), // Set padding
                              textStyle:
                                  TextStyle(fontSize: 18.w), // Set font size
                            ),
                            child: const Text('Following'),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              final internetConnectionStatus =
                                  Provider.of<InternetConnectionStatus>(context,
                                      listen: false);
                              if (internetConnectionStatus ==
                                  InternetConnectionStatus.connected) {
                                setState(() {
                                  _isFollowing = true;
                                });
                                if (Provider.of<UserDataInitializer>(context,
                                        listen: false)
                                    .getFollowing
                                    .contains(widget.userdata.id)) {
                                } else {
                                  DataService followbuttoninst = DataService();
                                  followbuttoninst
                                      .followFunction(widget.userdata.id);
                                }
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text('you are not connected'),
                                  behavior: SnackBarBehavior.floating,
                                ));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10), // Set rounded corner radius
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50.w,
                                  vertical: 7
                                      .h), // Increase padding to make the button larger
                              textStyle: const TextStyle(
                                  fontSize: 18), // Increase font size
                            ),
                            child: const Text(
                              'Follow',
                            ),
                          ),
                SizedBox(
                  width: 20.w,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await launchUrl(_url);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10), // Set rounded corner radius
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: 40.w,
                        vertical:
                            7.h), // Increase padding to make the button larger
                    textStyle: TextStyle(fontSize: 18.w), // Increase font size
                  ),
                  child: const Text(
                    'Contact',
                  ),
                ),
              ],
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

  Widget _buildCategory(String categoryName) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        categoryName,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
