import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/catalog/domain/entities/index.dart';
import 'package:agrifober_resellers/features/catalog/domain/repositories/index.dart';

class GetCatalogUseCase {
  final CatalogRepository _repository;

  GetCatalogUseCase(this._repository);

  Future<DataState<Catalog>> call({bool guest = false}) async {
    return await _repository.getCatalog(guest: guest);
  }
}
