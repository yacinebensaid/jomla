import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jomla/services/crud/userdata_service.dart';
import 'package:jomla/view/profile/profile_view.dart';

class Owner extends StatelessWidget {
  String uid;
  Owner({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
          height: 70,
          width: MediaQuery.of(context).size.width * 0.93,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.grey[200],
          ),
          child: FutureBuilder(
            future: DataService.getUserData(uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                ;
                final fullname = snapshot.data!.name;
                return Row(
                  children: [
                    const SizedBox(width: 16),
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: Color.fromARGB(255, 105, 105, 105),
                      child: Icon(
                        CupertinoIcons.person,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      fullname,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          )),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: ((context) => ProfileScreen(
                  uid: uid,
                ))));
      },
    );
  }
}
