import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jomla/services/auth/auth_service.dart';
import 'package:jomla/services/crud/pcf_service.dart';
import 'package:jomla/services/crud/product_service.dart';
import 'package:jomla/services/crud/userdata_service.dart';
import 'package:jomla/services/providers.dart';
import 'package:jomla/utilities/success_dialog.dart';
import 'package:provider/provider.dart';

class Comments extends StatefulWidget {
  final String reference;
  const Comments({super.key, required this.reference});

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  bool showAddComment = false;
  UserData? currentUser;

  TextEditingController _textEditingController = TextEditingController();
  bool _isButtonActive = false;

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(_textFieldListener);
  }

  @override
  void dispose() {
    _textEditingController.removeListener(_textFieldListener);
    _textEditingController.dispose();
    super.dispose();
  }

  void _textFieldListener() {
    setState(() {
      String text = _textEditingController.text.trim();
      _isButtonActive = text.isNotEmpty;
    });
  }

  Future<void> _showAddComment() async {
    bool hasItem = await UserPCFService.hasPurchasedItem(widget.reference);
    if (hasItem) {
      final uid = AuthService.firebase().currentUser?.uid;
      UserData? userdata = await DataService.getUserDataForOrder(uid!);
      setState(() {
        showAddComment = true;
        currentUser = userdata;
      });
    } else {
      showSuccessDialog(
        context,
        'People who did not purchase this item are not able to add a review.',
      );
    }
  }

  void _addComment() {
    ProductService.addComment(
        widget.reference, currentUser!.id, _textEditingController.text);
    setState(() {
      _textEditingController.text = '';
      showAddComment = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20,
            ),
            child: Text(
              'Reviews:',
              style: TextStyle(
                fontSize: 20.w,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 151, 151, 151),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 15.h,
        ),
        !showAddComment
            ? GestureDetector(
                onTap: _showAddComment,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  width: 330.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Write a review',
                      style: TextStyle(color: Colors.black, fontSize: 20.w),
                    ),
                  ),
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  child: Column(children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20.w,
                            backgroundColor: Colors.grey,
                            child: currentUser!.picture == null
                                ? Icon(
                                    CupertinoIcons.person,
                                    color: Colors.white,
                                  )
                                : Image.network(currentUser!.picture!),
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          Text(
                            currentUser!.name,
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 17.w),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _textEditingController,
                              maxLines: null,
                              maxLength: 150,
                              style: TextStyle(fontSize: 15.w),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 10.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: _isButtonActive
                                ? () {
                                    _addComment();
                                  }
                                : null,
                            icon: Icon(
                              Icons.send_rounded,
                              color: _isButtonActive
                                  ? Colors.grey[800]
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  ]),
                ),
              ),
        StreamBuilder(
          stream: ProductService.getCommentsStream(widget.reference),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              if (snapshot.data != null) {
                List<Map<String, dynamic>> comments = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: comments.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    Map<String, dynamic> comment = comments[index];
                    String uid = comment['uid']!;
                    String commentText = comment['comment']!;

                    return FutureBuilder(
                      future: DataService.getUserDataForOrder(uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasData) {
                          if (snapshot.data != null) {
                            UserData user = snapshot.data!;
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.w),
                              child: Padding(
                                padding: EdgeInsets.only(top: 10.h),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 15.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Color.fromARGB(255, 248, 248, 248),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 20.w,
                                                backgroundColor: Colors.grey,
                                                child: user.picture == null
                                                    ? Icon(
                                                        CupertinoIcons.person,
                                                        color: Colors.white,
                                                      )
                                                    : Image.network(
                                                        user.picture!),
                                              ),
                                              SizedBox(
                                                width: 8.w,
                                              ),
                                              Text(
                                                user.name,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 17.w),
                                              )
                                            ],
                                          ),
                                          dropDownMenu(context),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.w),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.w,
                                                vertical: 10.h),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white,
                                            ),
                                            child: Text(
                                              commentText,
                                              style: TextStyle(fontSize: 16.w),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    );
                  },
                );
              } else {
                return SizedBox.shrink();
              }
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }

//how to make only that 'reviews' title on the left of the screen but the other item in the center
  Widget dropDownMenu(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) async {
        if (value == 'delete') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Delete Item"),
                content:
                    const Text("Are you sure you want to delete this item?"),
                actions: [
                  TextButton(
                    child: const Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text("Delete"),
                    onPressed: () {
                      // Perform the delete operation here
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'signal',
          child: Text('Signal comment'),
        ),
        ...Provider.of<UserDataInitializer>(context, listen: false).getIsAdmin
            ? [
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Text('Delete'),
                ),
              ]
            : []
      ].toList(),
    );
  }
}
