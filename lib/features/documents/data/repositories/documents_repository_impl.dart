import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:retrofit/retrofit.dart';
// local imports
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/documents/data/datasources/index.dart';
import 'package:agrifober_resellers/features/documents/domain/domain.dart';

class DocumentsRepositoryImpl implements DocumentsRepository {
  final DocumentsApiService _apiService;

  DocumentsRepositoryImpl({required DocumentsApiService apiService})
    : _apiService = apiService;

  @override
  Future<DataState<DocumentFile>> downloadPdf({
    required DocumentKind kind,
    required String uid,
  }) async {
    // The web build is only a debugging aid: there is no file system to save to.
    if (kIsWeb) {
      return const DataState.failure(
        error: UnknownFailure(
          'Le téléchargement des PDF est disponible sur l\'application mobile.',
        ),
      );
    }

    try {
      final response = switch (kind) {
        DocumentKind.sale => await _apiService.getSalePdf(uid),
        DocumentKind.deliveryNote => await _apiService.getDeliveryNotePdf(uid),
        DocumentKind.invoice => await _apiService.getInvoicePdf(uid),
      };

      final fileName = _fileName(response, kind, uid);
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(response.data, flush: true);

      return DataState.success(
        data: DocumentFile(path: file.path, fileName: fileName),
      );
    } on DioException catch (e) {
      return DataState.failure(error: handleDioError(_decodeErrorBody(e)));
    } catch (e) {
      return DataState.failure(error: ServerFailure("Unexpected error: $e"));
    }
  }

  String _fileName(
    HttpResponse<List<int>> response,
    DocumentKind kind,
    String uid,
  ) {
    final disposition =
        response.response.headers.value('content-disposition') ?? '';
    final match = RegExp(r'filename="([^"]+)"').firstMatch(disposition);
    if (match != null) return match.group(1)!;

    final prefix = switch (kind) {
      DocumentKind.sale => 'achat',
      DocumentKind.deliveryNote => 'bon',
      DocumentKind.invoice => 'facture',
    };
    return '$prefix-$uid.pdf';
  }

  /// With `ResponseType.bytes` an error body arrives as bytes too: decode it
  /// so [handleDioError] can read the API's French `message`.
  DioException _decodeErrorBody(DioException e) {
    final data = e.response?.data;
    if (data is! List<int>) return e;
    try {
      final decoded = jsonDecode(utf8.decode(data));
      return e.copyWith(
        response: Response(
          requestOptions: e.requestOptions,
          statusCode: e.response?.statusCode,
          data: decoded,
        ),
      );
    } catch (_) {
      return e;
    }
  }
}
