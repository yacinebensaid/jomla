import 'package:flutter/material.dart';
import 'package:jomla/services/auth/auth_service.dart';
import 'package:jomla/services/providers.dart';
import 'package:provider/provider.dart';

class NotAffiliate extends StatefulWidget {
  const NotAffiliate({
    Key? key,
  }) : super(key: key);

  @override
  State<NotAffiliate> createState() => _NotAffiliateState();
}

class _NotAffiliateState extends State<NotAffiliate> {
  String usertype = 'normal';
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    usertype = Provider.of<UserDataInitializer>(context).getUserData != null
        ? Provider.of<UserDataInitializer>(context).getUserData!.user_type
        : 'normal';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 30),
          Center(
            child: Container(
              width: 200, // Set the width of the container
              height: 200, // Set the height of the container
              decoration: BoxDecoration(
                // You can also apply decoration to the container
                color: Colors.blue, // Example background color
                borderRadius:
                    BorderRadius.circular(10), // Example border radius
              ),
              child: Image.asset(
                'assets/images/services/affiliate-marketing1.jpg', // Replace with your image URL
                fit: BoxFit.cover, // Adjust the fit as needed
              ),
            ),
          ),
          const SizedBox(height: 50),
          Text(
            'What is Affiliate Marketing?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              '   Affiliate marketing is a performance based marketing strategy where individuals or businesses earn commissions by promoting products or services of others. Affiliates drive traffic or sales through referral links, and when a purchase is made, they receive a percentage of the revenue.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 30),
          startButton(context),
          const SizedBox(height: 30),
          Text(
            'What you will get if you start:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              '1. No need to buy any products.\n2. Less spending on ADs with the time.\n3. Ability to run your business from anywhere.\n4. Great additional profit.\n5. Flexible work hours.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 30),
          startButton(context),
        ],
      ),
    );
  }

  Widget startButton(BuildContext context) {
    return SizedBox(
      width: 270,
      height: 48,
      child: TextButton(
        style: TextButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          foregroundColor: Color.fromARGB(255, 91, 199, 245),
          backgroundColor: Color.fromARGB(255, 91, 199, 245),
        ),
        onPressed: (() {
          if (AuthService.firebase().currentUser == null) {
            Provider.of<HomeFunc>(context, listen: false)
                .onTapNavigation(context, 3);
          } else {
            if (usertype == 'market') {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    content: const Text(
                      "Markets are not able to do Affiliate Marketing.",
                      style: TextStyle(fontSize: 18),
                    ),
                    actions: [
                      TextButton(
                        child: const Text(
                          "Ok",
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            } else if (usertype == 'affiliate') {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    content: const Text(
                      "You are an Affilate Marketer already!",
                      style: TextStyle(fontSize: 18),
                    ),
                    actions: [
                      TextButton(
                        child: const Text(
                          "Ok",
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            } else if (usertype == 'dropshipper') {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    content: const Text(
                      "Dropshippers are not able to do Affiliate Marketing.",
                      style: TextStyle(fontSize: 18),
                    ),
                    actions: [
                      TextButton(
                        child: const Text(
                          "Ok",
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    content: Text.rich(
                      // Use Text.rich to display rich text
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "By clicking 'Confirm' you agree to all ",
                            style: TextStyle(fontSize: 18),
                          ),
                          TextSpan(
                            text: "Affiliate marketing regulations",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: const Text(
                          "cancel",
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      ElevatedButton(
                        child: const Text(
                          "Confirm",
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            }
          }
        }),
        child: Text(
          'Be an Affiliate marketer!',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
