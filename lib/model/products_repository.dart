import 'dart:convert';

import 'package:flutter/services.dart';

import 'product.dart';

class ProductsRepository {
  final products;

  const ProductsRepository({
    required this.products,
  });
  static const List<Product> _allProducts = <Product>[
    Product(
      category: Category.noodle,
      id: 2,
      name_jp: "チキン甘辛ステーキ",
      name_en: "Grilled fried chicken",
      price: 500,
      image: "https://placehold.co/600x400",
      evaluation: Evaluation(
        good: 328,
        average: 4,
        bad: 4,
      ),
    ),
  ];

  List<Product> loadProducts(Category category) => switch (category) {
        Category.all => products,
        _ => products.where((p) => p.category == category).toList(),
      };
}
