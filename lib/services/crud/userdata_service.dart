import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth/auth_service.dart';

class UserData {
  final String name, phoneNumber, user_type, id;
  final String? marketCategory;
  final String? description;
  final String? city;
  final String? adress;
  final String? picture;
  final String? dropshipperID;
  final List? followers;
  final List? sales;
  final List following;
  final bool isAdmin;
  final List? owned_products;
  UserData({
    required this.dropshipperID,
    required this.id,
    required this.description,
    required this.name,
    required this.following,
    required this.followers,
    required this.sales,
    required this.picture,
    required this.user_type,
    required this.marketCategory,
    required this.phoneNumber,
    required this.city,
    required this.isAdmin,
    required this.adress,
    required this.owned_products,
  });
}

class DropshipperData {
  final String name, phoneNumber, owner;
  final String? description;
  final String? picture;
  final String? logo;
  final String dropshipperID;
  final List followers;
  final List sales;
  final List owned_products;
  DropshipperData({
    required this.owner,
    required this.dropshipperID,
    required this.description,
    required this.logo,
    required this.name,
    required this.followers,
    required this.sales,
    required this.picture,
    required this.phoneNumber,
    required this.owned_products,
  });
}

class DataService {
  final userUID = AuthService.firebase().currentUser?.uid;
  addUserData({
    required String full_name,
    required String phoneNumber,
    required List following,
    List? owned_products = null,
    String user_type = "normal",
    bool isAdmin = false,
  }) {
    FirebaseFirestore.instance.collection('UserData').doc(userUID).set({
      'uid': userUID,
      'name': full_name,
      'phone_number': phoneNumber,
      'user_type': user_type,
      'isAdmin': isAdmin,
      'following': following,
      'owned_products': owned_products,
    });
    FirebaseFirestore.instance.collection('UserPCF').doc(userUID).set({
      'uid': userUID,
      'name': full_name,
      'phone_number': phoneNumber,
      'user_type': user_type,
      'favourite': [],
    });
  }

