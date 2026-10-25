import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
// local imports
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/catalog/domain/domain.dart';

part 'catalog_provider.g.dart';

/// Categories the app sells for now (matched on the name, case-insensitive).
/// Every other category — and its products — is hidden everywhere the
/// catalogue is read: shop, Accueil strip, product screen, reorder. Add a
/// name here to bring a category back.
const _visibleCategoryNames = {'engrais'};

@riverpod
Future<Catalog> catalog(Ref ref) async {
  // Signing in or out refetches: guests get the public, price-less catalogue.
  final uid = ref.watch(authProvider.select((auth) => auth.value?.uid));
  final result = await ref.read(getCatalogUseCaseProvider)(guest: uid == null);
  final catalog = result.when(
    success: (data) => data,
    failure: (error) => throw error,
  );
  final categories = catalog.categories
      .where((c) => _visibleCategoryNames.contains(c.name.trim().toLowerCase()))
      .toList();
  final categoryUids = {for (final c in categories) c.uid};
  return Catalog(
    pricesVisible: catalog.pricesVisible,
    categories: categories,
    products: catalog.products
        .where((p) => categoryUids.contains(p.categoryUid))
        .toList(),
  );
}

/// Search box text on the catalogue screen.
@riverpod
class CatalogQueryNotifier extends _$CatalogQueryNotifier {
  @override
  String build() => '';

  void set(String value) => state = value;
}

/// Selected category chip; null = every category.
@riverpod
class CatalogCategoryNotifier extends _$CatalogCategoryNotifier {
  @override
  String? build() => null;

  void set(String? categoryUid) => state = categoryUid;
}
