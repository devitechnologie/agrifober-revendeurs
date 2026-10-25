import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/delivery_notes/domain/entities/index.dart';
import 'package:agrifober_resellers/features/delivery_notes/domain/repositories/index.dart';

class GetDeliveryNoteUseCase {
  final DeliveryNotesRepository _repository;

  GetDeliveryNoteUseCase(this._repository);

  Future<DataState<DeliveryNoteDetails>> call(String uid) async {
    return await _repository.getDeliveryNote(uid: uid);
  }
}
