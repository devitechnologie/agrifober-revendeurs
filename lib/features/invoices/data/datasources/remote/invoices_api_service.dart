import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
// local imports
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/invoices/data/models/index.dart';

part 'invoices_api_service.g.dart';

@RestApi()
abstract class InvoicesApiService {
  factory InvoicesApiService(Dio dio, {String baseUrl}) = _InvoicesApiService;

  @GET("/v1/reseller/invoices")
  Future<PaginationResponse<InvoiceModel>> getInvoices({
    @Query("page") int? page,
    @Query("per_page") int? perPage,
  });
}
