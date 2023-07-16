import 'package:flutter/material.dart';
import 'package:jomla/constants/routes.dart';

class Service {
  final String name;
  final String description;
  final String imageUrl;
  final servicePage;
  bool isExpanded;

  Service({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.servicePage,
    this.isExpanded = false,
  });
}

class Services extends StatefulWidget {
  const Services({super.key});

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  final List<Service> services = [
    Service(
      servicePage: null,
      name: 'Orders\nDelivery',
      description: 'Service description',
      imageUrl: 'assets/images/services/shipping.jpeg',
    ),
    /*Service(
      servicePage: shippingServiceRout,
      name: 'Products\nShipping',
      description: 'Service description',
      imageUrl: 'assets/images/services/shipping_serv.jpeg',
    ),*/

    Service(
      servicePage: null,
      name: 'Website/\nApp creation',
      description: 'Service description',
      imageUrl: 'assets/images/services/website_creation.jpeg',
    ),
    Service(
      servicePage: null,
      name: 'Product\nShooting',
      description: 'Service description',
      imageUrl: 'assets/images/services/photography.jpeg',
    ),
    Service(
      servicePage: null,
      name: 'Facebook ads\nGoogle ads',
      description: 'Service description',
      imageUrl: 'assets/images/services/marketing.jpeg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: Colors.white,
      ),
      child: Column(
        children: List.generate(services.length, (index) {
          final service = services[index];
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(service.servicePage);
                },
                child: Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 6,
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(service.imageUrl),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                service.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                service.description,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                color: Colors.grey,
                height: 1,
                thickness: 1,
                indent: 20,
                endIndent: 20,
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          );
        }),
      ),
    );
  }
}
