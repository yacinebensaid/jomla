import 'package:flutter/material.dart';
import '../../../constants/constants.dart';
import '../../../services/crud/PCF_service.dart';
import '../../../size_config.dart';
import '../../products_card/product.dart';
import 'color_dots.dart';
import 'default_btn.dart';
import 'owner.dart';
import 'top_rounded_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductDescription extends StatefulWidget {
  const ProductDescription({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

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

  String getQuantity() {
    return _quantity.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: EdgeInsets.only(
          left: getProportionateScreenWidth(20),
          right: getProportionateScreenWidth(20),
          top: getProportionateScreenHeight(20),
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
      Center(
        child: Owner(
          uid: widget.product.owner,
        ),
      ),
      SizedBox(
        height: getProportionateScreenHeight(20),
      ),
      Padding(
        padding: const EdgeInsets.only(
          left: 20,
        ),
        child: Text(
          'Description:',
          style: TextStyle(
            fontSize: getProportionateScreenWidth(20),
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(255, 151, 151, 151),
          ),
        ),
      ),
      SizedBox(
        height: getProportionateScreenHeight(10),
      ),
      Padding(
        padding: const EdgeInsets.only(
          left: 30,
          right: 20,
        ),
        child: Text(
          widget.product.description,
          style: TextStyle(
              fontSize: getProportionateScreenWidth(18),
              color: Colors.black,
              height: 1.4),
        ),
      ),
      SizedBox(
        height: getProportionateScreenHeight(40),
      ),
      Padding(
        padding: const EdgeInsets.only(
          left: 20,
        ),
        child: Text(
          AppLocalizations.of(context)!.quantity,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(20),
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(255, 151, 151, 151),
          ),
        ),
      ),
      SizedBox(
        height: getProportionateScreenHeight(10),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: QuantitySelector(
          quantity: _quantity,
          price: int.parse(widget.product.price),
          minQuantity: widget.product.minimum_quantity,
          maxQuantity: widget.product.available_quantity,
          onChanged: (value) {
            setState(() {
              _quantity = value;
            });
          },
        ),
      ),
      SizedBox(
        height: getProportionateScreenHeight(20),
      ),
      TopRoundedContainer(
          color: Color(0xFFF6F7F9),
          child: Column(
            children: [
              TopRoundedContainer(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: SizeConfig.screenWidth * 0.15,
                    right: SizeConfig.screenWidth * 0.15,
                    bottom: getProportionateScreenWidth(40),
                  ),
                  child: DefaultButton(
                    text: AppLocalizations.of(context)!.addtocart,
                    press: () {
                      UserPCFService.addToCart(
                          reference: widget.product.reference,
                          quantity: _quantity.toString(),
                          total_price:
                              (_quantity * int.parse(widget.product.price))
                                  .toString());
                    },
                  ),
                ),
              ),
            ],
          ))
    ]);
  }
}

class QuantitySelector extends StatefulWidget {
  final int quantity;
  final int price;
  final int minQuantity;
  final int maxQuantity;
  final void Function(int) onChanged;

  QuantitySelector(
      {required this.quantity,
      required this.minQuantity,
      required this.maxQuantity,
      required this.onChanged,
      required this.price});

  @override
  _QuantitySelectorState createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  late int _quantity;
  late int _totalPrice;

  @override
  void initState() {
    super.initState();
    _quantity = widget.quantity;
    _totalPrice = widget.quantity * widget.price;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                if (_quantity > widget.minQuantity) {
                  setState(() {
                    _quantity--;
                    _totalPrice = _quantity * widget.price;
                  });
                  widget.onChanged(_quantity);
                }
              },
              icon: Icon(Icons.remove),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "$_quantity",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                if (_quantity < widget.maxQuantity) {
                  setState(() {
                    _quantity++;
                    _totalPrice = _quantity * widget.price;
                  });
                  widget.onChanged(_quantity);
                }
              },
              icon: Icon(Icons.add),
            ),
          ],
        ),
        SizedBox(
          height: getProportionateScreenHeight(5),
        ),
        Text(
          "Total: \$$_totalPrice",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(20),
            fontWeight: FontWeight.w600,
            color: kPrimaryColor,
          ),
        ),
      ],
    );
  }
}