  static Stream<UserData?> getUserDataStream(String passedUID) {
    return FirebaseFirestore.instance
        .collection('UserData')
        .doc(passedUID)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) {
        return null; // User data not found in Firestore
      }
      Map<String, dynamic>? userData = snapshot.data();
      return UserData(
        id: userData!['uid'],
        marketCategory: userData['market_category'],
        name: userData['name'],
        followers: userData['followers'],
        following: userData['following'],
        sales: userData['sales'],
        picture: userData['profile_picture'],
        phoneNumber: userData['phone_number'],
        user_type: userData['user_type'],
        isAdmin: userData['isAdmin'],
        dropshipperID: userData['dropshipperID'],
        owned_products: userData['owned_products'],
        adress: userData['adress'],
        city: userData['city'],
        description: userData['description'],
      );
    });
  }

  static Future<UserData?> getUserDataForOrder(String passedUID) async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('UserData')
        .doc(passedUID)
        .get();

    if (docSnapshot.exists) {
      final Map<String, dynamic> marketData = docSnapshot.data()!;
      UserData markttemp = UserData(
          id: marketData['uid'],
          isAdmin: marketData['isAdmin'],
          name: marketData['name'],
          followers: marketData['followers'],
          sales: marketData['sales'],
          following: marketData['following'],
          picture: marketData['profile_picture'],
          marketCategory: marketData['market_category'],
          phoneNumber: marketData['phone_number'],
          dropshipperID: marketData['dropshipperID'],
          owned_products: marketData['owned_products'],
          adress: marketData['adress'],
          city: marketData['city'],
          user_type: marketData['user_type'],
          description: marketData['description']);
      return markttemp; // User data not found in Firestore
    } else {
      return null;
    }
  }

  Future<void> deleteOwnedProduct(String productReference) async {
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

  addMarketData({
    required String marketName,
    required String marketCategory,
    required String phoneNumber,
    required String city,
    required String adress,
    required String? description,
  }) {
    FirebaseFirestore.instance.collection('UserData').doc(userUID).set({
      'uid': userUID,
      'name': marketName,
      'market_category': marketCategory,
      'phone_number': phoneNumber,
      'description': description,
      'followers': [],
      'sales': [],
      'following': [],
      'city': city,
      'adress': adress,
      'user_type': "market",
      'isAdmin': false,
      'owned_products': [],
    });
    FirebaseFirestore.instance.collection('UserPCF').doc(userUID).set({
      'uid': userUID,
      'name': marketName,
      'phone_number': phoneNumber,
      'user_type': "market",
      'favourite': [],
    });
  }

  static Future<List<UserData>> getMarketData() async {
    List<UserData> Markets = [];
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('UserData')
        .where('user_type', isEqualTo: 'market')
        .limit(15)
        .get();
    final List<Map> marketData =
        snapshot.docs.map((doc) => doc.data() as Map).toList();
    for (Map marketDataMap in marketData) {
      UserData markttemp = UserData(
          id: marketDataMap['uid'],
          isAdmin: marketDataMap['isAdmin'],
          name: marketDataMap['name'],
          picture: marketDataMap['profile_picture'],
          marketCategory: marketDataMap['market_category'],
          phoneNumber: marketDataMap['phone_number'],
          followers: marketDataMap['followers'],
          following: marketDataMap['following'],
          sales: marketDataMap['sales'],
          dropshipperID: null,
          owned_products: marketDataMap['owned_products'],
          adress: marketDataMap['adress'],
          city: marketDataMap['city'],
          user_type: marketDataMap['user_type'],
          description: marketDataMap['description']);
      Markets.add(markttemp);
    }

    return Markets;
  }

  void updateMarketData(
      {required String marketName,
      required String phoneNumber,
      required String? description,
      required final imageUrl}) {
    FirebaseFirestore.instance.collection('UserData').doc(userUID).update({
      'name': marketName,
      'phone_number': phoneNumber,
      'description': description,
      'profile_picture': imageUrl,
    });
  }

  void createDropShipper(String? picture, String name, String? description,
      String? logoFile) async {
    UserData? userdata = await DataService.getUserDataStream(userUID!).first;
    String _phoneNumber = userdata!.phoneNumber;
    FirebaseFirestore.instance.collection('UserData').doc(userUID).update({
      'dropshipperID': 'DROPSHIPID$userUID',
      'user_type': 'dropshipper',
    });
    FirebaseFirestore.instance
        .collection('DropshipMarkets')
        .doc('DROPSHIPID$userUID')
        .set({
      'dropshipperID': 'DROPSHIPID$userUID',
      'owner': userUID,
      'picture': picture,
      'name': name,
      'description': description,
      'phone_number': _phoneNumber,
      'logoFile': logoFile,
      'followers': [],
      'sales': [],
      'owned_products': [],
    });
  }

  static Stream<DropshipperData?> getDropshipperData(String passedUID) {
    return FirebaseFirestore.instance
        .collection('DropshipMarkets')
        .doc(passedUID)
        .snapshots()
        .map((docSnapshot) {
      if (docSnapshot.exists) {
        final Map<String, dynamic> dropshipperData = docSnapshot.data()!;
        DropshipperData markttemp = DropshipperData(
            owner: dropshipperData['owner'],
            logo: dropshipperData['logoFile'],
            name: dropshipperData['name'],
            followers: dropshipperData['followers'],
            sales: dropshipperData['sales'],
            picture: dropshipperData['profile_picture'],
            phoneNumber: dropshipperData['phone_number'],
            dropshipperID: dropshipperData['dropshipperID'],
            owned_products: dropshipperData['owned_products'],
            description: dropshipperData['description']);
        return markttemp;
      } else {
        return null;
      }
    });
  }

  void updateDropshipData({
    required String dropshipName,
    required String phoneNumber,
    required String? description,
    required final imageUrl,
    required String? logoURL,
    required String dropshipperID,
  }) {
    FirebaseFirestore.instance
        .collection('DropshipMarkets')
        .doc(dropshipperID)
        .update({
      'name': dropshipName,
      'phone_number': phoneNumber,
      'description': description,
      'profile_picture': imageUrl,
      'logoFile': logoURL,
    });
  }

  void followFunction(String passedUid) async {
    //////////////////////////////////////////
    UserData? _userData = await getUserDataStream(passedUid).first;
    if (_userData != null) {
      if (_userData.user_type == 'market') {
        final userDocRef =
            FirebaseFirestore.instance.collection('UserData').doc(passedUid);
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          final userDocSnapshot = await transaction.get(userDocRef);
          final List<dynamic> currentFollowers =
              userDocSnapshot.get('followers');
          currentFollowers.add(userUID);
          transaction.update(userDocRef, {'followers': currentFollowers});
        });
      } else {
        final userDocRef = FirebaseFirestore.instance
            .collection('DropshipMarkets')
            .doc(_userData.dropshipperID);
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          final userDocSnapshot = await transaction.get(userDocRef);
          final List<dynamic> currentFollowers =
              userDocSnapshot.get('followers');
          currentFollowers.add(userUID);
          transaction.update(userDocRef, {'followers': currentFollowers});
        });
      }
    }

    //////////////////////////////////////////
    final currentuserDocRef =
        FirebaseFirestore.instance.collection('UserData').doc(userUID);
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final userDocSnapshot = await transaction.get(currentuserDocRef);
      final List<dynamic> currentFollowering = userDocSnapshot.get('following');
      currentFollowering.add(passedUid);
      transaction.update(currentuserDocRef, {'following': currentFollowering});
    });
  }

  void unfollowFunction(String passedUid) async {
    //////////////////////////////////////////
    UserData? _userData = await getUserDataStream(passedUid).first;
    if (_userData != null) {
      if (_userData.user_type == 'market') {
        final userDocRef =
            FirebaseFirestore.instance.collection('UserData').doc(passedUid);
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          final userDocSnapshot = await transaction.get(userDocRef);
          final List<dynamic> currentFollowers =
              userDocSnapshot.get('followers');
          currentFollowers.remove(userUID);
          transaction.update(userDocRef, {'followers': currentFollowers});
        });
      } else {
        final userDocRef = FirebaseFirestore.instance
            .collection('DropshipMarkets')
            .doc(_userData.dropshipperID);
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          final userDocSnapshot = await transaction.get(userDocRef);
          final List<dynamic> currentFollowers =
              userDocSnapshot.get('followers');
          currentFollowers.remove(userUID);
          transaction.update(userDocRef, {'followers': currentFollowers});
        });
      }
    }

    //////////////////////////////////////////
    final currentuserDocRef =
        FirebaseFirestore.instance.collection('UserData').doc(userUID);
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final userDocSnapshot = await transaction.get(currentuserDocRef);
      final List<dynamic> currentFollowering = userDocSnapshot.get('following');
      currentFollowering.remove(passedUid);
      transaction.update(currentuserDocRef, {'following': currentFollowering});
    });
  }
}
