import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/catalog/domain/entities/index.dart';

abstract class CatalogRepository {
  /// [guest]: the public catalogue, without prices (no session).
  Future<DataState<Catalog>> getCatalog({bool guest = false});
}
