import 'package:freezed_annotation/freezed_annotation.dart';
// local imports
import 'package:agrifober_resellers/features/catalog/domain/domain.dart';

part 'catalog_model.freezed.dart';
part 'catalog_model.g.dart';

@freezed
abstract class CatalogModel with _$CatalogModel {
  const factory CatalogModel({
    @Default([]) List<ProductCategoryModel> categories,
    @Default([]) List<ProductModel> products,
  }) = _CatalogModel;

  factory CatalogModel.fromJson(Map<String, dynamic> json) =>
      _$CatalogModelFromJson(json);
}

@freezed
abstract class ProductCategoryModel with _$ProductCategoryModel {
  const factory ProductCategoryModel({
    required String id,
    @Default('') String name,
  }) = _ProductCategoryModel;

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$ProductCategoryModelFromJson(json);
}

@freezed
abstract class ProductModel with _$ProductModel {
  const factory ProductModel({
    required String id,
    @Default('') String name,
    @Default('') String description,
    @JsonKey(name: 'image_url') @Default('') String imageUrl,
    @Default(<String>[]) List<String> images,
    @JsonKey(name: 'category_id') @Default('') String categoryId,
    @JsonKey(name: 'reseller_price') @Default(0) double resellerPrice,
    @JsonKey(name: 'retail_price') double? retailPrice,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
}

extension CatalogModelX on CatalogModel {
  Catalog toEntity({required bool pricesVisible}) => Catalog(
    pricesVisible: pricesVisible,
    categories: categories
        .map((c) => ProductCategory(uid: c.id, name: c.name))
        .toList(),
    products: products
        .map(
          (p) => Product(
            uid: p.id,
            name: p.name,
            description: p.description,
            imageUrl: p.imageUrl,
            // Older API builds only send the cover.
            images: p.images.isNotEmpty
                ? p.images
                : [if (p.imageUrl.isNotEmpty) p.imageUrl],
            categoryUid: p.categoryId,
            resellerPrice: p.resellerPrice,
            retailPrice: p.retailPrice,
          ),
        )
        .toList(),
  );
}
