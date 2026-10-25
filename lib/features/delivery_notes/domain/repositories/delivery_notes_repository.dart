import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/delivery_notes/domain/entities/index.dart';

abstract class DeliveryNotesRepository {
  Future<DataState<Pagination<DeliveryNote>>> getDeliveryNotes({
    int page = 1,
    int perPage = 20,
  });

  Future<DataState<DeliveryNoteDetails>> getDeliveryNote({required String uid});
}
