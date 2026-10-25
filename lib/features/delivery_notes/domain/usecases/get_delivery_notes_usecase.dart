import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/delivery_notes/domain/entities/index.dart';
import 'package:agrifober_resellers/features/delivery_notes/domain/repositories/index.dart';

class GetDeliveryNotesUseCase {
  final DeliveryNotesRepository _repository;

  GetDeliveryNotesUseCase(this._repository);

  Future<DataState<Pagination<DeliveryNote>>> call({int page = 1}) async {
    return await _repository.getDeliveryNotes(page: page);
  }
}
