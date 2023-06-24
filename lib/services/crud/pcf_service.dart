import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jomla/services/crud/userdata_service.dart';
import 'package:jomla/view/products_card/product.dart';
import '../auth/auth_service.dart';
import 'product_service.dart';

class CartProduct {
  final String reference;
  final num total_quantity;
  final num total_price;
  final List? variations;

  CartProduct(
      {required this.reference,
      required this.total_quantity,
      required this.total_price,
      required this.variations});
}

class UserPCFService {
  ////////////////////CART//////////////////////////////
  static addToCart({
    required Map order,
  }) async {
    if (order.isNotEmpty && order != {}) {
      String? userUID = AuthService.firebase().currentUser?.uid;
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('UserPCF')
          .doc(userUID!)
          .collection('cart')
          .doc(order['reference'])
          .get();

      Map<String, dynamic>? result = snapshot.data();

      if (result != null) {
        if (result['variations'] != null) {
          if (result['variations'][0]['image'] != null &&
              result['variations'][0]['sizes'] == null) {
            /////////////////////////////////////////////////////
            int i = 0;
            bool changed = false;
            for (Map vari in result['variations']) {
              if (vari['color_name'] == order['color_name']) {
                result['variations'][i]['quantity'] = order['quantity'];
                changed = true;
                break;
              }
              i++;
            }
            if (!changed) {
              result['variations'].add(order);
            }
            int total_quantity = 0;
            for (Map vari in result['variations']) {
              total_quantity = total_quantity + vari['quantity'] as int;
            }

            Product? product = await ProductService.getProductDataByReference(
                order['reference']);
            List priceQS = product!.price;
            int price = int.parse(priceQS[0]['price']!);
            if (int.parse(priceQS.last['from']) < total_quantity) {
              price = int.parse(priceQS.last['price']!);
            } else {
              for (int i = 0; i < priceQS.length; i++) {
                if (int.parse(priceQS[i]['from']!) <= total_quantity &&
                    total_quantity <= int.parse(priceQS[i]['to']!)) {
                  price = int.parse(priceQS[i]['price']!);
                  break;
                }
              }
            }
            int total_price = price * total_quantity;

            FirebaseFirestore.instance
                .collection('UserPCF')
                .doc(userUID)
                .collection('cart')
                .doc(order['reference'])
                .set({
              'reference': result['reference'],
              'total_quantity': total_quantity,
              'total_price': total_price,
              'variations': result['variations'],
            });
          } else if (result['variations'][0]['image'] == null &&
              result['variations'][0]['sizes'] != null) {
            /////////////////////////////////////////////////////
            order['sizes'].forEach((size, quantity) {
              result['variations'][0]['sizes'][size] = quantity;
            });
            int total_quantity = 0;
            result['variations'][0]['sizes'].forEach((size, quantity) {
              total_quantity = total_quantity + quantity as int;
            });

            Product? product = await ProductService.getProductDataByReference(
                order['reference']);
            List priceQS = product!.price;
            int price = int.parse(priceQS[0]['price']!);
            if (int.parse(priceQS.last['from']) < total_quantity) {
              price = int.parse(priceQS.last['price']!);
            } else {
              for (int i = 0; i < priceQS.length; i++) {
                if (int.parse(priceQS[i]['from']!) <= total_quantity &&
                    total_quantity <= int.parse(priceQS[i]['to']!)) {
                  price = int.parse(priceQS[i]['price']!);
                  break;
                }
              }
            }
            int total_price = price * total_quantity;

            FirebaseFirestore.instance
                .collection('UserPCF')
                .doc(userUID)
                .collection('cart')
                .doc(order['reference'])
                .set({
              'reference': result['reference'],
              'total_quantity': total_quantity,
              'total_price': total_price,
              'variations': result['variations'],
            });
          } else if (result['variations'][0]['image'] != null &&
              result['variations'][0]['sizes'] != null) {
            /////////////////////////////////////////////////////
            int i = 0;
            bool changed = false;
            for (Map vari in result['variations']) {
              if (vari['color_name'] == order['color_name']) {
                order['sizes'].forEach((size, quantity) {
                  result['variations'][i]['sizes'][size] = quantity;
                });
                changed = true;
                break;
              }
              i++;
            }
            if (!changed) {
              result['variations'].add(order);
            }
            int total_quantity = 0;
            int j = 0;
            for (Map vari in result['variations']) {
              result['variations'][j]['sizes'].forEach((size, quantity) {
                total_quantity = total_quantity + quantity as int;
              });
              j++;
            }

            Product? product = await ProductService.getProductDataByReference(
                order['reference']);
            List priceQS = product!.price;
            int price = int.parse(priceQS[0]['price']!);
            if (int.parse(priceQS.last['from']) < total_quantity) {
              price = int.parse(priceQS.last['price']!);
            } else {
              for (int i = 0; i < priceQS.length; i++) {
                if (int.parse(priceQS[i]['from']!) <= total_quantity &&
                    total_quantity <= int.parse(priceQS[i]['to']!)) {
                  price = int.parse(priceQS[i]['price']!);
                  break;
                }
              }
            }
            int total_price = price * total_quantity;

            FirebaseFirestore.instance
                .collection('UserPCF')
                .doc(userUID)
                .collection('cart')
                .doc(order['reference'])
                .set({
              'reference': result['reference'],
              'total_quantity': total_quantity,
              'total_price': total_price,
              'variations': result['variations'],
            });
          }
        } else {
          int total_quantity = result['total_quantity'] = order['quantity'];
          int total_price = result['total_price'] = order['total_price'];
          FirebaseFirestore.instance
              .collection('UserPCF')
              .doc(userUID)
              .collection('cart')
              .doc(order['reference'])
              .set({
            'reference': result['reference'],
            'total_quantity': total_quantity,
            'total_price': total_price,
            'variations': result['variations'],
          });
        }
      } else {
        if (order['image'] != null && order['sizes'] == null) {
          FirebaseFirestore.instance
              .collection('UserPCF')
              .doc(userUID)
              .collection('cart')
              .doc(order['reference'])
              .set({
            'reference': order['reference'],
            'total_quantity': order['quantity'],
            'total_price': order['total_price'],
            'variations': [
              {
                'color_name': order['color_name'],
                'image': order['image'],
                'quantity': order['quantity'],
                'sizes': order['sizes'],
              }
            ]
          });
          /////////////////////////////////////////////////////////////////////////////////////////////////////////
        } else if ((order['image'] == null && order['sizes'] != null) ||
            (order['image'] != null && order['sizes'] != null)) {
          int total_quantity = 0;
          order['sizes'].forEach((size, quantity) {
            total_quantity = total_quantity + quantity as int;
          });
          Product? product = await ProductService.getProductDataByReference(
              order['reference']);
          List priceQS = product!.price;
          int price = int.parse(priceQS[0]['price']!);
          if (int.parse(priceQS.last['from']) < total_quantity) {
            price = int.parse(priceQS.last['price']!);
          } else {
            for (int i = 0; i < priceQS.length; i++) {
              if (int.parse(priceQS[i]['from']!) <= total_quantity &&
                  total_quantity <= int.parse(priceQS[i]['to']!)) {
                price = int.parse(priceQS[i]['price']!);
                break;
              }
            }
          }
          int total_price = price * total_quantity;

          FirebaseFirestore.instance
              .collection('UserPCF')
              .doc(userUID)
              .collection('cart')
              .doc(order['reference'])
              .set({
            'reference': order['reference'],
            'total_quantity': order['quantity'],
            'total_price': total_price,
            'variations': [
              {
                'color_name': order['color_name'],
                'image': order['image'],
                'quantity': order['quantity'],
                'sizes': order['sizes'],
              }
            ]
          });
          //////////////////////////////////////////////////////////////////////////////////////////
        } else if (order['image'] == null && order['sizes'] == null) {
          FirebaseFirestore.instance
              .collection('UserPCF')
              .doc(userUID)
              .collection('cart')
              .doc(order['reference'])
              .set({
            'reference': order['reference'],
            'total_quantity': order['quantity'],
            'total_price': order['total_price'],
            'variations': null
          });
        }
      }
    }
  }

