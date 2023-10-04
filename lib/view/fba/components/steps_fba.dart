import 'package:flutter/material.dart';
import 'package:jomla/services/auth/auth_service.dart';
import 'package:jomla/services/providers.dart';
import 'package:jomla/utilities/reusable.dart';
import 'package:provider/provider.dart';
import 'start_fba.dart';

class StepsOnlineMarket extends StatefulWidget {
  const StepsOnlineMarket({
    Key? key,
  }) : super(key: key);

  @override
  State<StepsOnlineMarket> createState() => _StepsOnlineMarketState();
}

class _StepsOnlineMarketState extends State<StepsOnlineMarket> {
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
    return Scaffold(
      appBar: CustomAppBarSubPages(
        onBackButtonPressed: () => Navigator.of(context).pop(),
        title: 'Last steps',
      ),
      body: Container(
        color: Color.fromARGB(255, 255, 255, 255),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              images('assets/images/services/fba1.jpg'),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: const Text(
                  "Getting Started with Online Market's Fulfillment Service",
                  style: TextStyle(
                    fontSize: (21),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "We're excited to offer you our streamlined and comprehensive fulfillment service at Online Market! To get started and enjoy the benefits of our service, here are the simple steps you need to follow:",
                  style: TextStyle(
                    fontSize: (18),
                    color: Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                "1. Obtain an 'Edahabiya' Card for Online Payments: ",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          TextSpan(
                            text:
                                "Before you can avail of our fulfillment service, you'll need an 'Edahabiya' card for online payments. If you don't already have one, this can be easily obtained from your preferred financial institution or online banking platform. This card will serve as your secure and convenient method of payment for our services.",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '2. Create Your Online Market Account: ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          TextSpan(
                            text:
                                "Once you have your 'Edahabiya' card ready, visit our dedicated sign-up page, which is designed to make the registration process quick and hassle-free. Here, you'll be prompted to provide essential information to create your Online Market account. This includes your name, contact details, and billing information associated with your 'Edahabiya' card.",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '3. Choose Your Subscription Plan: ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          TextSpan(
                            text:
                                "With your account set up, it's time to select the subscription plan that best suits your business needs. We offer flexible subscription options to accommodate a wide range of businesses, from startups to established enterprises. Choose the plan that aligns with your fulfillment requirements.",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '4. Enjoy Your First Month for Free: ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          TextSpan(
                            text:
                                "As a special offer to welcome you to Online Market, your first month of using our fulfillment service will be completely free of charge! This means you can experience the efficiency and convenience of our services without any financial commitment for the initial month.",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: const Text(
                  'Benefits of Choosing Online Market:',
                  style: TextStyle(
                    fontSize: (21),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Cost-Efficiency: ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          TextSpan(
                            text:
                                "Our competitive pricing ensures you get top-notch fulfillment services without breaking the bank.",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Streamlined Operations: ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          TextSpan(
                            text:
                                "Focus on your core business activities while we take care of logistics and order fulfillment.",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Scalability: ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          TextSpan(
                            text:
                                "As your business grows, our service can scale with you, accommodating your evolving needs.",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              Center(
                child: Text(
                  "Let's start!",
                  style: TextStyle(
                    fontSize: (21),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(child: startButton(context)),
              const SizedBox(height: 60),
            ],
          ),
        ),
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
              Navigator.of(context).push(MaterialPageRoute(
                  builder: ((context) => StratOnlineMarket())));
            }
          }
        }),
        child: const Text(
          'Start an Online Market!',
          style: TextStyle(
            fontSize: (18),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
