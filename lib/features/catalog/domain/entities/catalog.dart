import 'package:equatable/equatable.dart';

class ProductCategory extends Equatable {
  final String uid;
  final String name;

  const ProductCategory({required this.uid, required this.name});

  @override
  List<Object?> get props => [uid, name];
}

/// A product the revendeur can order — only those with a reseller price.
class Product extends Equatable {
  final String uid;
  final String name;
  final String description;

  /// Cover photo, shown on the cards.
  final String imageUrl;

  /// Every photo, cover first (product screen slider). Empty without photo.
  final List<String> images;
  final String categoryUid;
  final double resellerPrice;

  /// "Prix public conseillé", when Agrifober set one.
  final double? retailPrice;

  const Product({
    required this.uid,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.images,
    required this.categoryUid,
    required this.resellerPrice,
    required this.retailPrice,
  });

  /// What the revendeur earns per unit when selling at the recommended retail
  /// price; null when there is no retail price or no margin.
  double? get unitMargin {
    final retail = retailPrice;
    if (retail == null || retail <= resellerPrice) return null;
    return retail - resellerPrice;
  }

  /// [unitMargin] as a share of the retail price (0.22 = 22 %).
  double? get marginRate {
    final margin = unitMargin;
    return margin == null ? null : margin / retailPrice!;
  }

  @override
  List<Object?> get props => [
    uid,
    name,
    description,
    imageUrl,
    images,
    categoryUid,
    resellerPrice,
    retailPrice,
  ];
}

class Catalog extends Equatable {
  final List<ProductCategory> categories;
  final List<Product> products;

  /// False in guest mode: the public catalogue carries no price, so every
  /// price, margin and "Ajouter" gives way to a sign-in prompt.
  final bool pricesVisible;

  const Catalog({
    required this.categories,
    required this.products,
    required this.pricesVisible,
  });

  @override
  List<Object?> get props => [categories, products, pricesVisible];
}
