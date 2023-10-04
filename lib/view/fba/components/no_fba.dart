import 'package:flutter/material.dart';
import 'package:jomla/services/auth/auth_service.dart';
import 'package:jomla/services/providers.dart';
import 'package:jomla/view/fba/components/steps_fba.dart';
import 'package:provider/provider.dart';

class NotOnlineMarket extends StatefulWidget {
  const NotOnlineMarket({
    Key? key,
  }) : super(key: key);

  @override
  State<NotOnlineMarket> createState() => _NotOnlineMarketState();
}

class _NotOnlineMarketState extends State<NotOnlineMarket> {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          images('assets/images/services/fba1.jpg'),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: const Text(
              'Online Market Fulfillment Service: Streamlining Your Business Operations',
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
              "In today's fast-paced and competitive business landscape, optimizing operations is essential for success. Enter Online Market, a comprehensive fulfillment service that caters to the diverse needs of businesses seeking to excel in the e-commerce realm. Our services encompass a range of crucial aspects, simplifying the entire order fulfillment process, and empowering businesses to concentrate on their core strengths such as product development and strategic marketing initiatives.",
              style: TextStyle(
                fontSize: (18),
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 30),
          Center(child: startButton(context)),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: const Text(
              'Key Components of Online Market Fulfillment Service:',
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
                        text: '1. Storage: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      TextSpan(
                        text:
                            " Our secure warehousing facilities provide a safe and efficient environment for your products. With ample space and advanced inventory management systems, your inventory is in capable hands, allowing you to scale your business without worrying about storage constraints.",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                images('assets/images/services/storage.jpg'),
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '2. Packing Expertise: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      TextSpan(
                        text:
                            "The importance of proper packaging cannot be overstated. Online Market's packing specialists use the latest techniques and high-quality materials to ensure your products are packaged securely, minimizing the risk of damage during transit and creating a lasting positive impression on your customers.",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                images('assets/images/services/packaging.jpg'),
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '3. Efficient Shipping: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      TextSpan(
                        text:
                            "We leverage our industry connections to select the most suitable shipping carriers, optimizing both cost and delivery speed. This way, you can offer your customers a variety of shipping options, enhancing their shopping experience.",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                images('assets/images/services/delivery.jpg'),
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '4. Affiliate Marketing Service: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      TextSpan(
                        text:
                            "Our innovative approach doesn't stop at logistics. We also offer an affiliate marketing service that can significantly expand your product's reach. Through strategic partnerships with affiliates, we promote your products across various online platforms, generating increased sales and brand visibility. Affiliates earn commissions for each successful sale they drive, ensuring mutual benefit.",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                images('assets/images/services/affiliate_marketing.jpg'),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Center(child: startButton(context)),
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
                        text: 'Simplified Operations: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      TextSpan(
                        text:
                            "With Online Market handling the intricacies of logistics and marketing, you can dedicate your resources and efforts to product development and strategy.",
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
                        text: 'Cost Efficiency: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      TextSpan(
                        text:
                            "By optimizing shipping and storage costs and leveraging affiliate marketing for growth, our service helps you operate more cost-effectively.",
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
                            "As your business grows, our fulfillment service seamlessly scales with you, ensuring that you can meet increasing demand without any hiccups.",
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
          Center(child: startButton(context)),
          const SizedBox(height: 60),
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
              Navigator.of(context).push(MaterialPageRoute(
                  builder: ((context) => StepsOnlineMarket())));
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
