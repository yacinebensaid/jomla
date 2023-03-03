import 'package:jomla/services/crud/product_service.dart';

import '../../services/crud/PCF_service.dart';

class Product {
  final String description,
      reference,
      product_name,
      price,
      main_photo,
      main_category,
      sub_category;
  final int id, available_quantity, minimum_quantity;
  final List sizes, colors, photos;
  final bool isFavourite, isPopular;
  final double rating;

  Product({
    required this.description,
    required this.reference,
    this.isFavourite = false,
    this.isPopular = true,
    required this.product_name,
    required this.main_photo,
    required this.price,
    required this.main_category,
    required this.sub_category,
    required this.available_quantity,
    required this.minimum_quantity,
    required this.sizes,
    required this.colors,
    required this.photos,
    required this.id,
    required this.rating,
  });
}

// Our demo Products

Future<List> getProducts() async {
  List productsRetrieving =
      await ProductService.searchProductByChoice('offers', 'Free Shipping');
  List<Product> products = [];
  int i = 0;
  for (Map product in productsRetrieving) {
    Product productTem = Product(
        id: i,
        product_name: product['product_name'],
        reference: product['reference'],
        description: product['description'],
        main_photo: product['main_photo'],
        price: product['price'],
        main_category: product['main_category'],
        sub_category: product['sub_category'],
        available_quantity: int.parse(product['available_quantity']),
        minimum_quantity: int.parse(product['minimum_quantity']),
        sizes: product['sizes'],
        colors: product['colors'],
        photos: product['photos'],
        rating: 4.5);
    products.add(productTem);
    i = i + 1;
  }
  return products;
}

Future<List> getProductsBySubCat(String subcat) async {
  List productsRetrieving =
      await ProductService.searchProductByChoice('sub_category', subcat);
  List<Product> products = [];
  int i = 0;
  for (Map product in productsRetrieving) {
    Product productTem = Product(
        id: i,
        product_name: product['product_name'],
        reference: product['reference'],
        description: product['description'],
        main_photo: product['main_photo'],
        price: product['price'],
        main_category: product['main_category'],
        sub_category: product['sub_category'],
        available_quantity: int.parse(product['available_quantity']),
        minimum_quantity: int.parse(product['minimum_quantity']),
        sizes: product['sizes'],
        colors: product['colors'],
        photos: product['photos'],
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
        product_name: product['product_name'],
        reference: product['reference'],
        description: product['description'],
        main_photo: product['main_photo'],
        price: product['price'],
        main_category: product['main_category'],
        sub_category: product['sub_category'],
        available_quantity: int.parse(product['available_quantity']),
        minimum_quantity: int.parse(product['minimum_quantity']),
        sizes: product['sizes'],
        colors: product['colors'],
        photos: product['photos'],
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
