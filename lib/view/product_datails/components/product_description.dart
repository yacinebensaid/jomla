import 'package:flutter/material.dart';
import '../../../constants/constants.dart';
import '../../../size_config.dart';
import '../../products_card/product.dart';
import 'color_dots.dart';

class ProductDescription extends StatefulWidget {
  const ProductDescription({
    Key? key,
    required this.product,
    required this.pressOnSeeMore,
  }) : super(key: key);

  final Product product;
  final GestureTapCallback pressOnSeeMore;

  @override
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.product.minimum_quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
          ),
          child: Text(
            widget.product.product_name,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: getProportionateScreenWidth(20),
              ),
              child: Text(
                "minimum quantity: ${widget.product.minimum_quantity} pieces",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(15),
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.only(
                    left: getProportionateScreenWidth(15),
                    top: getProportionateScreenWidth(15),
                    bottom: getProportionateScreenWidth(15),
                  ),
                  child: Text(
                    "\$${widget.product.price}/piece",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(18),
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: getProportionateScreenWidth(20)),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(
            left: getProportionateScreenWidth(0),
            right: getProportionateScreenWidth(0),
          ),
          child: ColorDots(product: widget.product),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: getProportionateScreenWidth(20),
            right: getProportionateScreenWidth(64),
          ),
          child: Text(
            widget.product.description,
            maxLines: 3,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
            vertical: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Quantity",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: getProportionateScreenWidth(16),
                ),
              ),
              Text(
                _quantity.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: getProportionateScreenWidth(16),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
            vertical: 10,
          ),
          child: Row(
            children: [
              Expanded(
                child: Slider.adaptive(
                  value: _quantity.toDouble(),
                  min: widget.product.minimum_quantity.toDouble(),
                  max: widget.product.available_quantity.toDouble(),
                  onChanged: (newValue) {
                    setState(() {
                      _quantity = newValue.round();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
            vertical: 10,
          ),
          child: GestureDetector(
            onTap: () {},
            child: Row(
              children: const [
                Text(
                  "See More Detail",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: kPrimaryColor),
                ),
                SizedBox(width: 5),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: kPrimaryColor,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
