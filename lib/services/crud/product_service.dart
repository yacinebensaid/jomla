import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  static addProduct({
    required String refrence,
    required String productName,
    required String category,
    required String totalQuantity,
    required String minimumQuantity,
    required String sizes,
    required String price,
    required String newPrice,
    required String colors,
    required String photos,
    required String description,
  }) =>
      FirebaseFirestore.instance.collection('UserData').doc(refrence).set({
        'product name': productName,
        'category': category,
        'total quantity': totalQuantity,
        'minimum quantity': minimumQuantity,
        'sizes': sizes,
        'price': price,
        'new price': newPrice,
        'colors': colors,
        'photos': photos,
        'description': description,
      });
}
