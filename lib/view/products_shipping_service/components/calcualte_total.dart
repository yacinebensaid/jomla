import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jomla/services/auth/auth_service.dart';

final userUID = AuthService.firebase().currentUser?.uid;
Future getPurchased(String purchaseID) async {
  String shipping_cat = '';
  String quantity = '';
  String shipping_size = '';

  QuerySnapshot cartQuery = await FirebaseFirestore.instance
      .collection('UserPCF')
      .doc(userUID)
      .collection('purchased')
      .where('reference', isEqualTo: purchaseID)
      .get();

  cartQuery.docs.map((doc) {
    shipping_cat = doc.get('shipping_cat');
    shipping_size = doc.get('shipping_size');
    quantity = doc.get('quantity');
  });
  if (shipping_cat == 'CBM') {
    if (shipping_size == 'S') {
      return int.parse(quantity) * 200;
    } else if (shipping_size == 'S') {
      return int.parse(quantity) * 200;
    } else if (shipping_size == 'L') {
      return int.parse(quantity) * 200;
    } else if (shipping_size == 'XL') {
      return int.parse(quantity) * 200;
    } else if (shipping_size == 'XXL') {
      return int.parse(quantity) * 200;
    }
  } else if (shipping_cat == 'KG') {
    if (shipping_size == '1/2') {
      return int.parse(quantity) * 200;
    } else if (shipping_size == '1') {
      return int.parse(quantity) * 200;
    } else if (shipping_size == '3') {
      return int.parse(quantity) * 200;
    } else if (shipping_size == '5') {
      return int.parse(quantity) * 200;
    } else if (shipping_size == '10') {
      return int.parse(quantity) * 200;
    } else if (shipping_size == '15') {
      return int.parse(quantity) * 200;
    } else if (shipping_size == '20') {
      return int.parse(quantity) * 200;
    } else if (shipping_size == '30') {
      return int.parse(quantity) * 200;
    }
  }
}
