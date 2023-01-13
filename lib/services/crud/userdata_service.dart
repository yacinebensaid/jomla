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
        'first name': firstName,
        'last name': lastName,
        'phone number': phoneNumber,
        'role': 'user',
        'adminType': null,
      });
}
