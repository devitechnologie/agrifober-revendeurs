import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
// local imports
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/delivery_notes/data/models/index.dart';

part 'delivery_notes_api_service.g.dart';

@RestApi()
abstract class DeliveryNotesApiService {
  factory DeliveryNotesApiService(Dio dio, {String baseUrl}) =
      _DeliveryNotesApiService;

  @GET("/v1/reseller/delivery-notes")
  Future<PaginationResponse<DeliveryNoteModel>> getDeliveryNotes({
    @Query("page") int? page,
    @Query("per_page") int? perPage,
  });

  @GET("/v1/reseller/delivery-notes/{id}")
  Future<StandardResponse<DeliveryNoteModel>> getDeliveryNote(
    @Path("id") String id,
  );
}
