import 'product.dart';

class ProductsRepository {
  final products;

  const ProductsRepository({
    required this.products,
  });

  List<Product> loadProducts(Category category) => switch (category) {
        Category.all => products,
        _ => products.where((p) => p.category == category).toList(),
      };
}
