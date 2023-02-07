import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  static addProduct({
    required String mainCategory,
    required String reference,
    required String productName,
    required List category,
    required String availableQuantity,
    required String minimumQuantity,
    required List sizes,
    required String price,
    required List colors,
    required List photos,
    required String description,
  }) =>
      FirebaseFirestore.instance
          .collection('ProductData')
          .doc(mainCategory)
          .set({
        'reference': reference,
        'product name': productName,
        'category': category,
        'available quantity': availableQuantity,
        'minimum quantity': minimumQuantity,
        'sizes': sizes,
        'price': price,
        'colors': colors,
        'photos': photos,
        'description': description,
      });
}
