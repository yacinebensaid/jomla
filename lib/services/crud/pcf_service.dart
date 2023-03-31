import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jomla/services/crud/userdata_service.dart';
import '../auth/auth_service.dart';

final userUID = AuthService.firebase().currentUser?.uid;
final userEMAIL = AuthService.firebase().currentUser?.email;

class UserPCFService {
  ////////////////////CART//////////////////////////////
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

  static delete_from_cart(String reference) {
    FirebaseFirestore.instance
        .collection('UserPCF')
        .doc(userUID)
        .collection('cart')
        .doc(reference)
        .delete();
  }

  ///////////////////////////////////////////////////
  ////////////////////FAVOURITE///////////////////////////////
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

  static Future<List> getFav() async {
    List favData = [];
    QuerySnapshot cartQuery = await FirebaseFirestore.instance
        .collection('UserPCF')
        .doc(userUID)
        .collection('favourit')
        .get();
    cartQuery.docs.forEach((doc) {
      Map<String, String> item = {
        'reference': doc.get('reference'),
      };
      favData.add(item);
    });
    if (favData.isEmpty) {
      return ['No products'];
    } else {
      return favData;
    }
  }

  static Future<Object> searchInFav(String reference) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('UserPCF')
        .doc(userUID)
        .collection('favourit')
        .where('reference', isEqualTo: reference)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  static delete_from_fav(String reference) {
    FirebaseFirestore.instance
        .collection('UserPCF')
        .doc(userUID)
        .collection('favourit')
        .doc(reference)
        .delete();
  }

///////////////////////////////////////////////////////
///////////////////////////PENDING/////////////////////////////////////

  static moveItemsToPending() async {
    Map<String, dynamic>? userdata = await DataService.getUserData();
    final userFirstName = userdata!['first_name'];
    final userLastName = userdata['last_name'];
    final fullname = userFirstName + ' ' + userLastName;
    final userPhonenumber = userdata['phone_number'];

    QuerySnapshot cartQuery = await FirebaseFirestore.instance
        .collection('UserPCF')
        .doc(userUID)
        .collection('cart')
        .get();

    WriteBatch batch = FirebaseFirestore.instance.batch();
    cartQuery.docs.forEach((doc) async {
      DocumentReference cartDocRef = FirebaseFirestore.instance
          .collection('UserPCF')
          .doc(userUID)
          .collection('cart')
          .doc(doc.id);
      DateTime now = DateTime.now();
      String formattedDate = '${now.year}${now.month}${now.day}';
      String formattedTime = '${now.hour}${now.minute}${now.second}';

      final purchaseID =
          userUID! + formattedDate + formattedTime + doc.get('reference');
      DocumentReference pendingDocRef = FirebaseFirestore.instance
          .collection('UserPCF')
          .doc(userUID)
          .collection('pending')
          .doc(purchaseID);
      Map<String, dynamic> itemData = {
        'reference': doc.get('reference'),
        'quantity': doc.get('quantity'),
        'total_price': doc.get('total_price'),
        'uid': userUID,
        'purchaseID': purchaseID,
        'timestamp': Timestamp.now(),
        'full_name': fullname,
        'phone_number': userPhonenumber,
        'email': userEMAIL,
      };
      batch.set(pendingDocRef, itemData);
      batch.delete(cartDocRef);
    });
    await batch.commit();
  }

  static Future<List> getPending() async {
    List pendingData = [];
    QuerySnapshot cartQuery = await FirebaseFirestore.instance
        .collection('UserPCF')
        .doc(userUID)
        .collection('pending')
        .get();

    cartQuery.docs.forEach((doc) {
      Map<String, String> item = {
        'reference': doc.get('reference'),
        'quantity': doc.get('quantity'),
        'total_price': doc.get('total_price')
      };
      pendingData.add(item);
    });
    if (pendingData.isEmpty) {
      return ['No products'];
    } else {
      return pendingData;
    }
  }

  static Future<Map<String, List<Map<String, dynamic>>>>
      getAllPendingOrders() async {
    QuerySnapshot usersQuery =
        await FirebaseFirestore.instance.collection('UserPCF').get();

    List<Future<void>> queryFutures = [];
    Map<String, List<Map<String, dynamic>>> allPendingOrders = {};

    usersQuery.docs.forEach((userDoc) {
      String userUID = userDoc.id;
      Future<void> queryFuture =
          userDoc.reference.collection('pending').get().then((pendingQuery) {
        List<Map<String, dynamic>> pendingOrders = [];
        pendingQuery.docs.forEach((doc) {
          Map<String, dynamic> orderData = doc.data();
          orderData['id'] = doc.id;
          pendingOrders.add(orderData);
        });
        allPendingOrders[userUID] = pendingOrders;
      });
      queryFutures.add(queryFuture);
    });

    await Future.wait(queryFutures);

    return allPendingOrders;
  }

///////////////////////////////////////////////////////
///////////////////////////////PURCHASED//////////////////////////////////////
  static moveItemsToPurchased(String purchaseID) async {
    DocumentReference pendingDocRef = FirebaseFirestore.instance
        .collection('UserPCF')
        .doc(userUID)
        .collection('pending')
        .doc(purchaseID);

    Map<String, dynamic> itemData =
        (await pendingDocRef.get()).data() as Map<String, dynamic>;

    itemData.remove('email');
    itemData.remove('phone_number');
    itemData.remove('uid');
    itemData.remove('full_name');

    itemData['order_confirmation_date'] = Timestamp.now();
    itemData['order_confirmed_by'] = userUID;

    DocumentReference purchasedDocRef = FirebaseFirestore.instance
        .collection('UserPCF')
        .doc(userUID)
        .collection('purchased')
        .doc(purchaseID);

    WriteBatch batch = FirebaseFirestore.instance.batch();
    batch.set(purchasedDocRef, itemData);
    batch.delete(pendingDocRef);
    await batch.commit();
  }

  static Future<List> getPurchased() async {
    List purchasedData = [];
    QuerySnapshot cartQuery = await FirebaseFirestore.instance
        .collection('UserPCF')
        .doc(userUID)
        .collection('purchased')
        .get();

    cartQuery.docs.forEach((doc) {
      Map<String, String> item = {
        'reference': doc.get('reference'),
        'quantity': doc.get('quantity'),
        'total_price': doc.get('total_price'),
      };
      purchasedData.add(item);
    });
    if (purchasedData.isEmpty) {
      return ['No products'];
    } else {
      return purchasedData;
    }
  }
/////////////////////////////////////////////////////////////////////

}
