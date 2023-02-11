import 'package:cloud_firestore/cloud_firestore.dart';

import '../../view/var_lib.dart';
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
    required String mainPhoto,
    required List photos,
    required String description,
  }) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('ProductData')
        .doc(mainCategory)
        .collection(subCategory)
        .doc(reference)
        .get();

    if (snapshot.exists) {
      return 'Product already exists';
    } else {
      try {
        FirebaseFirestore.instance
            .collection('ProductData')
            .doc(mainCategory)
            .collection(subCategory)
            .doc(reference)
            .set({
          'product name': productName,
          'available quantity': availableQuantity,
          'minimum quantity': minimumQuantity,
          'sizes': sizes,
          'price': price,
          'colors': colors,
          'main photo': mainPhoto,
          'photos': photos,
          'description': description,
        });
        return 'Product saved, Product $productName';
      } on FaildToRegisterProduct {
        return 'Could not register the product';
      }
    }
  }

  static void getAllProducts() {
    Map subCategories = get_subCategoriesOption();

    FirebaseFirestore.instance.collection('ProductData').get().then((value) => {
          value.docs.forEach((result) {
            final maincat = FirebaseFirestore.instance
                .collection('ProductData')
                .doc(result.id);
            for (String subcat in subCategories[result.id]) {
              maincat
                  .collection(subcat)
                  .get()
                  .then((newvalue) => newvalue.docs.forEach((element) {
                        print(result.id);
                        print(subcat);
                        print(element.id);
                        print(element.data());
                      }));
            }
          })
        });
  }
}