  static Future<List<CartProduct>> getCart() async {
    String? userUID = AuthService.firebase().currentUser?.uid;
    List<CartProduct> cartData = [];
    QuerySnapshot cartQuery = await FirebaseFirestore.instance
        .collection('UserPCF')
        .doc(userUID)
        .collection('cart')
        .get();

    cartQuery.docs.forEach((doc) {
      CartProduct item = CartProduct(
          reference: doc.get('reference'),
          total_quantity: doc.get('total_quantity'),
          total_price: doc.get('total_price'),
          variations: doc.get('variations'));

      cartData.add(item);
    });
    return cartData;
  }

  static delete_from_cart(String reference) {
    String? userUID = AuthService.firebase().currentUser?.uid;
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
  }) async {
    String? userUID = AuthService.firebase().currentUser?.uid;
    // Get a reference to the document
    final documentReference =
        FirebaseFirestore.instance.collection('ProductData').doc(reference);

// Get the current document data
    final documentSnapshot = await documentReference.get();
    final data = documentSnapshot.data();

    if (data != null) {
      final currentLikers = List<String>.from(data['likers']);

      // Check if the user is already in the likers list
      if (!currentLikers.contains(userUID)) {
        // Add the user to the likers list
        currentLikers.add(userUID!);

        // Update the document with the updated likers list
        await documentReference.update({'likers': currentLikers});
      }
    }

// Get the current list of likers

    FirebaseFirestore.instance
        .collection('UserPCF')
        .doc(userUID)
        .collection('favourit')
        .doc(reference)
        .set({
      'reference': reference,
    });
  }

  static Future<List> getFav() async {
    String? userUID = AuthService.firebase().currentUser?.uid;
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
    String? userUID = AuthService.firebase().currentUser?.uid;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('UserPCF')
        .doc(userUID)
        .collection('favourit')
        .where('reference', isEqualTo: reference)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  static deletefromfav(String reference) async {
    String? userUID = AuthService.firebase().currentUser?.uid;
    // Get a reference to the document
    final documentReference =
        FirebaseFirestore.instance.collection('ProductData').doc(reference);

// Get the current document data
    final documentSnapshot = await documentReference.get();
    final data = documentSnapshot.data();
    if (data != null) {
      final currentLikers = List<String>.from(data['likers']);

      if (currentLikers.contains(userUID)) {
        // Add the user to the likers list
        currentLikers.remove(userUID!);

// Update the document with the updated likers list
        await documentReference.update({'likers': currentLikers});
      }
// Add a new UID to the likers list

    }
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
    String? userUID = AuthService.firebase().currentUser?.uid;
    String? userEMAIL = AuthService.firebase().currentUser?.email;
    UserData? userdata = await DataService.getUserDataStream(userUID!).first;

    final fullname = userdata!.name;
    final userPhonenumber = userdata.phoneNumber;

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
          userUID + formattedDate + formattedTime + doc.get('reference');
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
    String? userUID = AuthService.firebase().currentUser?.uid;
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
    String? userUID = AuthService.firebase().currentUser?.uid;
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
    String? userUID = AuthService.firebase().currentUser?.uid;
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
        'purchaseID': doc.get('purchaseID'),
      };
      purchasedData.add(item);
    });
    if (purchasedData.isEmpty) {
      return ['No products'];
    } else {
      return purchasedData;
    }
  }

  static Future<bool> hasPurchasedItem(String reference) async {
    List purchasedData = await getPurchased();

    for (var item in purchasedData) {
      if (item['reference'] == reference) {
        return true;
      }
    }

    return false;
  }

/////////////////////////////////////////////////////////////////////

}
