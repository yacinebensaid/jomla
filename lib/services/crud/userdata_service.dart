import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth/auth_service.dart';

final userUID = AuthService.firebase().currentUser?.uid;

class DataService {
  static addUserData({
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) =>
      FirebaseFirestore.instance.collection('UserData').doc(userUID).set({
        'first_name': firstName,
        'last_name': lastName,
        'phone_number': phoneNumber,
        'role': 'user',
        'adminType': null,
      });

  static Future<Map<String, dynamic>?> getUserData() async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('UserData')
        .doc(userUID)
        .get();

    if (!docSnapshot.exists) {
      return null; // User data not found in Firestore
    }

    return docSnapshot.data();
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
}
