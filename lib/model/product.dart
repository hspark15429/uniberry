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

enum Cafeteria {
  OIC,
  BKC1,
  BKC2,
  BKC3,
  KIC1,
  KIC2,
  KIC3,
  all,
}

class Product {
  const Product({
    required this.cafeteria,
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
    required this.nutrition,
    required this.allergy,
    required this.origin,
  });

  final Cafeteria cafeteria;
  final Category category;
  final int id;
  final int price;
  final String name_jp;
  final String name_en;
  final String image;
  final Evaluation evaluation;
  final Nutrition nutrition;
  final List<dynamic> allergy;
  final String origin;

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

class Nutrition {
  const Nutrition({
    required this.energy,
    required this.protein,
    required this.fat,
    required this.carbohydrates,
    required this.salt,
    required this.calcium,
    required this.veg,
    required this.iron,
    required this.vitA,
    required this.vitB1,
    required this.vitB2,
    required this.vitC,
  });
  final double energy;
  final double protein;
  final double fat;
  final double carbohydrates;
  final double salt;
  final double calcium;
  final double veg;
  final double iron;
  final double vitA;
  final double vitB1;
  final double vitB2;
  final double vitC;
}
