import 'package:flutter/material.dart';

class WhyUseStoring extends StatelessWidget {
  const WhyUseStoring({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Why you may need Storing?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(height: 15),
                Text(
                  '• No need to go to the delivery office, we take it for you.',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 15),
                Text(
                  '• We make sure your products stay safe and provide assurance for that.',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 15),
                Text(
                  '• Full support and help experience.',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
