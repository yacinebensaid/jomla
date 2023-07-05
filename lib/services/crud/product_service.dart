import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jomla/services/auth/auth_service.dart';
import 'package:jomla/services/crud/pcf_service.dart';
import 'package:jomla/services/crud/userdata_service.dart';
import 'package:jomla/view/products_card/product.dart';
import 'crud_exceptions.dart';

class ProductService {
  static Future<String> productExists({
    required String mainCategory,
    required String productName,
    required String subCategory,
    required List<Map<String, dynamic>> price,
    required String? availableQuantity,
    required String mainPhoto,
    required List<Map<String, Map?>> variations,
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
          'variations': variations,
          'price': price,
          'available_quantity': availableQuantity,
          'main_photo': mainPhoto,
          'photos': photos,
          'description': description,
          'owner': userUID,
          'section': '',
          'created_at': DateTime.now(),
          'buyers': [],
          'likers': [],
          'comments': []
        });
        addProductToUser(userUID, reference);
        return 'Product saved, Product $productName';
      } on FaildToRegisterProduct {
        return 'Could not register the product';
      }
    }
  }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  static Future<Product?> getProductDataByReference(
      String productReference) async {
    DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
        .collection('ProductData')
        .doc(productReference)
        .get();
    Product? productTem;
    if (productSnapshot.exists) {
      Map<String, dynamic> product =
          productSnapshot.data() as Map<String, dynamic>;
      productTem = Product(
          id: 0,
          offers: product['offers'],
          owner: product['owner'],
          variations: product['variations'],
          section: product['section'],
          likers: product['likers'],
          product_name: product['product_name'],
          reference: product['reference'],
          description: product['description'],
          main_photo: product['main_photo'],
          price: product['price'],
          main_category: product['main_category'],
          sub_category: product['sub_category'],
          available_quantity: product['available_quantity'] != null
              ? int.parse(product['available_quantity'])
              : null,
          photos: product['photos'],
          isFavourite:
              await UserPCFService.searchInFav(product['reference']) as bool,
          rating: 4.5);
    }

    return productTem;
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
      updatedFields['main_photo'] = main_photo;
    }
    if (productPhotos != null) {
      updatedFields['photos'] = productPhotos;
    }
    final userUID = AuthService.firebase().currentUser?.uid;
    updatedFields['edited_by'] = userUID;
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

  static Stream<List<Map<String, dynamic>>?> getCommentsStream(
      String reference) {
    return FirebaseFirestore.instance
        .collection('ProductData')
        .doc(reference)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data();
        if (data != null && data['comments'] is List) {
          final comments = data['comments'] as List;
          return comments.cast<Map<String, dynamic>>();
        }
      }

      return null;
    });
  }

  static void addComment(String reference, String uid, String comment) async {
    final documentRef =
        FirebaseFirestore.instance.collection('ProductData').doc(reference);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(documentRef);

      if (snapshot.exists) {
        final data = snapshot.data();
        if (data != null && data['comments'] is List) {
          final comments = List<Map<String, dynamic>>.from(data['comments']);
          comments.add({
            'uid': uid,
            'comment': comment,
            // Add any other fields you need for a comment
          });

          await transaction.update(documentRef, {'comments': comments});
        }
      }
    });
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

  static Future<List> getAllProductsforSearch() async {
    List products = [];
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('ProductData')
        .limit(3)
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
        DataService _dataServInstance = DataService();
        _dataServInstance.addUserData(
          following: docSnapshot.data()!['following'],
          full_name: docSnapshot.data()!['name'],
          phoneNumber: docSnapshot.data()!['phone_number'],
          user_type: docSnapshot.data()!['user_type'],
          isAdmin: docSnapshot.data()!['isAdmin'],
          owned_products: ownedProducts,
        );
      }
    });
  }

  static Future<List<Product>> searchProductByUser(String _userUID) async {
    List<Product> products = [];
    UserData? _userdata = await DataService.getUserDataStream(_userUID).first;

    if (_userdata != null) {
      if (_userdata.user_type == 'market') {
        List? ownedProducts = _userdata.owned_products;

        if (ownedProducts != null) {
          if (ownedProducts.isNotEmpty) {
            for (final ref in ownedProducts) {
              if (ref != null) {
                products.add(await getProductsByReference(ref));
              }
            }
          }
          return products;
        } else {
          throw Exception('User data not found for user with ID: $_userUID');
        }
      } else if (_userdata.user_type == 'dropshipper') {
        DropshipperData? dropshipperData =
            await DataService.getDropshipperData(_userdata.dropshipperID!)
                .first;
        if (dropshipperData != null) {
          List? ownedProducts = dropshipperData.owned_products;

          if (ownedProducts.isNotEmpty) {
            for (final ref in ownedProducts) {
              if (ref != null) {
                products.add(await getProductsByReference(ref));
              }
            }
          }
          return products;
        } else {
          throw Exception('User data not found for user with ID: $_userUID');
        }
      } else {
        throw Exception('User data not found for user with ID: $_userUID');
      }
    } else {
      throw Exception('User data not found for user with ID: $_userUID');
    }
  }
}
