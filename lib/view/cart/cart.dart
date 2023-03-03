import '../products_card/product.dart';

class Cart {
  final ProductForCart product;
  final int id;
  final String reference;
  Cart({required this.id, required this.product, required this.reference});
}

// Demo data for our cart

Future<List<Cart>> populateDemoCarts() async {
  List<Cart> demoCarts = [];
  for (ProductForCart _product in await ShoppingCart.getProductsForCart()) {
    Cart product =
        Cart(product: _product, id: _product.id, reference: _product.reference);
    demoCarts.add(product);
  }
  return demoCarts;
}
