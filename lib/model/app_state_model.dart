import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/services.dart';

import 'product.dart';
import 'products_repository.dart';

import 'package:firebase_storage/firebase_storage.dart';

class AppStateModel extends foundation.ChangeNotifier {
  // All the available products.
  List<Product> _availableProducts = [];

  // The currently selected category of products.
  Category _selectedCategory = Category.all;
  Cafeteria _selectedCafeteria = Cafeteria.OIC;

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

  Cafeteria get selectedCafeteria {
    return _selectedCafeteria;
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

  Nutrition get subtotalNutrition {
    var subtotalEnergy = 0.0;
    var subtotalProtein = 0.0;
    var subtotalFat = 0.0;
    var subtotalCarbohydrates = 0.0;
    var subtotalSalt = 0.0;
    var subtotalCalcium = 0.0;
    var subtotalVeg = 0.0;
    var subtotalIron = 0.0;
    var subtotalVitA = 0.0;
    var subtotalVitB1 = 0.0;
    var subtotalVitB2 = 0.0;
    var subtotalVitC = 0.0;
    _productsInCart.keys.forEach((id) {
      var product = getProductById(id);
      var quantity = _productsInCart[id]!;
      subtotalEnergy += product.nutrition.energy * quantity;
      subtotalProtein += product.nutrition.protein * quantity;
      subtotalFat += product.nutrition.fat * quantity;
      subtotalCarbohydrates += product.nutrition.carbohydrates * quantity;
      subtotalSalt += product.nutrition.salt * quantity;
      subtotalCalcium += product.nutrition.calcium * quantity;
      subtotalVeg += product.nutrition.veg * quantity;
      subtotalIron += product.nutrition.iron * quantity;
      subtotalVitA += product.nutrition.vitA * quantity;
      subtotalVitB1 += product.nutrition.vitB1 * quantity;
      subtotalVitB2 += product.nutrition.vitB2 * quantity;
      subtotalVitC += product.nutrition.vitC * quantity;
    });
    return Nutrition(
      energy: subtotalEnergy,
      protein: subtotalProtein,
      fat: subtotalFat,
      carbohydrates: subtotalCarbohydrates,
      salt: subtotalSalt,
      calcium: subtotalCalcium,
      veg: subtotalVeg,
      iron: subtotalIron,
      vitA: subtotalVitA,
      vitB1: subtotalVitB1,
      vitB2: subtotalVitB2,
      vitC: subtotalVitC,
    );
  }

  // Total cost to order everything in the cart.
  double get totalCost {
    return subtotalCost;
  }

  double get subNutrition {
    return _productsInCart.keys.map((id) {
      // Extended price for product line
      return getProductById(id).price * _productsInCart[id]!;
    }).fold(0, (accumulator, extendedPrice) {
      return accumulator + extendedPrice;
    });
  }

  // Returns a copy of the list of available products, filtered by category.
  List<Product> getProducts() => switch (_selectedCafeteria) {
        Cafeteria.all => List.from(_availableProducts),
        _ => _availableProducts
            .where((p) => p.cafeteria == _selectedCafeteria)
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
  void loadProducts({Category cat = Category.all}) async {
    ProductsRepository repository =
        ProductsRepository(products: await loadMenuItems());
    _availableProducts = repository.loadProducts(cat);
    notifyListeners();
  }

  void setCategory(Category newCategory) {
    _selectedCategory = newCategory;
    notifyListeners();
  }

  void setCafeteria(Cafeteria cafeteria) {
    _selectedCafeteria = cafeteria;
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

  final cafeteriaMapping = {
    "OIC": Cafeteria.OIC,
    "BKC1": Cafeteria.BKC1,
    "BKC2": Cafeteria.BKC2,
    "BKC3": Cafeteria.BKC3,
    "KIC1": Cafeteria.KIC1,
    "KIC2": Cafeteria.KIC2,
    "KIC3": Cafeteria.KIC3,
    "All": Cafeteria.all,
  };

  List<String> filepaths = [
    'menu/menuOIC.json',
    'menu/menuBKC1.json',
    'menu/menuBKC2.json',
    'menu/menuBKC3.json',
    'menu/menuKIC1.json',
    'menu/menuKIC2.json',
    'menu/menuKIC3.json',
  ];

  for (String filepath in filepaths) {
    String jsonString = await fetchJsonFromUrl(filepath);

    List<dynamic> menuData = jsonDecode(jsonString);
    for (var menu in menuData) {
      allMenuItems.add(
        Product(
          cafeteria: cafeteriaMapping[menu['cafeteria']] == null
              ? Cafeteria.all
              : cafeteriaMapping[menu['cafeteria']]!,
          category: categoryMapping[menu['category']] == null
              ? Category.all
              : categoryMapping[menu['category']]!,
          id: menu['id'],
          name_jp: menu['name_jp'],
          name_en: menu['name_en'],
          price: menu['price'],
          image: menu['image_appUrl'],
          evaluation: Evaluation(
            good: menu['evaluation']['good'],
            average: menu['evaluation']['average'],
            bad: menu['evaluation']['bad'],
          ),
          nutrition: Nutrition(
            energy: menu['nutrition']['energy'],
            protein: menu['nutrition']['protein'],
            fat: menu['nutrition']['fat'],
            carbohydrates: menu['nutrition']['carbohydrates'],
            salt: menu['nutrition']['salt'],
            calcium: menu['nutrition']['calcium'],
            veg: menu['nutrition']['veg'],
            iron: menu['nutrition']['iron'],
            vitA: menu['nutrition']['vitA'],
            vitB1: menu['nutrition']['vitB1'],
            vitB2: menu['nutrition']['vitB2'],
            vitC: menu['nutrition']['vitC'],
          ),
          allergy: menu['allergy'],
          origin: menu['origin'],
        ),
      );
    }
  }
  return allMenuItems;
}

Future<String> fetchJsonFromUrl(filepath) async {
  FirebaseStorage storage = FirebaseStorage.instance;
  Reference pathReference = storage.ref(filepath);
  String url = await pathReference.getDownloadURL();

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // If the server returns a 200 OK response, then parse the JSON.
    return utf8.decode(response.bodyBytes);
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load data from server');
  }
}

Future<String> fetchUrlFromStorage(String path) async {
  FirebaseStorage storage = FirebaseStorage.instance;
  Reference pathReference = storage.ref(path);
  String url = await pathReference.getDownloadURL();
  return url;
}
