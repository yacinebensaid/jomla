import '../../products_card/product.dart';

class PurchasedProduct {
  final ProductForPurchased product;
  final int id;
  final String reference, purchaseID;
  PurchasedProduct(
      {required this.id,
      required this.product,
      required this.reference,
      required this.purchaseID});
}

// Demo data for our cart

Future<List<PurchasedProduct>> populateDemoCarts() async {
  List<PurchasedProduct> demoCarts = [];
  for (ProductForPurchased _product
      in await PurchasedCart.getProductsForPurchased()) {
    PurchasedProduct product = PurchasedProduct(
      purchaseID: _product.purchasedID,
      product: _product,
      id: _product.id,
      reference: _product.reference,
    );
    demoCarts.add(product);
  }
  return demoCarts;
}
