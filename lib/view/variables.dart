export 'variables.dart';

get_colorOption() {
  return 'red,blue,green,yellow,black,white';
}

get_mainCategoryOptionAP() {
  return 'Clothing,Accessories,Electronics,Home,Kitchen,Beauty,Sports,Books,Industrial,Food';
}

get_sizeOption() {
  return 'XS,S,M,L,XL,XXL';
}

get_offerOption() {
  return [
    "Discounts",
    "Free Shipping",
    "Buy One Get One",
    "Gift with Purchase"
  ];
}

get_mainCategoryOptionEX() {
  return [
    "Clothing",
    "Accessories",
    "Electronics",
    "Home",
    "Kitchen",
    "Beauty",
    "Sports",
    "Books",
    "Industrial",
    "Food"
  ];
}

get_cateroriesInfo() {
  return {
    0: "assets/images/categories_imgs/Insta @marianaftm.jpg",
    1: "assets/images/categories_imgs/accessoire.jpg",
    2: "assets/images/categories_imgs/electronics.jpg",
    3: "assets/images/categories_imgs/home.jpg",
    4: "assets/images/categories_imgs/kitchen.jpg",
    5: "assets/images/categories_imgs/beauty.jpg",
    6: "assets/images/categories_imgs/sports.jpg",
    7: "assets/images/categories_imgs/books.jpg",
    8: "assets/images/categories_imgs/electricity.jpeg",
    9: "assets/images/categories_imgs/Food.jpg",
  };
}

get_subCategoriesOption() {
  return {
    'Clothing': ["Women's Clothing", "Men's Clothing", "Kids' Clothing,Shoes"],
    'Accessories': ["Handbags", "Jewelry", "Watches", "Sunglasses"],
    'Electronics': [
      "Phones",
      "Laptops",
      "Computers",
      "Tablets",
      "Cameras",
      "Home Appliances",
      "Television",
      "Gaming Consoles",
      "Audio & Video devices"
    ],
    'Home': [
      "Furniture",
      "Bedding",
      "Bath",
      "Home Decor",
      "Home Improvement",
      "Tools & Garden"
    ],
    'Kitchen': ["Kitchen", "Dining"],
    'Beauty': [
      "Skincare",
      "Hair Care",
      "Makeup",
      "Fragrances",
      "Personal Care",
      "Health Supplements"
    ],
    'Sports': [
      "Bicycles",
      "Fitness",
      "Camping & Hiking",
      "Sports Equipment",
      "Hunting & Fishing",
      "Water Sports",
      "Team Sports"
    ],
    'Books': [
      "Fiction",
      "Mystery",
      "Fantasy",
      "Romance",
      "Science Fiction",
      "Horror",
      "Historical",
      "Crime",
      "Children",
      "Educational",
      "Graphic Novels",
      "Comics",
      "Manga"
    ],
    'Industrial': [
      "Automotive Parts",
      "Accessories",
      "Industrial Supplies",
      "Power",
      "Hand Tools",
      "Safety & Security"
    ],
    'Food': ["Groceries", "Snacks", "Beverages", "Pet Supplies", "Supplements"],
  };
}
