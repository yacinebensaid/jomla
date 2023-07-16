import 'dart:async';

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
            print(total_quantity);

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
            'total_quantity': total_quantity,
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

//
  static Stream<List<CartProduct>> getCart() {
    String? userUID = AuthService.firebase().currentUser?.uid;
    return FirebaseFirestore.instance
        .collection('UserPCF')
        .doc(userUID)
        .collection('cart')
        .snapshots()
        .map((referenceProduct) {
      List<CartProduct> cartData = [];
      final referenceProductData = referenceProduct.docs;

      for (var doc in referenceProductData) {
        CartProduct item = CartProduct(
          reference: doc.get('reference'),
          total_quantity: doc.get('total_quantity'),
          total_price: doc.get('total_price'),
          variations: doc.get('variations'),
        );

        cartData.add(item);
      }
      return cartData;
    });
  }

  static Future<void> modifyProductInCart(
      String reference, String? size, int quantity, int? index) async {
    String? userUID = AuthService.firebase().currentUser?.uid;
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('UserPCF')
        .doc(userUID)
        .collection('cart')
        .doc(reference)
        .get();

    print(snapshot.data());

    if (index == null && size != null) {
      if (snapshot.exists) {
        Map<String, dynamic> newSnapshot = snapshot.data()!;
        newSnapshot['variations'][0]['sizes'][size] = quantity;
        int total_quantity = 0;
        newSnapshot['variations'][0]['sizes'].forEach((size, quantity) {
          total_quantity = total_quantity + quantity as int;
        });

        Product? product =
            await ProductService.getProductDataByReference(reference);
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
        newSnapshot['total_price'] = total_price;
        newSnapshot['total_quantity'] = total_quantity;
        print(newSnapshot);
        FirebaseFirestore.instance
            .collection('UserPCF')
            .doc(userUID)
            .collection('cart')
            .doc(reference)
            .update(newSnapshot);
      }
    } else if (index != null && size != null) {
      if (snapshot.exists) {
        Map<String, dynamic> newSnapshot = snapshot.data()!;
        newSnapshot['variations'][index]['sizes'][size] = quantity;
        int total_quantity = 0;
        int j = 0;
        for (Map vari in newSnapshot['variations']) {
          newSnapshot['variations'][j]['sizes'].forEach((size, quantity) {
            total_quantity = total_quantity + quantity as int;
          });
          j++;
        }

        Product? product =
            await ProductService.getProductDataByReference(reference);
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
        newSnapshot['total_price'] = total_price;
        newSnapshot['total_quantity'] = total_quantity;
        print(newSnapshot);
        FirebaseFirestore.instance
            .collection('UserPCF')
            .doc(userUID)
            .collection('cart')
            .doc(reference)
            .update(newSnapshot);
      }
    } else if (index != null && size == null) {
      if (snapshot.exists) {
        Map<String, dynamic> newSnapshot = snapshot.data()!;
        newSnapshot['variations'][index]['quantity'] = quantity;
        int total_quantity = 0;
        int j = 0;
        for (Map vari in newSnapshot['variations']) {
          total_quantity =
              total_quantity + newSnapshot['variations'][j]['quantity'] as int;
          j++;
        }

        Product? product =
            await ProductService.getProductDataByReference(reference);
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
        newSnapshot['total_price'] = total_price;
        newSnapshot['total_quantity'] = total_quantity;
        print(newSnapshot);
        FirebaseFirestore.instance
            .collection('UserPCF')
            .doc(userUID)
            .collection('cart')
            .doc(reference)
            .update(newSnapshot);
      }
    } else if (index == null && size == null) {
      if (snapshot.exists) {
        Map<String, dynamic> newSnapshot = snapshot.data()!;
        newSnapshot['total_quantity'] = quantity;

        Product? product =
            await ProductService.getProductDataByReference(reference);
        List priceQS = product!.price;
        int price = int.parse(priceQS[0]['price']!);
        if (int.parse(priceQS.last['from']) < quantity) {
          price = int.parse(priceQS.last['price']!);
        } else {
          for (int i = 0; i < priceQS.length; i++) {
            if (int.parse(priceQS[i]['from']!) <= quantity &&
                quantity <= int.parse(priceQS[i]['to']!)) {
              price = int.parse(priceQS[i]['price']!);
              break;
            }
          }
        }
        int total_price = price * quantity;
        newSnapshot['total_price'] = total_price;
        newSnapshot['total_quantity'] = quantity;
        print(newSnapshot);
        FirebaseFirestore.instance
            .collection('UserPCF')
            .doc(userUID)
            .collection('cart')
            .doc(reference)
            .update(newSnapshot);
      }
    }
  }

  static delete_variation({
    required String type,
    required int index,
    required String reference,
    required String? size,
  }) async {
    String? userUID = AuthService.firebase().currentUser?.uid;
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('UserPCF')
        .doc(userUID)
        .collection('cart')
        .doc(reference)
        .get();
    if (type == 'color') {
      if (snapshot.exists) {
        Map<String, dynamic> newSnapshot = snapshot.data()!;
        newSnapshot['variations'].removeAt(index);
        if (newSnapshot['variations'].isNotEmpty) {
          FirebaseFirestore.instance
              .collection('UserPCF')
              .doc(userUID)
              .collection('cart')
              .doc(reference)
              .update(newSnapshot);
        } else {
          delete_from_cart(reference);
        }
      }
    } else if (type == 'size') {
      if (snapshot.exists) {
        Map<String, dynamic> newSnapshot = snapshot.data()!;
        newSnapshot['variations'][0]['sizes'].remove(size);
        if (newSnapshot['variations'][0]['sizes'].isNotEmpty) {
          FirebaseFirestore.instance
              .collection('UserPCF')
              .doc(userUID)
              .collection('cart')
              .doc(reference)
              .update(newSnapshot);
        } else {
          delete_from_cart(reference);
        }
      }
    } else if (type == 'both') {
      if (snapshot.exists) {
        Map<String, dynamic> newSnapshot = snapshot.data()!;
        newSnapshot['variations'][index]['sizes'].remove(size);
        if (newSnapshot['variations'][index]['sizes'].isEmpty) {
          newSnapshot['variations'].removeAt(index);
          if (newSnapshot['variations'].isNotEmpty) {
            FirebaseFirestore.instance
                .collection('UserPCF')
                .doc(userUID)
                .collection('cart')
                .doc(reference)
                .update(newSnapshot);
          } else {
            delete_from_cart(reference);
          }
        } else {
          FirebaseFirestore.instance
              .collection('UserPCF')
              .doc(userUID)
              .collection('cart')
              .doc(reference)
              .update(newSnapshot);
        }
      }
    }
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

    await FirebaseFirestore.instance.collection('UserPCF').doc(userUID).update({
      'favourite': FieldValue.arrayUnion([reference])
    });
  }

  static Future<List> getFav() async {
    String? userUID = AuthService.firebase().currentUser?.uid;
    DocumentSnapshot<Map<String, dynamic>> cartQuery = await FirebaseFirestore
        .instance
        .collection('UserPCF')
        .doc(userUID)
        .get();
    Map? snapshotData = cartQuery.data();
    if (snapshotData != null) {
      List favData = List<String>.from(snapshotData['favourite']);
      if (favData.isEmpty) {
        return ['No products'];
      } else {
        return favData;
      }
    } else {
      return ['No products'];
    }
  }

  static Future<bool> searchInFav(String reference) async {
    if (AuthService.firebase().currentUser != null) {
      String? userUID = AuthService.firebase().currentUser?.uid;
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('UserPCF')
          .doc(userUID)
          .get();
      Map? snapshotData = snapshot.data();
      if (snapshotData != null) {
        final favouriteList = List<String>.from(snapshotData['favourite']);
        bool isReferenceExists = favouriteList.contains(reference);
        return isReferenceExists;
      } else {
        return false;
      }
    } else {
      return false;
    }
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
    FirebaseFirestore.instance.collection('UserPCF').doc(userUID).update({
      'favourite': FieldValue.arrayRemove([reference])
    });
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
        'total_quantity': doc.get('total_quantity'),
        'total_price': doc.get('total_price'),
        'variations': doc.get('variations'),
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

  static Future<List<CartProduct>> getPending() async {
    String? userUID = AuthService.firebase().currentUser?.uid;
    var referenceProduct = await FirebaseFirestore.instance
        .collection('UserPCF')
        .doc(userUID)
        .collection('pending')
        .get();

    List<CartProduct> cartData = [];
    final referenceProductData = referenceProduct.docs;
    for (var doc in referenceProductData) {
      CartProduct item = CartProduct(
        reference: doc.get('reference'),
        total_quantity: doc.get('total_quantity'),
        total_price: doc.get('total_price'),
        variations: doc.get('variations'),
      );

      cartData.add(item);
    }
    return cartData;
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
  static moveItemsToPurchased(String purchaseID, String uid) async {
    String? userUID = AuthService.firebase().currentUser?.uid;
    DocumentReference pendingDocRef = FirebaseFirestore.instance
        .collection('UserPCF')
        .doc(uid)
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
        .doc(uid)
        .collection('purchased')
        .doc(purchaseID);

    WriteBatch batch = FirebaseFirestore.instance.batch();
    batch.set(purchasedDocRef, itemData);
    batch.delete(pendingDocRef);
    await batch.commit();

    Product? productData =
        await ProductService.getProductDataByReference(itemData['reference']);
    if (productData != null) {
      if (productData.available_quantity == null) {
        if (productData.variations != null) {
          if (productData.variations!.isNotEmpty) {
            if (productData.variations![0]['color_details'] != null &&
                productData.variations![0]['size_details'] == null) {
              for (Map vari in itemData['variations']) {
                for (Map variation in productData.variations!) {
                  if (variation['color_details']['image'] == vari['image']) {
                    num newQuantity =
                        int.parse(variation['color_details']['quantity']) -
                            vari['quantity'];
                    DocumentSnapshot productSnapshot = await FirebaseFirestore
                        .instance
                        .collection('ProductData')
                        .doc(itemData['reference'])
                        .get();

                    if (productSnapshot.exists) {
                      Map<String, dynamic> product =
                          productSnapshot.data() as Map<String, dynamic>;
                      product['variations']
                                  [productData.variations!.indexOf(variation)]
                              ['color_details']['quantity'] =
                          newQuantity.toString();
                      FirebaseFirestore.instance
                          .collection('ProductData')
                          .doc(itemData['reference'])
                          .set(product);
                    }
                  }
                }
              }
            } else if (productData.variations![0]['color_details'] == null &&
                productData.variations![0]['size_details'] != null) {
              DocumentSnapshot productSnapshot = await FirebaseFirestore
                  .instance
                  .collection('ProductData')
                  .doc(itemData['reference'])
                  .get();
              Map<String, dynamic> product =
                  productSnapshot.data() as Map<String, dynamic>;
              if (productSnapshot.exists) {
                itemData['variations'][0]['sizes'].forEach((key, value) async {
                  num newQuantity = int.parse(productData.variations![0]
                          ['size_details']['size_quantity'][key]) -
                      value;

                  product['variations'][0]['size_details']['size_quantity']
                      [key] = newQuantity.toString();
                });
                FirebaseFirestore.instance
                    .collection('ProductData')
                    .doc(itemData['reference'])
                    .set(product);
              }
            } else if (productData.variations![0]['color_details'] != null &&
                productData.variations![0]['size_details'] != null) {
              for (Map vari in itemData['variations']) {
                for (Map variation in productData.variations!) {
                  if (variation['color_details']['image'] == vari['image']) {
                    DocumentSnapshot productSnapshot = await FirebaseFirestore
                        .instance
                        .collection('ProductData')
                        .doc(itemData['reference'])
                        .get();
                    Map<String, dynamic> product =
                        productSnapshot.data() as Map<String, dynamic>;
                    ;
                    if (productSnapshot.exists) {
                      vari['sizes'].forEach((key, value) {
                        num newQuantity = int.parse(productData.variations![
                                    productData.variations!.indexOf(variation)]
                                ['size_details']['size_quantity'][key]) -
                            value;

                        product['variations']
                                    [productData.variations!.indexOf(variation)]
                                ['size_details']['size_quantity'][key] =
                            newQuantity.toString();
                      });
                      FirebaseFirestore.instance
                          .collection('ProductData')
                          .doc(itemData['reference'])
                          .set(product);
                    }
                  }
                }
              }
            }
          }
        }
      } else {
        num newQuantity =
            productData.available_quantity! - itemData['total_quantity'];
        DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
            .collection('ProductData')
            .doc(itemData['reference'])
            .get();
        if (productSnapshot.exists) {
          Map<String, dynamic> product =
              productSnapshot.data() as Map<String, dynamic>;
          product['available_quantity'] = newQuantity.toString();
          FirebaseFirestore.instance
              .collection('ProductData')
              .doc(itemData['reference'])
              .set(product);
        }
      }
    }
  }

///////////////////////////////////////////////////////////////////////////////
  static Future<List<CartProduct>> getPurchased() async {
    String? userUID = AuthService.firebase().currentUser?.uid;
    var referenceProduct = await FirebaseFirestore.instance
        .collection('UserPCF')
        .doc(userUID)
        .collection('purchased')
        .get();

    List<CartProduct> cartData = [];
    final referenceProductData = referenceProduct.docs;
    for (var doc in referenceProductData) {
      CartProduct item = CartProduct(
        reference: doc.get('reference'),
        total_quantity: doc.get('total_quantity'),
        total_price: doc.get('total_price'),
        variations: doc.get('variations'),
      );

      cartData.add(item);
    }
    return cartData;
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
  static moveItemsToPurchasedTest(String purchaseID, String uid) async {
    String? userUID = AuthService.firebase().currentUser?.uid;
    DocumentReference pendingDocRef = FirebaseFirestore.instance
        .collection('UserPCF')
        .doc(uid)
        .collection('pending')
        .doc(purchaseID);

    Map<String, dynamic> itemData =
        (await pendingDocRef.get()).data() as Map<String, dynamic>;

    print(itemData);
  }
}
