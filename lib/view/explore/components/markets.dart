// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:jomla/services/crud/userdata_service.dart';
import 'package:jomla/utilities/shimmers.dart';
import 'package:jomla/view/profile/profile_view.dart';

import 'markets_loading.dart';

class MarketsRow extends StatefulWidget {
  const MarketsRow({
    Key? key,
  }) : super(key: key);

  @override
  State<MarketsRow> createState() => _MarketsRowState();
}

class _MarketsRowState extends State<MarketsRow> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 15, left: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Top markets',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
              TextButton(
                  onPressed: () {},
                  child: const Text('See more',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      )))
            ],
          ),
        ),
        FutureBuilder(
          future: DataService.getMarketData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // Extract the market data from the snapshot
              final marketData = snapshot.data as List<UserData>;

              return Padding(
                padding: const EdgeInsets.only(right: 15),
                child: SizedBox(
                  height: 110,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: marketData.length,
                    itemBuilder: (context, index) {
                      final UserData market = marketData[index];
                      return Padding(
                        padding: const EdgeInsets.only(left: 18),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: ((context) => ProfileScreen(
                                      fromNav: false,
                                      uid: market.id,
                                    ))));
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              market.picture == null
                                  ? const CircleAvatar(
                                      radius: 40,
                                      backgroundColor: Colors.grey,
                                      child: Icon(
                                        CupertinoIcons.person,
                                        color: Colors.white,
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 40,
                                      backgroundColor: Colors.grey,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(60),
                                        child: Center(
                                            child: CachedNetworkImage(
                                          key: UniqueKey(),
                                          imageUrl: market.picture!,
                                          height: 100,
                                          width: 100,
                                          maxWidthDiskCache: 250,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) {
                                            return const BuildShimmerEffect();
                                          },
                                          errorWidget: (context, url, error) {
                                            return Image.network(
                                              market.picture!,
                                              loadingBuilder:
                                                  (BuildContext context,
                                                      Widget child,
                                                      ImageChunkEvent?
                                                          loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                }
                                                return const BuildShimmerEffect();
                                              },
                                              errorBuilder: (_, __, ___) =>
                                                  const BuildShimmerEffect(),
                                            );
                                          },
                                        )),
                                      ),
                                    ),
                              const SizedBox(height: 8),
                              Text(
                                market.name!,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            } else {
              return const LoadingMarketsRow();
            }
          },
        ),
      ],
    );
  }
}
