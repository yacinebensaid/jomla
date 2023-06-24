import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadPendingCard extends StatelessWidget {
  const LoadPendingCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Row(
        children: [
          SizedBox(
            width: 88,
            child: AspectRatio(
              aspectRatio: 0.88,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6F9),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 16,
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                Container(
                  height: 16,
                  width: double.infinity,
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                Container(
                  height: 16,
                  width: 100,
                  color: Colors.white,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class LoadRowPending extends StatelessWidget {
  const LoadRowPending({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: const [
          LoadPendingCard(),
          SizedBox(
            height: 10,
          ),
          LoadPendingCard(),
          SizedBox(
            height: 10,
          ),
          LoadPendingCard(),
          SizedBox(
            height: 10,
          ),
          LoadPendingCard(),
          SizedBox(
            height: 10,
          ),
          LoadPendingCard(),
        ],
      ),
    );
  }
}
