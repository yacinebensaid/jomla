import 'package:flutter/material.dart';
import 'package:jomla/services/auth/auth_service.dart';
import 'package:jomla/services/providers.dart';
import 'package:provider/provider.dart';

class NotDropshipper extends StatefulWidget {
  const NotDropshipper({
    Key? key,
  }) : super(key: key);

  @override
  State<NotDropshipper> createState() => _NotDropshipperState();
}

class _NotDropshipperState extends State<NotDropshipper> {
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
          images('assets/images/services/howto-dropshipping.jpg'),
          const SizedBox(height: 50),
          const Text(
            'What is an Dropshipping?',
            style: TextStyle(
              fontSize: (20),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              '    Dropshipping is a retail fulfillment method where a store doesn\'t keep the products it sells in stock. Instead, when a store sells a product, it purchases the item from a third party and has it shipped directly to the customer. As a result, the merchant never sees or handles the product.',
              style: TextStyle(
                fontSize: (18),
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 30),
          startButton(context),
          const SizedBox(height: 30),
          images('assets/images/services/dropshipping1.jpg'),
          const SizedBox(height: 30),
          const Text(
            'What you will get if you start:',
            style: TextStyle(
              fontSize: (20),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              '1. Access to a wide range of products.\n2. No need to manage inventory.\n3. Ability to run your business from anywhere.\n4. Low startup costs.\n5. Flexible work hours.\n6. Potential for high profits.',
              style: TextStyle(
                fontSize: (18),
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

  Widget images(String image) {
    return Center(
      child: Container(
        height: 200, // Set the height of the container
        decoration: BoxDecoration(
          // You can also apply decoration to the container
          borderRadius: BorderRadius.circular(10), // Example border radius
        ),
        child: Image.asset(
          image, // Replace with your image URL
          fit: BoxFit.cover, // Adjust the fit as needed
        ),
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
                      "Markets are not able to do FBA.",
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
                      "Affiliate Marketers are not able to do FBA.",
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
            } else if (usertype == 'OM') {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    content: const Text(
                      "You are an Online Market already!",
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
                            text: "dropshipping regulations",
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
        child: const Text(
          'Be a Dropshipper!',
          style: TextStyle(
            fontSize: (18),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
