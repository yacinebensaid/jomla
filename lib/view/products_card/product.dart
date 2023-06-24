import 'package:jomla/services/crud/pcf_service.dart';
import 'package:jomla/services/crud/product_service.dart';

class Product {
  final String description,
      reference,
      product_name,
      main_photo,
      main_category,
      section,
      sub_category,
      owner;
  final int id;
  final String? offers;
  final int? available_quantity;
  final List photos, likers, price;
  final List? variations;
  final bool isFavourite;
  final double rating;

  Product(
      {required this.description,
      this.variations,
      required this.owner,
      required this.reference,
      required this.isFavourite,
      required this.section,
      required this.likers,
      required this.product_name,
      required this.main_photo,
      required this.price,
      required this.main_category,
      required this.sub_category,
      required this.available_quantity,
      required this.photos,
      required this.id,
      required this.rating,
      required this.offers});
}

// Our demo Products

Future<List<Product>> getProductsForPopular() async {
  List productsRetrieving =
      await ProductService.searchProductByChoiceForRows('section', 'popular');
  List<Product> products = [];
  int i = 0;
  for (Map product in productsRetrieving) {
    Product productTem = Product(
        id: i,
        offers: product['offers'],
        variations: product['variations'],
        likers: product['likers'],
        owner: product['owner'],
        section: product['section'],
        product_name: product['product_name'],
        reference: product['reference'],
        description: product['description'],
        main_photo: product['main_photo'],
        price: product['price'],
        main_category: product['main_category'],
        sub_category: product['sub_category'],
        available_quantity: int.parse(product['available_quantity']),
        photos: product['photos'],
        isFavourite:
            await UserPCFService.searchInFav(product['reference']) as bool,
        rating: 4.5);
    products.add(productTem);
    i = i + 1;
  }
  return products;
}

Future<List> getProductsForOnSale() async {
  List productsRetrieving =
      await ProductService.searchProductByChoiceForRows('section', 'on_sale');
  List<Product> products = [];
  int i = 0;
  for (Map product in productsRetrieving) {
    Product productTem = Product(
        id: i,
        offers: product['offers'],
        variations: product['variations'],
        owner: product['owner'],
        section: product['section'],
        likers: product['likers'],
        product_name: product['product_name'],
        reference: product['reference'],
        description: product['description'],
        main_photo: product['main_photo'],
        price: product['price'],
        main_category: product['main_category'],
        sub_category: product['sub_category'],
        available_quantity: int.parse(product['available_quantity']),
        photos: product['photos'],
        isFavourite:
            await UserPCFService.searchInFav(product['reference']) as bool,
        rating: 4.5);
    products.add(productTem);
    i = i + 1;
  }
  return products;
}

