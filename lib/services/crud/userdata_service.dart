import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth/auth_service.dart';

final userUID = AuthService.firebase().currentUser?.uid;

class UserData {
  final String name, phoneNumber, user_type;
  final bool isAdmin;
  final List owned_products;
  UserData({
    required this.name,
    required this.phoneNumber,
    required this.user_type,
    required this.isAdmin,
    required this.owned_products,
  });
}

class DataService {
  static addUserData({
    required String full_name,
    required String phoneNumber,
    required List owned_products,
    String user_type = "normal",
    bool isAdmin = false,
  }) =>
      FirebaseFirestore.instance.collection('UserData').doc(userUID).set({
        'name': full_name,
        'phone_number': phoneNumber,
        'user_type': user_type,
        'isAdmin': isAdmin,
        'owned_products': owned_products,
      });

  static Future<UserData?> getUserData(String passedUID) async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('UserData')
        .doc(passedUID)
        .get();
    Map<String, dynamic>? userData = docSnapshot.data();
    if (!docSnapshot.exists) {
      return null; // User data not found in Firestore
    }
    return UserData(
        name: userData!['name'],
        phoneNumber: userData['phone_number'],
        user_type: userData['user_type'],
        isAdmin: userData['isAdmin'],
        owned_products: userData['owned_products']);
  }

  static Future getUserDataForOrder(String passedUID) async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('UserData')
        .doc(passedUID)
        .get();

    if (!docSnapshot.exists) {
      return null; // User data not found in Firestore
    }

    return docSnapshot.data();
  }

  static Future<void> deleteOwnedProduct(String productReference) async {
    final userDocRef =
        FirebaseFirestore.instance.collection('UserData').doc(userUID);

    try {
      final userDoc = await userDocRef.get();
      if (!userDoc.exists) {
        throw Exception('User data not found');
      }

      final userData = userDoc.data()!;
      final ownedProducts = List<String>.from(userData['owned_products'] ?? []);
      if (!ownedProducts.contains(productReference)) {
        return; // product not found in owned_products list
      }

      ownedProducts.remove(productReference);
      await userDocRef.update({'owned_products': ownedProducts});
    } catch (e) {
      rethrow;
    }
  }

  static addMarketData({
    required String marketName,
    required String marketCategory,
    required String phoneNumber,
    required String city,
    required String adress,
    required List owned_products,
    String user_type = "market",
    bool isAdmin = false,
  }) =>
      FirebaseFirestore.instance.collection('UserData').doc(userUID).set({
        'name': marketName,
        'market_category': marketCategory,
        'phone_number': phoneNumber,
        'city': city,
        'adress': adress,
        'user_type': user_type,
        'isAdmin': isAdmin,
        'owned_products': owned_products,
      });
}
