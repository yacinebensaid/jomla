import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jomla/services/auth/auth_service.dart';

final userUID = AuthService.firebase().currentUser?.uid;
Future<int> totalStoringPrice(List products) async {
  int totalPrice = 0;
  for (String product in products) {
    int oneProductPrice = await getPurchased(product);
    totalPrice = totalPrice + oneProductPrice;
  }
  return totalPrice;
}

Future<int> getPurchased(String purchaseID) async {
  int oneProductPrice = 0;
  int quantity = 1;
  String shipping_size = '';

  QuerySnapshot cartQuery = await FirebaseFirestore.instance
      .collection('UserPCF')
      .doc(userUID)
      .collection('purchased')
      .where('purchaseID', isEqualTo: purchaseID)
      .get();
  cartQuery.docs.forEach((doc) {
    shipping_size = doc.get('shipping_size');
    quantity = int.parse(doc.get('quantity'));
  });
  if (shipping_size == 'S') {
    oneProductPrice = quantity * 50;
  } else if (shipping_size == 'L') {
    oneProductPrice = quantity * 100;
  } else if (shipping_size == 'XL') {
    oneProductPrice = quantity * 150;
  } else if (shipping_size == 'XXL') {
    oneProductPrice = quantity * 200;
  } else {
    oneProductPrice = quantity * 200;
  }
  return oneProductPrice;
}
