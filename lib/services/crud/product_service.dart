import 'package:cloud_firestore/cloud_firestore.dart';
import 'crud_exceptions.dart';

class ProductService {
  static Future<String> productExists({
    required String mainCategory,
    required String reference,
    required String productName,
    required String subCategory,
    required String availableQuantity,
    required String minimumQuantity,
    required List sizes,
    required String price,
    required List colors,
    required String offers,
    required String mainPhoto,
    required List photos,
    required String description,
  }) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('ProductData')
        .doc(reference)
        .get();

    if (snapshot.exists) {
      return 'Product already exists';
    } else {
      try {
        FirebaseFirestore.instance
            .collection('ProductData')
            .doc(reference)
            .set({
          'main_category': mainCategory,
          'sub_category': subCategory,
          'reference': reference,
          'product_name': productName,
          'available_quantity': availableQuantity,
          'minimum_quantity': minimumQuantity,
          'sizes': sizes,
          'price': price,
          'offers': offers,
          'colors': colors,
          'main_photo': mainPhoto,
          'photos': photos,
          'description': description,
        });
        return 'Product saved, Product $productName';
      } on FaildToRegisterProduct {
        return 'Could not register the product';
      }
    }
  }

  static Future<List> searchProductByChoice(String choice, String value) async {
    List products = [];
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('ProductData')
        .where(choice, isEqualTo: value)
        .get();
    snapshot.docs.forEach((element) {
      products.add(element.data());
    });
    if (products.isEmpty) {
      return ['product does not exist'];
    } else {
      return products;
    }
  }

  static Future<List> searchProductByTwoChoices(
      String choice1, String value1, String choice2, String value2) async {
    List products = [];
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('ProductData')
        .where(choice1, isEqualTo: value1)
        .where(choice2, isEqualTo: value2)
        .get();
    snapshot.docs.forEach((element) {
      products.add(element.data());
    });
    if (products.isEmpty) {
      return ['product does not exist'];
    } else {
      return products;
    }
  }
}
