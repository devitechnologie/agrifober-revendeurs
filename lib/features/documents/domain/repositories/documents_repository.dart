import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/documents/domain/entities/index.dart';

abstract class DocumentsRepository {
  Future<DataState<DocumentFile>> downloadPdf({
    required DocumentKind kind,
    required String uid,
  });
}
