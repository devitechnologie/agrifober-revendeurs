import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/documents/domain/entities/index.dart';
import 'package:agrifober_resellers/features/documents/domain/repositories/index.dart';

class DownloadDocumentUseCase {
  final DocumentsRepository _repository;

  DownloadDocumentUseCase(this._repository);

  Future<DataState<DocumentFile>> call(DocumentKind kind, String uid) async {
    return await _repository.downloadPdf(kind: kind, uid: uid);
  }
}
