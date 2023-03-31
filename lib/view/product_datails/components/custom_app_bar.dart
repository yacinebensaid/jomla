import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jomla/services/crud/userdata_service.dart';

import '../../../size_config.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBackButtonPressed;
  final String userUID;
  const CustomAppBar({
    Key? key,
    required this.onBackButtonPressed,
    required this.userUID,
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
            Spacer(),
            userDataContainer(),
          ],
        ),
      ),
    );
  }

  Widget userDataContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: FutureBuilder(
        future: DataService.getUserDataForOrder(userUID),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Error occurred while fetching user data');
          }
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          final userData = snapshot.data as Map<String, dynamic>;
          if (userData['role'] == 'admin') {
            return IconButton(
              onPressed: () {},
              icon: const Icon(Icons.edit),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
