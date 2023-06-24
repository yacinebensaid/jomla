// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:jomla/services/crud/product_service.dart';
import 'package:jomla/services/crud/userdata_service.dart';
import 'package:jomla/view/product_edit/product_edit.dart';

import '../../../size_config.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  bool isAdmin;
  final VoidCallback onBackButtonPressed;
  final String ref;
  CustomAppBar({
    Key? key,
    required this.isAdmin,
    required this.onBackButtonPressed,
    required this.ref,
  })  : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: kToolbarHeight,
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: Row(
          children: [
            SizedBox(
              height: getProportionateScreenWidth(40),
              width: getProportionateScreenWidth(40),
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.zero,
                ),
                onPressed: onBackButtonPressed,
                child: SvgPicture.asset(
                  "assets/icons/Back ICon.svg",
                  height: 15,
                ),
              ),
            ),
            const Spacer(),
            dropDownMenu(context),
          ],
        ),
      ),
    );
  }

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
                      DataService _dataServInstance = DataService();
                      _dataServInstance.deleteOwnedProduct(ref);
                      ProductService.deleteProduct(ref);
                      // Perform the delete operation here
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else if (value == 'edit') {
          Navigator.of(context).push(MaterialPageRoute(
              builder: ((context) => EditProduct(
                    ref: ref,
                  ))));
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'signal',
          child: Text('Signal Product'),
        ),
        ...isAdmin
            ? [
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: Text('Edit'),
                ),
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
