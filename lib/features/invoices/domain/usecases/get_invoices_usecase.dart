import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/invoices/domain/entities/index.dart';
import 'package:agrifober_resellers/features/invoices/domain/repositories/index.dart';

class GetInvoicesUseCase {
  final InvoicesRepository _repository;

  GetInvoicesUseCase(this._repository);

  Future<DataState<Pagination<Invoice>>> call({int page = 1}) async {
    return await _repository.getInvoices(page: page);
  }
}
