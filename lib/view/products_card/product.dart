import 'package:jomla/services/crud/product_service.dart';

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