Future<List> getProductsForNew() async {
  List productsRetrieving =
      await ProductService.searchProductByChoiceForRows('section', 'new');
  List<Product> products = [];
  int i = 0;
  for (Map product in productsRetrieving) {
    Product productTem = Product(
        id: i,
        offers: product['offers'],
        owner: product['owner'],
        variations: product['variations'],
        section: product['section'],
        product_name: product['product_name'],
        reference: product['reference'],
        description: product['description'],
        likers: product['likers'],
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
    products.add(productTem);
    i = i + 1;
  }
  return products;
}

Future<List<Product>> getProductsBySubCat(String subcat) async {
  List productsRetrieving =
      await ProductService.searchProductByChoiceForRows('sub_category', subcat);
  List<Product> products = [];
  int i = 0;
  for (Map product in productsRetrieving) {
    Product productTem = Product(
        id: i,
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
        available_quantity: int.parse(product['available_quantity']),
        photos: product['photos'],
        isFavourite:
            await UserPCFService.searchInFav(product['reference']) as bool,
        rating: 4.5);
    products.add(productTem);
    i = i + 1;
  }
  return products;
}

Future getProductsByReference(String reference) async {
  List productsRetrieving =
      await ProductService.searchProductByChoice('reference', reference);
  int i = 0;
  for (Map product in productsRetrieving) {
    Product productTem = Product(
        id: i,
        offers: product['offers'],
        owner: product['owner'],
        variations: product['variations'],
        likers: product['likers'],
        section: product['section'],
        product_name: product['product_name'],
        reference: product['reference'],
        description: product['description'],
        main_photo: product['main_photo'],
        price: product['price'],
        main_category: product['main_category'],
        sub_category: product['sub_category'],
        available_quantity: int.parse(product['available_quantity']),
        photos: product['photos'],
        isFavourite:
            await UserPCFService.searchInFav(product['reference']) as bool,
        rating: 4.5);
    return productTem;
  }
}

class ProductForCart {
  final String reference, quantity, total_price, main_photo, product_name;
  final int id;
  ProductForCart(
      {required this.quantity,
      required this.reference,
      required this.total_price,
      required this.id,
      required this.main_photo,
      required this.product_name});
}

///////////////////////////////cart///////////////////////////////////////////////////////

class ShoppingCart {
  static int totalCartPrice = 0;
  static Future<int> passPrice(int price) async {
    return price;
  }

  static Future<String> getTotalCartPrice() async {
    return totalCartPrice.toString();
  }

  static Future<List> getProductsForCart() async {
    List productsRetrieving = await UserPCFService.getCart();

    Future mainPhotoGetter(String reference) async {
      Product product = await getProductsByReference(reference);
      return product.main_photo;
    }

    Future productNameGetter(String reference) async {
      Product product = await getProductsByReference(reference);
      return product.product_name;
    }

    List<ProductForCart> products = [];
    int cartPrice = 0;
    int i = 0;
    for (Map product in productsRetrieving) {
      ProductForCart productTem = ProductForCart(
        id: i,
        reference: product['reference'],
        quantity: product['quantity'],
        total_price: product['total_price'],
        main_photo: await mainPhotoGetter(product['reference']),
        product_name: await productNameGetter(product['reference']),
      );
      products.add(productTem);
      cartPrice = cartPrice + int.parse(product['total_price']);
      i = i + 1;
    }
    totalCartPrice = cartPrice;
    return products;
  }
}

//////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////pending/////////////////////////////////////////////

class PendingCart {
  static int totalCartPrice = 0;
  static Future<int> passPrice(int price) async {
    return price;
  }

  static Future<String> getTotalCartPrice() async {
    return totalCartPrice.toString();
  }

  static Future<List> getProductsForPending() async {
    List productsRetrieving = await UserPCFService.getPending();

    Future mainPhotoGetter(String reference) async {
      Product product = await getProductsByReference(reference);
      return product.main_photo;
    }

    Future productNameGetter(String reference) async {
      Product product = await getProductsByReference(reference);
      return product.product_name;
    }

    List<ProductForCart> products = [];
    int cartPrice = 0;
    int i = 0;
    for (Map product in productsRetrieving) {
      ProductForCart productTem = ProductForCart(
        id: i,
        reference: product['reference'],
        quantity: product['quantity'],
        total_price: product['total_price'],
        main_photo: await mainPhotoGetter(product['reference']),
        product_name: await productNameGetter(product['reference']),
      );
      products.add(productTem);
      cartPrice = cartPrice + int.parse(product['total_price']);
      i = i + 1;
    }
    totalCartPrice = cartPrice;
    return products;
  }
}

/////////////////////////////////////////////////////////////////////////////////////

Future<List<Product>> getProductsForFavourite() async {
  Future<List> productRefGetter() async {
    List products = await UserPCFService.getFav();
    return products;
  }

  Future<List> searchingForProducts() async {
    List productsRetrieving = [];
    for (final product in await productRefGetter()) {
      productsRetrieving.add(await ProductService.searchProductByChoice(
          'reference', product['reference']));
    }
    return productsRetrieving;
  }

  List<Product> products = [];
  for (List prod in await searchingForProducts()) {
    for (final variable in prod) {
      if (variable.runtimeType == String) {
        UserPCFService.deletefromfav(variable);
      } else {
        int i = 0;
        for (Map product in prod) {
          Product productTem = Product(
              id: i,
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
              available_quantity: int.parse(product['available_quantity']),
              photos: product['photos'],
              isFavourite:
                  await UserPCFService.searchInFav(product['reference'])
                      as bool,
              rating: 4.5);
          products.add(productTem);
          i = i + 1;
        }
      }
    }
  }
  return products;
}

///////////////////////////////purchased///////////////////////////////////////////

class ProductForPurchased {
  final String reference,
      quantity,
      total_price,
      main_photo,
      product_name,
      purchasedID;
  final int id;
  ProductForPurchased({
    required this.quantity,
    required this.reference,
    required this.total_price,
    required this.id,
    required this.main_photo,
    required this.product_name,
    required this.purchasedID,
  });
}

class PurchasedCart {
  static int totalCartPrice = 0;
  static Future<int> passPrice(int price) async {
    return price;
  }

  static Future<String> getTotalCartPrice() async {
    return totalCartPrice.toString();
  }

  static Future<List> getProductsForPurchased() async {
    List productsRetrieving = await UserPCFService.getPurchased();

    Future mainPhotoGetter(String reference) async {
      Product product = await getProductsByReference(reference);
      return product.main_photo;
    }

    Future productNameGetter(String reference) async {
      Product product = await getProductsByReference(reference);
      return product.product_name;
    }

    List<ProductForPurchased> products = [];
    int cartPrice = 0;
    int i = 0;
    for (Map product in productsRetrieving) {
      ProductForPurchased productTem = ProductForPurchased(
        id: i,
        reference: product['reference'],
        quantity: product['quantity'],
        total_price: product['total_price'],
        main_photo: await mainPhotoGetter(product['reference']),
        product_name: await productNameGetter(product['reference']),
        purchasedID: product['purchaseID'],
      );
      products.add(productTem);
      cartPrice = cartPrice + int.parse(product['total_price']);
      i = i + 1;
    }
    totalCartPrice = cartPrice;
    return products;
  }
}

/////////////////////////////////////////////////////////////////////////////////////

Future<List> getAllProductsForSearch() async {
  List productsRetrieving = await ProductService.getAllProducts();
  List<Product> products = [];
  int i = 0;
  for (Map product in productsRetrieving) {
    Product productTem = Product(
        id: i,
        offers: product['offers'],
        section: product['section'],
        variations: product['variations'],
        owner: product['owner'],
        likers: product['likers'],
        product_name: product['product_name'],
        reference: product['reference'],
        description: product['description'],
        main_photo: product['main_photo'],
        price: product['price'],
        main_category: product['main_category'],
        sub_category: product['sub_category'],
        available_quantity: int.parse(product['available_quantity']),
        photos: product['photos'],
        isFavourite:
            await UserPCFService.searchInFav(product['reference']) as bool,
        rating: 4.5);
    products.add(productTem);
    i = i + 1;
  }
  return products;
}
