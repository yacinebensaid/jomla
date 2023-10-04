import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jomla/services/auth/auth_service.dart';
import 'package:jomla/services/crud/userdata_service.dart';
import 'package:jomla/services/providers.dart';
import 'package:jomla/utilities/reusable.dart';
import 'package:jomla/view/settings/settings_view.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class UserInfos extends StatefulWidget {
  final UserData userdata;
  const UserInfos({
    super.key,
    required this.userdata,
  });

  @override
  State<UserInfos> createState() => _UserInfosState();
}

class _UserInfosState extends State<UserInfos> {
  bool _descriptionFieldExpanded = false;
  late bool _isFollowing;
  late UserData _userdata;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _isFollowing = Provider.of<UserDataInitializer>(context).getUserData != null
        ? Provider.of<UserDataInitializer>(context, listen: false)
            .getUserData!
            .following
            .contains(widget.userdata.id)
        : false;

    _userdata = widget.userdata;
    if (_userdata.user_type == 'market') {
      marketInfos(
        _userdata.name!,
        _userdata.phoneNumber!,
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

  Widget dropDownMenu() {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 91, 199, 245),
            Color.fromARGB(255, 169, 231, 205), // Start color (your blue color)
            // End color (lighter color)
          ],
          begin:
              Alignment.centerLeft, // You can adjust the gradient's start point
          end: Alignment.centerRight, // You can adjust the gradient's end point
        ),
      ),
      child: Container(
        padding: const EdgeInsets.only(left: 15, bottom: 10, top: 30),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(0, 255, 255, 255),
            ],
            begin: Alignment
                .bottomCenter, // You can adjust the gradient's start point
            end: Alignment.topCenter, // You can adjust the gradient's end point
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[400],
                  child: Icon(
                    CupertinoIcons.person,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      fullname,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        SizedBox(
                          width: 68,
                          child: Column(
                            children: [
                              Text(
                                '${products.length}', // Replace with actual number of products
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              const Text(
                                'Products',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        SizedBox(
                          width: 68,
                          child: Column(
                            children: [
                              Text(
                                '${sales.length}', // Replace with actual number of sales
                                style: const TextStyle(fontSize: 16),
                              ),
                              const Text(
                                'Sales',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        SizedBox(
                          width: 68,
                          child: Column(
                            children: [
                              Text(
                                '${followers.length}', // Replace with actual number of followers
                                style: const TextStyle(fontSize: 16),
                              ),
                              const Text(
                                'Followers',
                                style: TextStyle(
                                  fontSize: 15,
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
                    padding:
                        const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          description,
                          style: const TextStyle(
                            fontSize: 16,
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
                                  child: const Text(
                                    '...see more',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                      ],
                    ),
                  )
                : const SizedBox(
                    height: 20,
                  ),
            Container(
              padding: const EdgeInsets.only(left: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.userdata.id == AuthService.firebase().currentUser?.uid
                      ? Expanded(
                          flex: 3,
                          child: ElevatedButton(
                            onPressed: () async {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: ((context) =>
                                      const SettingsView())));
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10), // Set rounded corner radius
                              ),

                              textStyle: const TextStyle(
                                  fontSize: 16), // Increase font size
                            ),
                            child: const Text(
                              'Edit',
                            ),
                          ),
                        )
                      : _isFollowing &&
                              AuthService.firebase().currentUser != null
                          ? Expanded(
                              flex: 3,
                              child: ElevatedButton(
                                onPressed: () {
                                  final internetConnectionStatus =
                                      Provider.of<InternetConnectionStatus>(
                                          context,
                                          listen: false);
                                  if (internetConnectionStatus ==
                                      InternetConnectionStatus.connected) {
                                    setState(() {
                                      _isFollowing = false;
                                    });
                                    if (Provider.of<UserDataInitializer>(
                                                    context,
                                                    listen: false)
                                                .getUserData !=
                                            null
                                        ? Provider.of<UserDataInitializer>(
                                                context,
                                                listen: false)
                                            .getUserData!
                                            .following
                                            .contains(widget.userdata.id)
                                        : false) {
                                      DataService followbuttoninst =
                                          DataService();
                                      followbuttoninst.unfollowFunction(
                                          widget.userdata.id!);
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
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
                                  textStyle: const TextStyle(
                                      fontSize: 16), // Set font size
                                ),
                                child: const Text('Following'),
                              ),
                            )
                          : Expanded(
                              flex: 3,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (kIsWeb) {
                                    if (AuthService.firebase().currentUser !=
                                        null) {
                                      if (Provider.of<UserDataInitializer>(
                                                      context,
                                                      listen: false)
                                                  .getUserData !=
                                              null
                                          ? Provider.of<UserDataInitializer>(
                                                  context,
                                                  listen: false)
                                              .getUserData!
                                              .following
                                              .contains(widget.userdata.id)
                                          : false) {
                                      } else {
                                        DataService followbuttoninst =
                                            DataService();
                                        followbuttoninst.followFunction(
                                            widget.userdata.id!);
                                      }
                                    } else {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return Dialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                child: const LoginDialog(
                                                  guest: true,
                                                ));
                                          });
                                    }
                                  } else {
                                    final internetConnectionStatus =
                                        Provider.of<InternetConnectionStatus>(
                                            context,
                                            listen: false);
                                    if (internetConnectionStatus ==
                                        InternetConnectionStatus.connected) {
                                      setState(() {
                                        _isFollowing = true;
                                      });
                                      if (AuthService.firebase().currentUser !=
                                          null) {
                                        if (Provider.of<UserDataInitializer>(
                                                        context,
                                                        listen: false)
                                                    .getUserData !=
                                                null
                                            ? Provider.of<UserDataInitializer>(
                                                    context,
                                                    listen: false)
                                                .getUserData!
                                                .following
                                                .contains(widget.userdata.id)
                                            : false) {
                                        } else {
                                          DataService followbuttoninst =
                                              DataService();
                                          followbuttoninst.followFunction(
                                              widget.userdata.id!);
                                        }
                                      } else {
                                        showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              return Dialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  child: const LoginDialog(
                                                    guest: true,
                                                  ));
                                            });
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text('you are not connected'),
                                        behavior: SnackBarBehavior.floating,
                                      ));
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10), // Set rounded corner radius
                                  ),

                                  textStyle: const TextStyle(
                                      fontSize: 16), // Increase font size
                                ),
                                child: const Text(
                                  'Follow',
                                ),
                              ),
                            ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 3,
                    child: ElevatedButton(
                      onPressed: () async {
                        await launchUrl(_url);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Set rounded corner radius
                        ),

                        textStyle:
                            const TextStyle(fontSize: 16), // Increase font size
                      ),
                      child: const Text(
                        'Contact',
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        dropDownMenu();
                      },
                      icon: Icon(
                        Icons.more_vert,
                        size: 20,
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
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
