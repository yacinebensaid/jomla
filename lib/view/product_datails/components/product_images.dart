import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jomla/constants/constants.dart';
import 'package:jomla/utilities/shimmers.dart';
import '../../../size_config.dart';
import '../../products_card/product.dart';

class ProductImages extends StatefulWidget {
  const ProductImages({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  _ProductImagesState createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  ScrollController _scrollController = ScrollController();
  PageController _pageController = PageController();
  int selectedImage = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Hero(
            tag: widget.product.id.toString(),
            child: InteractiveViewer(
              child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.product.photos.length,
                  onPageChanged: (index) {
                    setState(() {
                      selectedImage = index;
                    });
                    double position = ((48.0) + 15) * index;
                    // Scroll the ListView to the selected image position
                    _scrollController.animateTo(
                      position,
                      duration: defaultDuration,
                      curve: Curves.easeInOut,
                    );
                  },
                  itemBuilder: (context, index) {
                    return CachedNetworkImage(
                      key: UniqueKey(),
                      imageUrl: widget.product.photos[selectedImage],
                      maxWidthDiskCache: 250,
                      fit: BoxFit.cover,
                      placeholder: (context, url) {
                        return const BuildShimmerEffect();
                      },
                      errorWidget: (context, url, error) {
                        return Image.network(
                          widget.product.photos[selectedImage],
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return const BuildShimmerEffect();
                          },
                          errorBuilder: (_, __, ___) =>
                              const BuildShimmerEffect(),
                        );
                      },
                    );
                  }),
            ),
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(10)),
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: SizedBox(
            width: (238),
            height: (48),
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.product.photos.length + 2,
              itemBuilder: (context, index) {
                if (index == 0 || index == widget.product.photos.length + 1) {
                  // Padding to indicate that there are more photos
                  return SizedBox(width: SizeConfig.screenWidth * 0.25);
                }
                final photoIndex = index - 1;
                return buildSmallProductPreview(photoIndex);
              },
            ),
          ),
        ),
      ],
    );
  }

  GestureDetector buildSmallProductPreview(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedImage = index;
        });
        // Calculate the position of the selected image in the ListView
        double position = ((48.0) + 15) * index;
        // Scroll the ListView to the selected image position
        _scrollController.animateTo(
          position,
          duration: defaultDuration,
          curve: Curves.easeInOut,
        );
      },
      child: AnimatedContainer(
          duration: defaultDuration,
          margin: const EdgeInsets.only(right: 15),
          padding: const EdgeInsets.all(8),
          height: (48),
          width: (48),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: kPrimaryColor.withOpacity(selectedImage == index ? 1 : 0),
            ),
          ),
          child: CachedNetworkImage(
            key: UniqueKey(),
            imageUrl: widget.product.photos[index],
            maxWidthDiskCache: 250,
            fit: BoxFit.cover,
            placeholder: (context, url) {
              return const BuildShimmerEffect();
            },
            errorWidget: (context, url, error) {
              return Image.network(
                widget.product.photos[index],
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return const BuildShimmerEffect();
                },
                errorBuilder: (_, __, ___) => const BuildShimmerEffect(),
              );
            },
          )),
    );
  }
}
