import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/services.dart';

import 'product.dart';
import 'products_repository.dart';

class AppStateModel extends foundation.ChangeNotifier {
  // All the available products.
  List<Product> _availableProducts = [];

  // The currently selected category of products.
  Category _selectedCategory = Category.all;

  // The IDs and quantities of products currently in the cart.
  final _productsInCart = <int, int>{};

  Map<int, int> get productsInCart {
    return Map.from(_productsInCart);
  }

  // Total number of items in the cart.
  int get totalCartQuantity {
    return _productsInCart.values.fold(0, (accumulator, value) {
      return accumulator + value;
    });
  }

  Category get selectedCategory {
    return _selectedCategory;
  }

  // Totaled prices of the items in the cart.
  double get subtotalCost {
    return _productsInCart.keys.map((id) {
      // Extended price for product line
      return getProductById(id).price * _productsInCart[id]!;
    }).fold(0, (accumulator, extendedPrice) {
      return accumulator + extendedPrice;
    });
  }

  // Total cost to order everything in the cart.
  double get totalCost {
    return subtotalCost;
  }

  // Returns a copy of the list of available products, filtered by category.
  List<Product> getProducts() => switch (_selectedCategory) {
        Category.all => List.from(_availableProducts),
        _ => _availableProducts
            .where((p) => p.category == _selectedCategory)
            .toList(),
      };

  // Search the product catalog
  List<Product> search(String searchTerms) {
    return getProducts().where((product) {
      return product.name_en.toLowerCase().contains(searchTerms.toLowerCase());
    }).toList();
  }

  // Adds a product to the cart.
  void addProductToCart(int productId) {
    if (!_productsInCart.containsKey(productId)) {
      _productsInCart[productId] = 1;
    } else {
      _productsInCart[productId] = _productsInCart[productId]! + 1;
    }

    notifyListeners();
  }

  // Removes an item from the cart.
  void removeItemFromCart(int productId) {
    if (_productsInCart.containsKey(productId)) {
      if (_productsInCart[productId] == 1) {
        _productsInCart.remove(productId);
      } else {
        _productsInCart[productId] = _productsInCart[productId]! - 1;
      }
    }

    notifyListeners();
  }

  // Returns the Product instance matching the provided id.
  Product getProductById(int id) {
    return _availableProducts.firstWhere((p) => p.id == id);
  }

  // Removes everything from the cart.
  void clearCart() {
    _productsInCart.clear();
    notifyListeners();
  }

  // Loads the list of available products from the repo.
  void loadProducts() async {
    ProductsRepository repository =
        ProductsRepository(products: await loadMenuItems());
    _availableProducts = repository.loadProducts(Category.all);
    notifyListeners();
  }

  void setCategory(Category newCategory) {
    _selectedCategory = newCategory;
    notifyListeners();
  }
}

Future<List<Product>> loadMenuItems() async {
  List<Product> allMenuItems = [];
  final categoryMapping = {
    "デザート Dessert": Category.dessert,
    "丼・カレー Rice bowl / Curry": Category.rice,
    "麺類 Noodles": Category.noodle,
    "副菜 Side dish": Category.sideDish,
    "主菜 Main dish": Category.mainDish,
    // add the rest of your mappings here
    "All": Category.all,
    "Ethnic": Category.ethnic,
    "Quickbite": Category.quickbite,
  };

  String jsonString = await fetchJsonFromUrl();
  print(jsonString);
  List<dynamic> menuData = jsonDecode(jsonString);
  for (var menu in menuData) {
    allMenuItems.add(
      Product(
        category: categoryMapping[menu['category']] == null
            ? Category.all
            : categoryMapping[menu['category']]!,
        id: menu['id'],
        name_jp: menu['name_jp'],
        name_en: menu['name_en'],
        price: menu['price'],
        image: menu['image'],
        evaluation: Evaluation(
          good: menu['evaluation']['good'],
          average: menu['evaluation']['average'],
          bad: menu['evaluation']['bad'],
        ),
      ),
    );
  }
  return allMenuItems;
}

Future<String> fetchJsonFromUrl() async {
  final response = await http.get(Uri.parse(
      'https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menuitems.json?alt=media&token=2886306d-4d44-494a-a6a6-6985834b635c'));

  if (response.statusCode == 200) {
    // If the server returns a 200 OK response, then parse the JSON.
    return utf8.decode(response.bodyBytes);
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load data from server');
  }
}
