import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'documents_api_service.g.dart';

/// Raw PDF bytes; the file name comes from the `Content-Disposition` header.
@RestApi()
abstract class DocumentsApiService {
  factory DocumentsApiService(Dio dio, {String baseUrl}) = _DocumentsApiService;

  @GET("/v1/reseller/sales/{id}/pdf")
  @DioResponseType(ResponseType.bytes)
  Future<HttpResponse<List<int>>> getSalePdf(@Path("id") String id);

  @GET("/v1/reseller/delivery-notes/{id}/pdf")
  @DioResponseType(ResponseType.bytes)
  Future<HttpResponse<List<int>>> getDeliveryNotePdf(@Path("id") String id);

  @GET("/v1/reseller/invoices/{id}/pdf")
  @DioResponseType(ResponseType.bytes)
  Future<HttpResponse<List<int>>> getInvoicePdf(@Path("id") String id);
}
