// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:jomla/view/search/search.dart';

class SearchForExplore extends StatelessWidget {
  SearchForExplore({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: GestureDetector(
        onTap: () {
          showSearch(context: context, delegate: CustumSearchDeligate());
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[400]!, // Shadow color
                blurRadius: 4.0, // Spread radius
                offset:
                    Offset(0, 1), // Offset in the positive direction of y-axis
              ),
            ],
            border: Border.all(
              color: Colors.grey,
              width: 0.4,
            ),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 50,
          child: Row(
            children: const [
              Icon(Icons.search),
              SizedBox(width: 10),
              Text(
                'Search...',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
