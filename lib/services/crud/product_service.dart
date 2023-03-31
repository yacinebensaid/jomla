import 'package:cloud_firestore/cloud_firestore.dart';
import 'crud_exceptions.dart';

class ProductService {
  static Future<String> productExists({
    required String mainCategory,
    required String reference,
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
        });
        return 'Product saved, Product $productName';
      } on FaildToRegisterProduct {
        return 'Could not register the product';
      }
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
}

/*
Future<List<Map<String, dynamic>>> searchProducts(String searchText) async {
  QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('ProductData').get();
  List<Map<String, dynamic>> products = [];

  querySnapshot.docs.forEach((doc) {
    if (doc['product_name'].toLowerCase().contains(searchText.toLowerCase()) ||
        doc['reference'].toLowerCase().contains(searchText.toLowerCase()) ||
        doc['description'].toLowerCase().contains(searchText.toLowerCase())) {
      products.add(doc.data());
    }
  });

  return products;
}
*/ 






/* 

searchindex



Future<List<Map<String, dynamic>>> searchProducts(String searchText) async {
  QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
      .collection('searchIndex')
      .where('searchableData', isGreaterThanOrEqualTo: searchText.toLowerCase())
      .where('searchableData', isLessThanOrEqualTo: searchText.toLowerCase() + '\uf8ff')
      .get();

  List<Map<String, dynamic>> products = [];

  querySnapshot.docs.forEach((doc) {
    String productId = doc.id;
    FirebaseFirestore.instance
        .collection('ProductData')
        .doc(productId)
        .get()
        .then((productSnapshot) {
      if (productSnapshot.exists) {
        products.add(productSnapshot.data()!);
      }
    });
  });

  return products;
}
*/