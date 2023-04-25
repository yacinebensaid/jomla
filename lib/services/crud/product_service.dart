import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jomla/services/auth/auth_service.dart';
import 'package:jomla/services/crud/userdata_service.dart';
import 'package:jomla/view/products_card/product.dart';
import 'crud_exceptions.dart';

class ProductService {
  static Future<String> productExists({
    required String mainCategory,
    required String productName,
    required String subCategory,
    required String availableQuantity,
    required String minimumQuantity,
    required List sizes,
    required String price,
    required List colors,
    required String offers,
    required String mainPhoto,
    required List photos,
    required String description,
  }) async {
    final userUID = AuthService.firebase().currentUser?.uid;
    DateTime now = DateTime.now();
    String formattedDate = '${now.microsecond}';
    String reference = userUID! + '_' + formattedDate;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('ProductData')
        .doc(reference)
        .get();

    if (snapshot.exists) {
      return 'Product already exists';
    } else {
      try {
        FirebaseFirestore.instance
            .collection('ProductData')
            .doc(reference)
            .set({
          'main_category': mainCategory,
          'sub_category': subCategory,
          'reference': reference,
          'product_name': productName,
          'available_quantity': availableQuantity,
          'minimum_quantity': minimumQuantity,
          'sizes': sizes,
          'price': price,
          'offers': offers,
          'colors': colors,
          'main_photo': mainPhoto,
          'photos': photos,
          'description': description,
          'owner': userUID,
          'section': '',
        });
        addProductToUser(userUID, reference);
        return 'Product saved, Product $productName';
      } on FaildToRegisterProduct {
        return 'Could not register the product';
      }
    }
  }

  static Future<DocumentSnapshot> getProductDataByReference(
      String productReference) async {
    DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
        .collection('ProductData')
        .doc(productReference)
        .get();

    return productSnapshot;
  }

  static Future<String> updateProduct({
    required String reference,
    String? mainCategory,
    String? productName,
    String? subCategory,
    String? availableQuantity,
    String? minimumQuantity,
    List? sizes,
    String? price,
    List? colors,
    String? offers,
    String? description,
    String? main_photo,
    List? productPhotos,
  }) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('ProductData')
        .doc(reference)
        .get();

    if (!snapshot.exists) {
      return 'Product not found';
    }

    Map<String, dynamic> updatedFields = {};
    if (mainCategory != null) {
      updatedFields['main_category'] = mainCategory;
    }
    if (productName != null) {
      updatedFields['product_name'] = productName;
    }
    if (subCategory != null) {
      updatedFields['sub_category'] = subCategory;
    }
    if (availableQuantity != null) {
      updatedFields['available_quantity'] = availableQuantity;
    }
    if (minimumQuantity != null) {
      updatedFields['minimum_quantity'] = minimumQuantity;
    }
    if (sizes != null) {
      updatedFields['sizes'] = sizes;
    }
    if (price != null) {
      updatedFields['price'] = price;
    }
    if (colors != null) {
      updatedFields['colors'] = colors;
    }
    if (offers != null) {
      updatedFields['offers'] = offers;
    }

    if (description != null) {
      updatedFields['description'] = description;
    }
    if (main_photo != null) {
      updatedFields['description'] = main_photo;
    }
    if (productPhotos != null) {
      updatedFields['description'] = productPhotos;
    }

    try {
      await FirebaseFirestore.instance
          .collection('ProductData')
          .doc(reference)
          .update(updatedFields);

      return 'Product updated';
    } catch (e) {
      return 'Could not update the product';
    }
  }

  static Future<List> searchProductByChoice(String choice, String value) async {
    List products = [];
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('ProductData')
        .where(choice, isEqualTo: value)
        .get();
    snapshot.docs.forEach((element) {
      products.add(element.data());
    });
    if (products.isEmpty) {
      return ['product does not exist'];
    } else {
      return products;
    }
  }

  static void deleteProduct(String value) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('ProductData')
        .where('reference', isEqualTo: value)
        .get();
    snapshot.docs.forEach((doc) async {
      await doc.reference.delete();
    });
  }

  static Future<List> searchProductByChoiceForRows(
      String choice, String value) async {
    List products = [];
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('ProductData')
        .where(choice, isEqualTo: value)
        .limit(15) // limit to first 15 documents
        .get();
    snapshot.docs.forEach((element) {
      products.add(element.data());
    });
    if (products.isEmpty) {
      return ['product does not exist'];
    } else {
      return products;
    }
  }

  static Future<List> searchProductByChoice2(
      String choice, String value) async {
    List products = [];
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('ProductData')
        .where(choice, arrayContains: value)
        .get();
    snapshot.docs.forEach((element) {
      products.add(element.data());
    });
    if (products.isEmpty) {
      return ['product does not exist'];
    } else {
      return products;
    }
  }

  static Future<List> searchProduct(String value) async {
    List productsByName = await searchProductByChoice2('nameSearch', value);
    List productsByMainCat =
        await searchProductByChoice2('main_category_search', value);
    List productsBySubCat =
        await searchProductByChoice2('sub_category_search', value);
    List products = productsByName + productsByMainCat + productsBySubCat;
    if (products.isEmpty) {
      return ['product does not exist'];
    } else {
      return products;
    }
  }

  static Future<List> getAllProducts() async {
    List products = [];
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('ProductData').get();
    snapshot.docs.forEach((element) {
      products.add(element.data());
    });
    if (products.isEmpty) {
      return ['product does not exist'];
    } else {
      return products;
    }
  }

  static void addProductToUser(String userID, String productID) {
    FirebaseFirestore.instance
        .collection('UserData')
        .doc(userID)
        .get()
        .then((docSnapshot) {
      if (docSnapshot.exists) {
        List<String> ownedProducts =
            List<String>.from(docSnapshot.data()!['owned_products']);
        ownedProducts.add(productID);
        DataService.addUserData(
          full_name: docSnapshot.data()!['name'],
          phoneNumber: docSnapshot.data()!['phone_number'],
          user_type: docSnapshot.data()!['user_type'],
          isAdmin: docSnapshot.data()!['isAdmin'],
          owned_products: ownedProducts,
        );
      }
    });
  }

  static Future<List<Product>> searchProductByUser(String userUID) async {
    List<Product> products = [];
    final docSnapshot = await FirebaseFirestore.instance
        .collection('UserData')
        .doc(userUID)
        .get();
    if (docSnapshot.exists) {
      final userData = docSnapshot.data();
      List ownedProducts = userData?['owned_products'];

      if (ownedProducts != null) {
        for (final ref in ownedProducts) {
          if (ref != null) {
            products.add(await getProductsByReference(ref));
          }
        }
      }
      return products;
    } else {
      throw Exception('User data not found for user with ID: $userUID');
    }
  }
}
