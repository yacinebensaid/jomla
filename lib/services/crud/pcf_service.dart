import 'package:cloud_firestore/cloud_firestore.dart';

import '../auth/auth_service.dart';

final userUID = AuthService.firebase().currentUser?.uid;

class UserPCFService {
  static addToCart({
    required String reference,
    required String quantity,
    required String total_price,
  }) =>
      FirebaseFirestore.instance
          .collection('UserPCF')
          .doc(userUID)
          .collection('cart')
          .doc(reference)
          .set({
        'reference': reference,
        'quantity': quantity,
        'total_price': total_price,
      });
  static addToFav({
    required String reference,
  }) =>
      FirebaseFirestore.instance
          .collection('UserPCF')
          .doc(userUID)
          .collection('favourit')
          .doc(reference)
          .set({
        'reference': reference,
      });
  static addToPurchased({
    required String reference,
    required String quantity,
    required String total_price,
    required String date,
  }) =>
      FirebaseFirestore.instance
          .collection('UserPCF')
          .doc(userUID)
          .collection('purchased')
          .doc(reference)
          .set({
        'reference': reference,
        'quantity': quantity,
        'total_price': total_price,
        'date': date,
      });

///////////////////////////////////////////////

  static Future<List> getCart() async {
    List cartData = [];
    QuerySnapshot cartQuery = await FirebaseFirestore.instance
        .collection('UserPCF')
        .doc(userUID)
        .collection('cart')
        .get();

    cartQuery.docs.forEach((doc) {
      Map<String, String> item = {
        'reference': doc.get('reference'),
        'quantity': doc.get('quantity'),
        'total_price': doc.get('total_price')
      };
      cartData.add(item);
    });
    if (cartData.isEmpty) {
      return ['No products'];
    } else {
      return cartData;
    }
  }

  static Future<List> searchInCart(String reference) async {
    List products = [];
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('UserPCF')
        .doc(userUID)
        .collection('cart')
        .where('reference', isEqualTo: reference)
        .get();
    snapshot.docs.forEach((doc) {
      Map<String, String> item = {
        'reference': doc.get('reference'),
        'quantity': doc.get('quantity'),
        'total_price': doc.get('total_price')
      };
      products.add(item);
    });
    if (products.isEmpty) {
      return ['product does not exist'];
    } else {
      return products;
    }
  }

  static delete_from_cart(String reference) {
    FirebaseFirestore.instance
        .collection('UserPCF')
        .doc(userUID)
        .collection('cart')
        .doc(reference)
        .delete();
  }

////////////////////////////////////////////// needs work ///////////////
  ///
  ///
  static Future<Object> searchInFav(String reference) async {
    List products = [];
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('UserPCF')
        .doc(userUID)
        .collection('favourit')
        .where('reference', isEqualTo: reference)
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

  static Future<Object> getPurchased() async {
    List products = [];
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('UserPCF')
        .doc(userUID)
        .collection('purchased')
        .get();
    snapshot.docs.forEach((element) {
      products.add(element.data());
    });
    if (products.isEmpty) {
      return 'No products';
    } else {
      return products;
    }
  }
}
