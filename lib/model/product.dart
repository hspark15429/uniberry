enum Category {
  all,
  mainDish,
  sideDish,
  rice,
  noodle,
  dessert,
  ethnic,
  quickbite,
}

class Product {
  const Product({
    required this.category,
    required this.id,
    // required this.id,
    // required this.isFeatured,
    // required this.name,
    // required this.price,
    required this.name_jp,
    required this.name_en,
    required this.price,
    required this.image,
    required this.evaluation,
  });

  final Category category;
  final int id;
  final int price;
  final String name_jp;
  final String name_en;
  final String image;
  final Evaluation evaluation;

  String get assetName => '$name_en-0.jpg';
  String get assetPackage => 'shrine_images';

  @override
  String toString() => '$name_en (id=$name_en)';
}

class Evaluation {
  const Evaluation({
    required this.good,
    required this.average,
    required this.bad,
  });
  final int good;
  final int average;
  final int bad;
}
