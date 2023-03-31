import '../../products_card/product.dart';

class PendingProduct {
  final ProductForCart product;
  final int id;
  final String reference;
  PendingProduct(
      {required this.id, required this.product, required this.reference});
}

// Demo data for our cart

Future<List<PendingProduct>> populateDemoCarts() async {
  List<PendingProduct> demoCarts = [];
  for (ProductForCart _product in await PendingCart.getProductsForPending()) {
    PendingProduct product = PendingProduct(
        product: _product, id: _product.id, reference: _product.reference);
    demoCarts.add(product);
  }
  return demoCarts;
}
