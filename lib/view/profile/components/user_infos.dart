import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jomla/services/crud/userdata_service.dart';
import 'package:url_launcher/url_launcher.dart';

class UserInfos extends StatelessWidget {
  String uid;
  UserInfos({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DataService.getUserData(uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final fullname = snapshot.data!.name;
          final userPhonenumber = snapshot.data!.phoneNumber;
          Uri _url = Uri.parse('tel:${userPhonenumber}');
          return Container(
            child: Column(
              children: [
                const SizedBox(height: 16),
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.black,
                  child: Icon(
                    CupertinoIcons.person,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  fullname,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
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
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.location_on),
                    SizedBox(width: 8),
                    Text('Oran, Algeria'),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCategory('Home'),
                    _buildCategory('Electronics'),
                    _buildCategory('Accessory'),
                  ],
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
