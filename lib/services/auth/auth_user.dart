// all we want to do is to hide th user credentials from the ui and that's by:
// 1 - creating a class
// 2 - predefine a variable
// 3 - make an instance of the same class inside the class to return a boole value of emailverified
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

// immuatable is important so if we make a copy of this user informations, the copies must be const
@immutable
class AuthUser {
  final String? email;
  final bool? isEmailVerified;
  final String uid;
  const AuthUser({
    required this.email,
    required this.isEmailVerified,
    required this.uid,
  });
  factory AuthUser.fromFirebase(User user) => AuthUser(
        email: user.email,
        isEmailVerified: user.emailVerified,
        uid: user.uid,
      );
}
